
package org.bigbluebutton.conference

import org.testng.annotations.*
import groovy.mock.interceptor.StubForimport org.testng.Assertimport static org.easymock.EasyMock.*

public class RoomTest{
	Room r
	Participant p1
	IRoomListener mock
	Participant p2
	
	@BeforeMethod
	public void setUp() {
	    r = new Room("test")
	    Map status = new HashMap()
		status.put("raiseHand", false)
		status.put("presenter", false)
		status.put("hasStream", false)
		def key1 = 1
		def key2 = 2
		p1 = new Participant(key1, 'Test User 1', 'MODERATOR', status)
	    p2 = new Participant(key2, 'Test User 2', 'VIEWER', status)
	    mock = createMock(IRoomListener.class)
	}

	@Test
	public void callListenerOnAddParticipantTest() {
		expect(mock.participantJoined(p1))
		replay(mock)
		r.addRoomListener(mock)
	    r.addParticipant(p1)
	    verify(mock)
	}

	@Test
	public void addTwoParticipantsTest() {
	    r.addParticipant(p1)
	    r.addParticipant(p2)
	    Assert.assertEquals(r.getNumberOfParticipants(), 2, "There should be 2 participants.")
	    Map mp = r.getParticipants()
	    Assert.assertEquals(mp.size(), 2, "There should be 2 participants.")
	    Participant ap =  mp.get(new Long(2))
	    Assert.assertNotNull(ap)
	}
	
	@Test
	public void removeParticipantsTest() {
		expect(mock.participantJoined(p1))
		expect(mock.participantJoined(p2))
		expect(mock.participantLeft(p1.userid))
		replay(mock)
		r.addRoomListener(mock)
	    r.addParticipant(p1)
	    r.addParticipant(p2)
	    Assert.assertEquals(r.getNumberOfParticipants(), 2, "There should be 2 participants.")
	    r.removeParticipant(new Long(1))
	    verify(mock)
	    Assert.assertEquals(r.getNumberOfParticipants(), 1, "There should be 1 participant left.")
	    Map mp = r.getParticipants()
	    Assert.assertEquals(mp.size(), 1, "There should be 1 participant.")
	    Participant ap =  mp.get(new Long(2))
	    Assert.assertNotNull(ap)
	}
	
	@Test
	public void changeParticipantStatusTest() {
		expect(mock.participantJoined(p1))
		expect(mock.participantJoined(p2))
		expect(mock.participantStatusChange(p1.userid, "presenter", true))
		replay(mock)
		r.addRoomListener(mock)
	    r.addParticipant(p1)
	    r.addParticipant(p2)
	    Assert.assertEquals(r.getNumberOfParticipants(), 2, "There should be 2 participants.")
	    r.changeParticipantStatus(new Long(1), "presenter", true)
	    verify(mock)
	    Map mp = r.getParticipants()
	    Assert.assertEquals(mp.size(), 2, "There should be 2 participants.")
	    Participant ap =  mp.get(new Long(1))
	    Assert.assertNotNull(ap)
	    Assert.assertTrue(ap.status.get("presenter"), "Presenter status for participant should be true")
	}
}
