
package org.bigbluebutton.conference.service.participants

import org.testng.annotations.*
import org.bigbluebutton.conference.RoomsManagerimport org.bigbluebutton.conference.Roomimport org.bigbluebutton.conference.Participantimport org.testng.Assert
class ParticipantsApplicationTest{
	RoomsManager rm
	Room r
	Participant p
	ParticipantsApplication pa
	
	@BeforeTest
	public void setUp() {
	    rm = new RoomsManager()
	    r = new Room("test-room")
		Map status = new HashMap()
		status.put("raiseHand", false)
		status.put("presenter", false)
		status.put("hasStream", false)
		p = new Participant(1.toString(), 'Test User', 'MODERATOR', status)
	    r.addParticipant(p)
	    rm.addRoom(r)
	    pa.setRoomsManager(rm)
	}

	@Test
	public void getParticipantsTest() {
		Map pm = pa.getParticipants("test-room")
	    Assert.assertTrue(pm.get("count") == 1, "There should only be one participants in the room.")
	}
	
}
