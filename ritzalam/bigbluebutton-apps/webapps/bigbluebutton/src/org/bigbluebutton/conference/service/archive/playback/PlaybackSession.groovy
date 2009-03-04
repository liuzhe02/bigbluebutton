package org.bigbluebutton.conference.service.archive.playback
import java.util.concurrent.ConcurrentHashMap
public class PlaybackSession{

	private final String conference
	private final String room
	private final String name
	private final Map<String, IPlaybackNotifier> notifiers
	private final IPlaybackJobScheduler scheduler
	private final IPlaybackPlayer player
	private Map messageToSend
	
	public PlaybackSession(String conference, String room, String name) {
		this.name = name
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
		player.initialize()
		player.start()
	}
	
	public void stopPlayback() {
		player.stop()
	}
	
	public void pausePlayback() {
		player.pause()
	}	
	
	private Map initializingMessage() {
		Map m = new HashMap()
		m.put("date", new Date() + 1000)
		m.put("application", "PLAYBACK")
		m.put("event", "InitializeEvent")
		m.put("message", "Initializing...")
	}
}
