
package org.bigbluebutton.conference

import org.red5.server.api.so.ISharedObject
public class RoomListener implements IRoomListener{

	private ISharedObject so;
	
	public RoomListener(ISharedObject so) {
		this.so = so 
	}
	
	public void participantStatusChange(String userid, String status, Object value){
		so.sendMessage("participantStatusChange", [userid, status, value])
	}
	
	public void participantJoined(Participant participant) {
		List args = new ArrayList()
		args.add(participant.toMap())
		so.sendMessage("participantJoined", args)
	}
	
	public void participantLeft(String userid) {		
		List args = new ArrayList()
		args.add(userid)
		so.sendMessage("participantLeft", args)
	}
	
}
