package org.bigbluebutton.conference.service.archive
import java.util.concurrent.ConcurrentHashMap
public class PlaybackSession{

	private final String conference
	private final String room
	private final String name
	private final Map<String, IPlaybackNotifier> notifiers
	private final IPlaybackJobScheduler scheduler
	private final IPlaybackPlayer player
	
	public PlaybackSession(String conference, String room, String session) {
		name = session
		this.room = room
		this.conference = conference
		notifiers = new ConcurrentHashMap<String, IPlaybackNotifier>()
		player = new FileReaderPlaybackPlayer(conference, room)
	}
	
	public String getName() {
		return name
	}
	
	public void addPlaybackNotifier(String name, IPlaybackNotifier notifier) {
		notifiers.put(name, notifier)
	}
	
	public void removePlaybackNotifier(String name) {
		notifiers.remove(name)
	}
	
	public void setPlaybackJobScheduler(IPlaybackJobScheduler scheduler) {
		this.scheduler = scheduler
	}
	
	public void startPlayback() {
		player.start()
	}
	
	public void stopPlayback() {
		player.stop()
	}
	
	public void pausePlayback() {
		player.pause()
	}
	
	
	
}
