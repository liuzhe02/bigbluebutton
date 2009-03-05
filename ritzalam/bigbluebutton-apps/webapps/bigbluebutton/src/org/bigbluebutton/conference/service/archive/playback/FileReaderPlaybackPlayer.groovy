
package org.bigbluebutton.conference.service.archive.playback

import org.ho.yaml.Yaml
import java.util.concurrent.atomic.AtomicIntegerpublic class FileReaderPlaybackPlayer implements IPlaybackPlayer{
	
	private final String conference
	private final String room
	private final File file
	def recordedEvents
	def playerReady = false
	private final AtomicInteger eventNumber = new AtomicInteger(0)
	def recordingsBaseDirectory
	
	public FileReaderPlaybackPlayer(String conference, String room) {
		this.conference = conference
		this.room = room
	}
	
	public void initialize() {
		recordedEvents = Yaml.load(new File("${recordingsBaseDirectory}/${conference}/${room}/recordings.yaml"))
		if (recordedEvents != null) {
			playerReady = true
		}
	}
	
	public Map getMessage() {
		if ((int)eventNumber < recordedEvents.size()){
			return recordedEvents[eventNumber.andIncrement]
		}
		return null
	}
	
	public boolean isReady() {
		return playerReady
	}
	
	public void reset() {
		eventNumber.set(0)
	}
	
	public int getEventNumber() {
		eventNumber
	}
	
	public int numberOfEvents() {
		return recordedEvents.size()
	}
	
	public void setRecordingsBaseDirectory(String directory) {
		recordingsBaseDirectory = directory
	}
}
