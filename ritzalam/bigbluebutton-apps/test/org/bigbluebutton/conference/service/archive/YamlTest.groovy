
package org.bigbluebutton.conference.service.archive

import org.testng.annotations.BeforeMethodimport org.testng.annotations.Testimport org.ho.yaml.Yaml

public class YamlTest{
	File f 
	
	@BeforeMethod
	public void setUp() {
		f = new File('test/resources/test.yaml')
		println f.absolutePath
	}

	@Test
	public void filepathTest() {
		
	}
	
	@Test
	public void sipleYamlTest() {
			def player = Yaml.load(new File(f.absolutePath))
			assert player[0].Birthplace == "Las Vegas, Nevada, USA"
			assert player[0]['Turned Pro'] == 1986
	}

	public void anotherSipleYamlTest() {
			def input = '''
			---
			time: 20:03:20
			player: Sammy Sosa
			action: strike (miss)
			...
			---
			time: 20:03:47
			player: Sammy Sosa
			action: grand slam
			...
			'''

			def play = Yaml.load(input)
			print play
			play = Yaml.load(input)
			print play
//			assert play.time == "20:03:47"
//			assert player.player == "Sammy Sosa"


	}	
	
}
