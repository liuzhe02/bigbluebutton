package org.bigbluebutton.conference.service.archive.playback
import java.util.concurrent.ConcurrentHashMap
public class PlaybackSession {

	private final String conference
	private final String room
	private final String name
	private final Map<String, IPlaybackNotifier> notifiers
	private final IPlaybackPlayer player
	private Map currentMessage
	private Map nextMessage
	private boolean playing = false
	private boolean initialMessage = true
	private long playbackTime = 0
	
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
	
	public void startPlayback() {
		player.initialize()
		playing = true
		initialMessage = true
		currentMessage = initialMessage()
		nextMessage = player.getMessage()
		// Let's wait 1 second to play this message
		playbackTime = 1000L
	}
	
	public void stopPlayback() {
		player.reset()
		playing = false
	}
	
	public void playMessage() {
		if (playing) {
			IPlaybackNotifier n = notifiers.get(currentMessage.application)
			n.sendMessage(currentMessage)
			currentMessage = nextMessage
			nextMessage = player.getMessage()
			playbackTime = new Long(currentMessage["date"].longValue()) - 
								new Long(nextMessage["date"].longValue())
		}
	}
	
	public void pausePlayback() {
		playing = false
	}	
	
	public void resumePlayback() {
		playing = true
	}
		
	public long playMessageIn() {
		playbackTime
	}
		
	private Map initializingMessage() {
		Map m = new HashMap()
		m.put("date", new Date() + 1000L)
		m.put("application", "PLAYBACK")
		m.put("event", "InitializeEvent")
		m.put("message", "Initializing...")
	}
}
