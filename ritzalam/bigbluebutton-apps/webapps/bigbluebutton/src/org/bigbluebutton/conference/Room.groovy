
package org.bigbluebutton.conference

public class Room {

	private Map <String, Participant> participants = new HashMap<String, Participant>();
	
	private String name;
	
	public Room(String name) {
		this.name = name
	}
	
	public String getName() {
		return name
	}
	
	public void addParticipant(Participant participant) {
		participants.put(participant.userid, participant);
	}
	
	public void removeParticipant(String userid) {
		participants.remove(userid);
	}
	
	public Map getParticipants() {
		return participants;
	}	
	
	public int getNumberOfParticipants() {
		return participants.size()
	}
	
}
