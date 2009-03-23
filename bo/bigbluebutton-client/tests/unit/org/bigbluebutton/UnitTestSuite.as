package org.bigbluebutton
{
	import net.digitalprimates.fluint.tests.TestSuite;

 	import org.bigbluebutton.modules.login.model.services.LoginServiceTestCase;

	public class UnitTestSuite extends TestSuite
	{
		public function UnitTestSuite()
		{
			super();
			
			addTestCase(new LoginServiceTestCase("Bo", "1", "1", "http://localhost:8080/bigbluebutton/join/signIn"));
			addTestCase(new LoginServiceTestCase("Bo", "1", "2", "http://localhost:8080/bigbluebutton/join/signIn"));
			addTestCase(new LoginServiceTestCase("Bo", "1", "1", "http://localhost:8080/bigbluebutton/join/signIn"));
			addTestCase(new LoginServiceTestCase("Bo", "1", "2", "http://localhost:8080/bigbluebutton/join/signIn"));
			addTestCase(new LoginServiceTestCase("Bo", "1", "1", "http://localhost:8080/bigbluebutton/join/signIn"));
		}
		
	}
}