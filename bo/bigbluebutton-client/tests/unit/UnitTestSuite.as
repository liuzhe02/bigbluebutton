package
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	import org.bigbluebutton.modules.login.view.components.LoginWindowTestCase;
 	import org.bigbluebutton.modules.chat.view.components.ChatWindowTestCase;

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
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signInAAAAA", "Bo", "1", "1"));

			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 1"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 2"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 3"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 4"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 5"));
		}
		
	}
}