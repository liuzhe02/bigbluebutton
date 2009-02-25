
package org.bigbluebutton.conference

import org.slf4j.Logger
import org.slf4j.LoggerFactory

public class Room {
	protected static Logger log = LoggerFactory.getLogger( Room.class )
	
	private Map <String, Participant> participants = new HashMap<String, Participant>()
	private String name
	private Set<IRoomListener> listeners = new HashSet<IRoomListener>()

	public Room(String name) {
		this.name = name
	}
	
	public String getName() {
		return name
	}
	
	public void addRoomListener(IRoomListener listener) {
		log.debug("adding room listener")
		listeners.add(listener)
	}
	
	public void removeRoomListener(IRoomListener listener) {
		log.debug("removing room listener")
		listeners.remove(listener)		
	}
	
	public void addParticipant(Participant participant) {
		log.debug("adding participant ${participant.userid}")
		participants.put(participant.userid, participant)
		log.debug("addparticipant - informing roomlisteners ${participant.userid}")
		for (IRoomListener listener : listeners) {
			listener.participantJoined(participant)
		}
	}
	
	public void removeParticipant(String userid) {
		log.debug("removing participant")
		participants.remove(userid)
		for (IRoomListener listener : listeners) {
				listener.participantLeft(userid)
		}
	}
	
	public void changeParticipantStatus(String userid, String status, Object value) {
		log.debug("change participant status")
		if (participants.containsKey(userid)) {
			Participant p = participants.get(userid)
			p.setStatus(status, value)
			
			for (IRoomListener listener : listeners) {
				listener.participantStatusChange(userid, status, value)
			}
		}		
	}
	
	public Map getParticipants() {
		return participants
	}	
	
	public int getNumberOfParticipants() {
		log.debug("Returning number of participants: " + participants.size())
		return participants.size()
	}
	
}
