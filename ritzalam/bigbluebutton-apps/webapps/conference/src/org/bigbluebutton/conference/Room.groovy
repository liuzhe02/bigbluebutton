
package org.bigbluebutton.conference

import org.slf4j.Loggerimport org.slf4j.LoggerFactory

public class Room{
	
	/** The Constant log. */
	protected static Logger log = LoggerFactory.getLogger( Room.class );
	
	/** Conference room name. */
	private String room;
	
	/** List of participants of the conference room. */ 
	private Map <Integer, Participant> participants = new HashMap<Integer, Participant>();
	
	/**
	 * Constructor.
	 * 
	 * @param room conference room ID
	 * @param modPass moderator password
	 * @param viewPass viewer password
	 */
	public Room(String room)
	{
		this.room = room;
	}


	/**
	 * Gets the room.
	 * 
	 * @return the room
	 */
	public String getRoom() {
		return room;
	}

	/**
	 * This method adds new participants to the list of participants of the conference room.
	 * 
	 * @param participant the participant
	 */
	public void addParticipant(Participant participant) {
		participants.put(participant.userid, participant);
		log.debug("Added participant[" + participant.userid + "," + 
				participants.size() + "]");
	}
	
	/**
	 * Removes the participant.
	 * 
	 * @param userid the userid
	 */
	public void removeParticipant(Integer userid) {
		participants.remove(userid);
	}
	
	/**
	 * Gets the participants.
	 * 
	 * @return the participants
	 */
	public ArrayList<Participant> getParticipants() {
		return new ArrayList<Participant>(participants.values());
	}
	
	
}
