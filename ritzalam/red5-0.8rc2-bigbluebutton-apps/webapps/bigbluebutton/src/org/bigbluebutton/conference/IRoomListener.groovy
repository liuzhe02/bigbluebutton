
package org.bigbluebutton.conference

public interface IRoomListener {

	public void participantStatusChange(String userid, String status, Object value);
	public void participantJoined(Participant participant);
	public void participantLeft(String userid);
}
