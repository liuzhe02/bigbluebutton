
package org.bigbluebutton.conference.service.archive


public interface IPlaybackPlayer{

	public void start();	
	public void stop();	
	public void pause();
	public void resume();
	public void addMessageNotifier(IPlayMessageNotifier notifier);
	public void playMessage();
}
