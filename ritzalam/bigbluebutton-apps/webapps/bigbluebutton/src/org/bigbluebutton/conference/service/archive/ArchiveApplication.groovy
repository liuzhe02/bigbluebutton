
package org.bigbluebutton.conference.service.archive

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.concurrent.ConcurrentHashMapimport org.bigbluebutton.conference.service.archive.playback.*import org.bigbluebutton.conference.service.archive.record.*
import org.bigbluebutton.conference.service.archive.record.IRecorderimport org.bigbluebutton.conference.service.archive.record.FileRecorderimport org.bigbluebutton.conference.service.archive.playback.IPlaybackNotifierimport org.bigbluebutton.conference.service.archive.playback.PlaybackSessionimport org.bigbluebutton.conference.service.archive.playback.IPlaybackPlayerimport org.bigbluebutton.conference.service.archive.playback.FileReaderPlaybackPlayer
public class ArchiveApplication {
	protected static Logger log = LoggerFactory.getLogger( ArchiveApplication.class )
	
	private final Map<String, PlaybackSession> playbackSessions
	private final Map<String, RecordSession> recordSessions
	private final PlaybackJobScheduler playbackScheduler
	private final String recordingsDirectory
	
	public ArchiveApplication() {
		playbackSessions = new ConcurrentHashMap<String, PlaybackSession>()
		recordSessions = new ConcurrentHashMap<String, RecordSession>()
		log.debug("Instantiated ArchiveApplication")
	}
	
	public void destroyPlaybackSession(String sessionName) {
		playbackSessions.remove(sessionName)
	}

	/**
	 * Creates a playback session if there wasn't one created already.
	 */
	public void createPlaybackSession(String conference, String room, String sessionName) {
		PlaybackSession session
		IPlaybackPlayer player
		def createdSession = false
		synchronized (this) {
			if (playbackSessions.containsKey(sessionName)) {
				session = new PlaybackSession(sessionName)
				playbackSessions.put(session.name, session)
				createdSession = true
			}
		}
		if (createdSession) {
			player = new FileReaderPlaybackPlayer(conference, room)
			player.setRecordingsBaseDirectory(recordingsDirectory)
			session.setPlaybackPlayer(player)						
		}

	}
	
	public void removeRecordSession(String room) {
		recordSessions.remove(room)
	}
	
	/**
	 * Creates a record session if there wasn't one created already.
	 */
	public void createRecordSession(String conference, String room, String sessionName) {
		RecordSession recordSession
		IRecorder recorder
		def createdSession = false
		synchronized (this) {
			if (recordSessions.containsKey(sessionName)) {
				recorder = new FileRecorder(conference, room)
				recordSessions.put(session.name, session)				
				createdSession = true
			}
		}
		if (createdSession) {
			recordSession = new RecordSession(sessionName)
			recorder.setRecordingsDirectory(recordingsDirectory)
			recorder.initialize()
		}		
	}
	
	public void addPlaybackNotifier(String sessionName, IPlaybackNotifier notifier) {
		if (playbackSessions.containsKey(sessionName)) {
			PlaybackSession session = playbackSessions.get(sessionName)
			session.addPlaybackNotifier(notifier.notifierName(), notifier)
		}
	}
	
	public void startPlayback(String name) {
		PlaybackSession session = playbackSessions.get(name)
		if (session != null) {
			// Initialize the session.
			session.startPlayback()
			playbackScheduler.schedulePlayback(session)			
		}
	}
	
	public void stopPlayback(String name) {
		PlaybackSession session = playbackSessions.get(name)
		if (session != null) {
			session.stopPlayback()	
		}
	}
	
	public void pausePlayback(String name) {
		PlaybackSession session = playbackSessions.get(name)
		if (session != null) {
			session.pausePlayback()	
		}
	}
	
	public void resumePlayback(String name) {
		PlaybackSession session = playbackSessions.get(name)
		if (session != null) {
			session.resumePlayback()	
			playbackScheduler.schedulePlayback(session)
		}
	}
	
	public void setPlaybackJobScheduler(PlaybackJobScheduler scheduler) {
		log.debug("Setting playbackScheduler")
		playbackScheduler = scheduler
		playbackScheduler.start()
	}
	
	public void setRecordingsDirectory(String directory) {
		log.debug("Setting recordings directory to $directory")
		this.recordingsDirectory = directory
	}
}
