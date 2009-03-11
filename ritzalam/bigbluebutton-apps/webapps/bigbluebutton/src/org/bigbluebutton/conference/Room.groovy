
package org.bigbluebutton.conference

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import net.jcip.annotations.ThreadSafeimport java.util.concurrent.ConcurrentHashMapimport java.util.concurrent.CopyOnWriteArrayListimport java.util.Collections
/**
 * Contains information about a Room and it's Participants. 
 * Encapsulates Participants and RoomListeners.
 */
@ThreadSafe
public class Room {
	protected static Logger log = LoggerFactory.getLogger( Room.class )
	
	private final String name
	private final Map <Long, Participant> participants	
	private final Map <Long, Participant> unmodifiableMap
	private final List<IRoomListener> listeners

	public Room(String name) {
		this.name = name
		participants = new ConcurrentHashMap<Long, Participant>()
		unmodifiableMap = Collections.unmodifiableMap(participants)
		listeners   = new CopyOnWriteArrayList<IRoomListener>()
	}
	
	public String getName() {
		return name
	}
	
	public void addRoomListener(IRoomListener listener) {
		if (! listeners.contains(listener)) {
			log.debug("adding room listener")
			listeners.add(listener)			
		}
	}
	
	public void removeRoomListener(IRoomListener listener) {
		log.debug("removing room listener")
		listeners.remove(listener)		
	}
	
	public void addParticipant(Participant participant) {
//		synchronized (this) {
			log.debug("adding participant ${participant.userid}")
			participants.put(participant.userid, participant)
//			unmodifiableMap = Collections.unmodifiableMap(participants)
//		}
		log.debug("addparticipant - informing roomlisteners ${listeners.size()}")
		for (IRoomListener listener : listeners) {
			log.debug("calling participantJoined on listener")
			listener.participantJoined(participant)
		}
	}
	
	public void removeParticipant(Long userid) {
		def present = false
		synchronized (this) {
			present = participants.containsKey(userid)
			if (present) {
				log.debug("removing participant")
				participants.remove(userid)
			}
		}
		if (present) {
			for (IRoomListener listener : listeners) {
				listener.participantLeft(userid)
			}
		}
	}
	
	public void changeParticipantStatus(Long userid, String status, Object value) {
		def present = false
		synchronized (this) {
			present = participants.containsKey(userid)
			if (present) {
				log.debug("change participant status")
				Participant p = participants.get(userid)
				p.setStatus(status, value)
				unmodifiableMap = Collections.unmodifiableMap(participants)
			}
		}
		if (present) {
			for (IRoomListener listener : listeners) {
				listener.participantStatusChange(userid, status, value)
			}
		}		
	}
	
	public Map getParticipants() {
		return unmodifiableMap
	}	
	
	public int getNumberOfParticipants() {
		log.debug("Returning number of participants: " + participants.size())
		return participants.size()
	}
	
}
