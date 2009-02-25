
package org.bigbluebutton.conference

import org.testng.annotations.*
import org.bigbluebutton.conference.RoomsManager
import org.bigbluebutton.conference.Room
import org.bigbluebutton.conference.Participant
import org.testng.Assert

public class RoomsManagerTest{
	RoomsManager rm
	Room r
	Participant p
	
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
	}

	@Test
	public void getParticipantsTest() {
	   Assert.assertTrue(rm.getRoom("test-room").numberOfParticipants == 1, "There is exactly one participant in test-room")
	}

}
