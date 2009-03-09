
package org.bigbluebutton.conference.service.archive.recorder

import org.testng.annotations.BeforeMethodimport org.testng.annotations.Testimport org.bigbluebutton.conference.service.archive.record.RecordSessionimport org.bigbluebutton.conference.service.archive.record.IRecorderimport org.bigbluebutton.conference.service.archive.record.IEventRecorder
public class RecordSessionTest{
	RecordSession session
	
	@BeforeMethod
	public void setUp() {
		session = new RecordSession('test-conference', 'test-room')
	}

	@Test
	public void recordSessionTest() {
		Map event1 = new HashMap()
		event1.put("date", 1236202132980)
		event1.put("application", "PARTICIPANT")
		event1.put("event", "ParticipantJoinedEvent")
		event1.put("message", "Las Vegas, Nevada, USA")
		
		def sampleEventRecorder = {
				assert event1 == it
		}
		def r = [recordEvent:sampleEventRecorder] as IRecorder
		session.setRecorder(r)
		def recorderPassedFromRecordSession
		def eventRecorderMockAcceptRecorderMethod = {
			recorderPassedFromRecordSession = it
		}
		def eventRecorderMockRecordEventMethod = {
			recorderPassedFromRecordSession.recordEvent(it)
		}
		
		def eventRecorderMock = [acceptRecorder:eventRecorderMockAcceptRecorderMethod, recordEvent:eventRecorderMockRecordEventMethod] as IEventRecorder
		session.addEventRecorder(eventRecorderMock)
		eventRecorderMock.recordEvent(event1)
	}		
	
}
