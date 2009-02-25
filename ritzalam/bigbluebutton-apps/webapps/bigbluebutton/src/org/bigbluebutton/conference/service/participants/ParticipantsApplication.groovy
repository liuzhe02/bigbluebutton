
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
	
	public boolean createRoom(String name) {
		roomsManager.addRoom(new Room(name))
		return true
	}
	
	public boolean destroyRoom(String name) {
		if (roomsManager.hasRoom(name)) {
			roomsManager.removeRoom(name)
		}
		return true
	}
	
	public boolean addRoomListener(String room, IRoomListener listener) {
		if (roomsManager.hasRoom(room)){
			roomsManager.getRoom(room).addRoomListener(listener)
			return true
		}
		return false
	}
		
	public Map getParticipants(String roomName) {
		log.debug("${APP}:getParticipants - ${roomName}")
		if (! roomsManager.hasRoom(roomName)) {
			log.error("Could not find room ${roomName}")
			return null
		}
		
		Room room = roomsManager.getRoom(roomName)
		log.debug("Found room ${roomName}")
		Map participants = new HashMap()
		log.debug("Getting number of participants.")
		participants.put("count", room.numberOfParticipants)
		log.debug("${APP}:gotParticipants ")
		log.debug("${APP}:gotParticipants " + participants.get("count"))
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
		log.debug("${APP}:participant joining room ${roomName}")
		if (roomsManager.hasRoom(roomName)) {
			Participant p = new Participant(userid, username, role, status)			
			Room room = roomsManager.getRoom(roomName)
			room.addParticipant(p)
			log.debug("${APP}:participant joined room ${roomName}")
			return true
		}
		log.debug("${APP}:participant failed to join room ${roomName}")
		return false
	}
	
	public void setRoomsManager(RoomsManager r) {
		log.debug("Setting room manager")
		roomsManager = r
	}
}
