
package org.bigbluebutton.conference.service.archive

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.concurrent.ConcurrentHashMapimport org.bigbluebutton.conference.service.archive.playback.*import org.bigbluebutton.conference.service.archive.playback.PlaybackJobScheduler
public class ArchiveApplication {
	protected static Logger log = LoggerFactory.getLogger( ArchiveApplication.class )
	
	private final Map<String, PlaybackSession> playbackSessions
	private final Map<String, RecordSession> recordSessions
	private final PlaybackJobScheduler playbackScheduler
	
	
	public ArchiveApplication() {
		playbackSessions = new ConcurrentHashMap<String, PlaybackSession>()
		recordSessions = new ConcurrentHashMap<String, RecordSession>()
	}
	
	public void removePlaybackSession(String room) {
		playbackSessions.remove(room)
	}
	
	public void removeRecordSession(String room) {
		recordSessions.remove(room)
	}
	
	public void addPlaybackSession(PlaybackSession session) {
		playbackSessions.put(session.name, session)
	}
	
	public void addRecordSession(RecordSession session) {
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
}
