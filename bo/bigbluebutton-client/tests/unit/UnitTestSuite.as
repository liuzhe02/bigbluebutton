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
			
			/**
			 * LoginServiceTestCase
			 * parameter list of LoginServiceTestCase's constructor 
			 * url for login
			 * fullname for setting LoginWindow.mxml
			 * conference for setting LoginWindow.mxml
			 * password for setting LoginWindow.mxml
			 * message for seting ChatWindow.mxml
			 * please make sure to use this TestCase with your own server's url, conference number and password
			 */		
			//addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			//addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			//addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			//addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			//addTestCase(new LoginServiceTestCase("http://localhost:8080/bigbluebutton/join/signInAAAAA", "Bo", "1", "1"));
			
			/**
			 * LoginWindowTestCase
			 * parameter list of LoginWindowTestCase's constructor 
			 * url for login
			 * fullname for setting LoginWindow.mxml
			 * conference for setting LoginWindow.mxml
			 * password for setting LoginWindow.mxml
			 * message for seting ChatWindow.mxml
			 * please make sure to use this TestCase with your own server's url, conference number and password
			 */		
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "2"));
			//addTestCase(new LoginWindowTestCase("http://localhost:8080/bigbluebutton/join/signInAAAAA", "Bo", "1", "1"));

			/**
			 * ChatWindowTestCase
			 * parameter list of ChatWindowTestCase's constructor 
			 * url for login
			 * fullname for setting LoginWindow.mxml
			 * conference for setting LoginWindow.mxml
			 * password for setting LoginWindow.mxml
			 * message for seting ChatWindow.mxml
			 * please make sure to use this TestCase with your own server's url, conference number and password
			 */		
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 1"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 2"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 3"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 4"));
			addTestCase(new ChatWindowTestCase("http://localhost:8080/bigbluebutton/join/signIn", "Bo", "1", "1", "hahahahaha 5"));
		}
		
	}
}