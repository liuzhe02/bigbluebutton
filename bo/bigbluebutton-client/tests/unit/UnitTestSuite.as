package
{
	import net.digitalprimates.fluint.tests.TestSuite;

 	import org.bigbluebutton.modules.login.model.services.LoginServiceTestCase;
 	import org.bigbluebutton.modules.login.view.components.LoginWindowTestCase;

	public class UnitTestSuite extends TestSuite
	{
		public function UnitTestSuite()
		{
			super();
			
			/*
			//will LoginServiceTestCase
			addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signInAAAAA", "Bo", "1", "1"));
			*/
			
			//with LoginWindowTestCase
			addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signInAAAAA", "Bo", "1", "1"));
			
		}
		
	}
}