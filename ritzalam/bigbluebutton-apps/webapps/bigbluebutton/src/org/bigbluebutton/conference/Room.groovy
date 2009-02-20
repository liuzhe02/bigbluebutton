
package org.bigbluebutton.conference

public class Room {

	private Map <String, Map> participants = new HashMap<String, Map>();
	
	private String name;
	
	public Room(String name) {
		this.name = name
	}
	
	public String getName() {
		return name
	}
	
	public void addParticipant(Map participant) {
		participants.put(participant.get("userid"), participant);
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
