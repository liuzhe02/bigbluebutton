
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
		Map m = recordedEvents[eventNumber.andIncrement]
		return m
	}
	
	public void start(){		
		eventNumber.set(0)
	}
	
	public void stop(){
		eventNumber.set(0)
	}
	
	public void pause(){
		// TODO Auto-generated method stub
	}
	
	public void resume() {
		
	}
	
	public void playMessage() {
		
	}
	
	public void setRecordingsBaseDirectory(String directory) {
		recordingsBaseDirectory = directory
	}
}
