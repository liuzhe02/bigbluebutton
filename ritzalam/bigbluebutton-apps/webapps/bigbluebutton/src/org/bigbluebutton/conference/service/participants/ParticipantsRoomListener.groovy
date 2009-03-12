
package org.bigbluebutton.conference.service.participants

import org.red5.server.api.so.ISharedObjectimport org.bigbluebutton.conference.IRoomListener
import org.bigbluebutton.conference.Participant
import org.bigbluebutton.conference.service.archive.record.IEventRecorder
public class ParticipantsRoomListener implements IRoomListener{

	private ISharedObject so
	private IEventRecorder recorder
	
	public ParticipantsRoomListener(ISharedObject so, IEventRecorder recorder) {
		this.so = so 
		this.recorder = recorder
	}
	
	def getName() {
		return 'TEMPNAME'
	}
	
	public void participantStatusChange(Long userid, String status, Object value){
		so.sendMessage("participantStatusChange", [userid, status, value])
	}
	
	public void participantJoined(Participant p) {
		List args = new ArrayList()
		args.add(p.toMap())
		so.sendMessage("participantJoined", args)
	}
	
	public void participantLeft(Long userid) {		
		List args = new ArrayList()
		args.add(userid)
		so.sendMessage("participantLeft", args)
	}
}
