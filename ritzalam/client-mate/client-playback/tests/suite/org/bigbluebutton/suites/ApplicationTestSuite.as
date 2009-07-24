package org.bigbluebutton.suites
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	import org.bigbluebutton.common.TestAsync;
	import org.bigbluebutton.main.services.ConfigLoaderTest;
	import org.bigbluebutton.main.services.JoiningParticipantTest;
	import org.bigbluebutton.main.services.ModeInitializerTest;

	public class ApplicationTestSuite extends TestSuite
	{
		public function ApplicationTestSuite()
		{
			super();
			addTestCase( new ConfigLoaderTest() ); 
			addTestCase( new TestAsync() );       
			addTestCase( new ModeInitializerTest());
			addTestCase( new JoiningParticipantTest());
		}
		
	}
}