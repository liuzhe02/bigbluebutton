
package org.bigbluebutton.conference.service.archive

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.concurrent.ConcurrentHashMapimport org.bigbluebutton.conference.service.archive.playback.*import org.bigbluebutton.conference.service.archive.record.*

public class ArchiveApplication {
	protected static Logger log = LoggerFactory.getLogger( ArchiveApplication.class )
	
	private final Map<String, PlaybackSession> playbackSessions
	private final Map<String, RecordSession> recordSessions
	private final PlaybackJobScheduler playbackScheduler
	private final String recordingsDirectory
	
	public ArchiveApplication() {
		playbackSessions = new ConcurrentHashMap<String, PlaybackSession>()
		recordSessions = new ConcurrentHashMap<String, RecordSession>()
	}
	
	public void destroyPlaybackSession(String sessionName) {
		playbackSessions.remove(sessionName)
	}

	public void createPlaybackSession(String conference, String room, String sessionName) {
		PlaybackSession session = new PlaybackSession(sessionName)
		IPlaybackPlayer player = new FileReaderPlaybackPlayer(conference, room)
		player.setRecordingsBaseDirectory(recordingsDirectory)
		playbackSessions.put(session.name, session)
	}
	
	public void removeRecordSession(String room) {
		recordSessions.remove(room)
	}
	
	public void createRecordSession(String conference, String room, String sessionName) {
		RecordSession recordSession = new RecordSession(sessionName)
		
		recordSession.put(session.name, session)
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
		playbackScheduler = scheduler
	}
	
	public void setRecordingsDirectory(String directory) {
		this.recordingsDirectory = directory
	}
}
