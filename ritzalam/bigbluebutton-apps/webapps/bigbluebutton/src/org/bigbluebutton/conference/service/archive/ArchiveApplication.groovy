
package org.bigbluebutton.conference.service.archive

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.concurrent.ConcurrentHashMap
public class ArchiveApplication{
	protected static Logger log = LoggerFactory.getLogger( ArchiveApplication.class )
	
	private final Map<String, PlaybackSession> playbackSessions
	private final Map<String, RecordSession> recordSessions
	
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
	
}
