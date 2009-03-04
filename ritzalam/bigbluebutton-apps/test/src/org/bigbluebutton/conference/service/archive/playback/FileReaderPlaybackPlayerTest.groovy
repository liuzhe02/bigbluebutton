
package org.bigbluebutton.conference.service.archive.playback

import org.testng.annotations.BeforeMethodimport org.testng.annotations.Test
public class FileReaderPlaybackPlayerTest{

	def FileReaderPlaybackPlayer fPlayer
	
	@BeforeMethod
	public void setUp() {
		// Lets find the path to test/resources directory
		File f = new File("findPath")
		fPlayer = new FileReaderPlaybackPlayer('test', 'resources')		
		File f2 = new File(f.absolutePath)
		fPlayer.setRecordingsBaseDirectory(f2.parent)
		fPlayer.initialize()
		println "file ${f2.absolutePath} ${f2.parent}"
	}

	@Test
	public void getMessageTest() {
		println fPlayer.getMessage()
		println fPlayer.getMessage()
		println fPlayer.getMessage()
		println fPlayer.getMessage()
	}	
	
}
