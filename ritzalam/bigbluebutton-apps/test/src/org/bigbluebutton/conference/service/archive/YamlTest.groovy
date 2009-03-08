
package org.bigbluebutton.conference.service.archive

import org.testng.annotations.BeforeMethodimport org.testng.annotations.Testimport org.ho.yaml.Yaml
import org.ho.yaml.YamlEncoderimport org.ho.yaml.YamlDecoder
public class YamlTest{
	File f 
	File yamlOutFile
	
	@BeforeMethod
	public void setUp() {
		f = new File('test/resources/recordings.yaml')
		println f.absolutePath
		File yamlOutFileDir = new File('build/test/resources')
		if (! yamlOutFileDir.exists())
			yamlOutFileDir.mkdirs()
		yamlOutFile = new File('build/test/resources/yaml-output.yaml')
		println yamlOutFile.canonicalPath
	}

	@Test
	public void writeYamlToFileTest() {
		Map event = new HashMap()
		event.put("date", 1236202122980)
		event.put("application", "PARTICIPANT")
		event.put("event", "ParticipantJoinedEvent")
		Map status = new HashMap()
		event.put("status", status)
		status.put("raiseHand", true)
		status.put("presenter", true)
		status.put("stream", "my-video-stream")
    
		Map event1 = new HashMap()
		event1.put("date", 1236202132980)
		event1.put("application", "PARTICIPANT")
		event1.put("event", "ParticipantJoinedEvent")
		event1.put("message", "Las Vegas, Nevada, USA")

		// We'll save multiple YAML document into the file. 
		YamlEncoder enc = new YamlEncoder(yamlOutFile.newOutputStream());
        enc.writeObject(event);
        enc.writeObject(event1);
        enc.close();
        
        // Let's read back the saved data.
        YamlDecoder dec = new YamlDecoder(yamlOutFile.newInputStream());
        def eventList = []
        try{
          while (true){
            Map eventRead = dec.readObject();
            println eventRead.date
            eventList.add(eventRead)
          }
        }catch (EOFException e){
          println("Finished reading stream.");
        }finally {
          dec.close();
        }
        
        assert eventList.size() == 2
		assert eventList[0].date == 1236202122980
		assert eventList[0]['application'] == 'PARTICIPANT'
	}
	
	@Test
	public void simpleYamlTest() {
			def eventRead = Yaml.load(new File(f.absolutePath))
			assert eventRead[0].date == 1236202122980
			assert eventRead[0]['application'] == 'PARTICIPANT'
			assert eventRead.size() == 5
			println Yaml.dump(eventRead)
	}	
}
