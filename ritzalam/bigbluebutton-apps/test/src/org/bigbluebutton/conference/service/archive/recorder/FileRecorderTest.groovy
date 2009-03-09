
package org.bigbluebutton.conference.service.archive.recorder

import org.testng.annotations.BeforeMethodimport org.testng.annotations.Testimport org.bigbluebutton.conference.service.archive.record.FileRecorderimport org.ho.yaml.YamlDecoder
public class FileRecorderTest{
	FileRecorder recorder
	String conference = "test-conference"
	String room = "test-room"
	File recordingsDir
		
	@BeforeMethod
	public void setUp() {
		recorder = new FileRecorder(conference, room)
		recordingsDir = new File('build/test/resources')
		if (! recordingsDir.exists())
			recordingsDir.mkdirs()
		recorder.setRecordingsDirectory(recordingsDir.canonicalPath)
		recorder.initialize()
		println recordingsDir.canonicalPath
	}

	@Test
	public void writeEventToFileTest() {
		Map event = new HashMap()
		event.put("date", 1236202122980)
		event.put("application", "PARTICIPANT")
		event.put("event", "ParticipantJoinedEvent")
		Map status = new HashMap()
		event.put("status", status)
		status.put("raiseHand", true)
		status.put("presenter", true)
		status.put("stream", "my-video-stream")

		
		Map event3 = new HashMap()
		event3.put("date", 1236202122980)
		event3.put("application", "PARTICIPANT")
		event3.put("event", "ParticipantJoinedEvent")
		Map status1 = new HashMap()
		event3.put("status", status1)
		status1.put("raiseHand", false)
		status1.put("presenter", false)
		status1.put("stream", "my-video-stream-1")
		
		recorder.recordEvent(event)
		recorder.recordEvent(event3)
		
		Map event1 = new HashMap()
		event1.put("date", 1236202132980)
		event1.put("application", "PARTICIPANT")
		event1.put("event", "ParticipantJoinedEvent")
		event1.put("message", "Las Vegas, Nevada, USA")
		
		recorder.recordEvent(event1)
		
		File recordingFile = new File("$recordingsDir.canonicalPath/$conference/$room/recordings.yaml" )
		
//		 Let's read back the saved data.
        YamlDecoder dec = new YamlDecoder(recordingFile.newInputStream());
        def eventList = []
        try{
          while (true){
            Map eventRead = dec.readObject();
            eventList.add(eventRead)
          }
        }catch (EOFException e){
          println("Finished reading stream.");
        }finally {
          dec.close();
        }
        
        assert eventList.size() == 3
		assert eventList[0].date == 1236202122980
		assert eventList[0]['application'] == 'PARTICIPANT'
		assert eventList[0]['event'] == 'ParticipantJoinedEvent'
	}
	
}
