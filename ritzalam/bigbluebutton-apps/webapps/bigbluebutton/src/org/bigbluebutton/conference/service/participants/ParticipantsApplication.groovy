
package org.bigbluebutton.conference.service.participants


import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.Mapimport org.bigbluebutton.conference.RoomsManager
import org.bigbluebutton.conference.Roomimport org.bigbluebutton.conference.Participantimport org.bigbluebutton.conference.IRoomListener
public class ParticipantsApplication {

	protected static Logger log = LoggerFactory.getLogger( ParticipantsApplication.class );	
	protected static Logger recorder = LoggerFactory.getLogger( "RECORD-BIGBLUEBUTTON" );
	
	private static final String APP = "PARTICIPANTS";
	private RoomsManager roomsManager
	
	public boolean addRoomListener(String room, IRoomListener listener) {
		if (roomsManager.hasRoom(room)){
			roomsManager.getRoom(room).addRoomListener(listener)
			return true
		}
		return false
	}
	
	
	public Map getParticipants(String roomName) {
		log.debug("${APP}:getParticipants")
		Room room = roomsManager.getRoom(roomName)
		
		Map participants = new HashMap()
		participants.put("count", room.numberOfParticipants)
		if (room.numberOfParticipants > 0) {
			/**
			 * Somehow we need to convert to Map so the client will be
			 * able to decode it. Need to figure out if we can send Participant
			 * directly. (ralam - 2/20/2009)
			 */
			Collection pc = room.participants.values()
    		Map pm = new HashMap()
    		for (Iterator it = pc.iterator(); it.hasNext();) {
    			Participant ap = (Participant) it.next();
    			pm.put(ap.userid, ap.toMap()); 
    		}  
			participants.put("participants", pm)
		}
		log.debug("${APP}:getParticipants " + participants.get("count"))
		return participants
	}
	
	public boolean participantLeft(String roomName, String userid) {
		if (roomsManager.hasRoom(roomName)) {
			Room room = roomsManager.getRoom(roomName)
			room.removeParticipant(userid)
			return true;
		}

		return false;
	}
	
	public boolean participantJoin(String roomName, String userid, String username, String role, Map status) {
	
		if (roomsManager.hasRoom(roomName)) {
			Participant p = new Participant(userid, username, role, status)			
			Room room = roomsManager.getRoom(roomName)
			room.addParticipant(p)
			return true
		}
		return false;
	}
	
	public void setRoomsManager(RoomsManager r) {
		roomsManager = r
	}
}
