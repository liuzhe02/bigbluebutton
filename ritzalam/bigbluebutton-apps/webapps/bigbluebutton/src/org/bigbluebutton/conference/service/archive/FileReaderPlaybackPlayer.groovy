
package org.bigbluebutton.conference.service.archive

public class FileReaderPlaybackPlayer implements IPlaybackPlayer{
	
	private final String conference
	private final String room
	private final File file
	
	public FileReaderPlaybackPlayer(String conference, String room) {
		this.conference = conference
		this.room = room
	}
	
	public void start(){
		// TODO Auto-generated method stub
	}
	
	public void stop(){
		// TODO Auto-generated method stub
	}
	
	public void pause(){
		// TODO Auto-generated method stub
	}
	
	public void resume() {
		
	}
	
	public void playMessage() {
		
	}
	
	public void addMessageNotifier(IPlayMessageNotifier arg0){
		// TODO Auto-generated method stub
	}
	
}
