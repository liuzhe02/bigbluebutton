
package org.bigbluebutton.conference

public class Room {

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
		listeners.add(listener)
	}
	
	public void removeRoomListener(IRoomListener listener) {
		listeners.remove(listener)		
	}
	
	public void addParticipant(Participant participant) {
		participants.put(participant.userid, participant)
		for (IRoomListener listener : listeners) {
				listener.participantJoined(participants)
		}
	}
	
	public void removeParticipant(String userid) {
		participants.remove(userid)
		for (IRoomListener listener : listeners) {
				listener.participantLeft(userid)
		}
	}
	
	public void changeParticipantStatus(String userid, String status, Object value) {
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
		return participants.size()
	}
	
}
