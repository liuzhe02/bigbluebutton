package org.bigbluebutton.suites
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	import org.bigbluebutton.common.TestAsync;
	import org.bigbluebutton.common.TestCase1;
	import org.bigbluebutton.main.services.ModeInitializerTest;
	
	public class MainTestSuite extends TestSuite
	{
		public function MainTestSuite() {
			addTestCase( new TestCase1() ); 
			addTestCase( new TestAsync() );       
			addTestCase( new ModeInitializerTest());
		}
	}
}