package org.bigbluebutton.conference.service.archive.playback

import org.testng.annotations.BeforeMethodimport org.testng.annotations.Testimport org.testng.Assert
public class PlaybackSessionTest{
	PlaybackSession session
	
	@BeforeMethod
	public void setUp() {
		session = new PlaybackSession('test', 'resources', 'session-name')
	}
	
	@Test
	public void playbackTimeTest() {
		session.startPlayback()
		Assert.assertEquals(session.playbackTime, 1000L, "Playback time should be 1 second.")
	}
	
}
