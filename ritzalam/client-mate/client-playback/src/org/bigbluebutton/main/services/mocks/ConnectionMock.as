package org.bigbluebutton.main.services.mocks
{
	import org.bigbluebutton.main.services.IConnection;
	
	public class ConnectionMock implements IConnection
	{
		public function ConnectionMock()
		{
		}

		public function connect(room:String, name:String, role:String, authToken:String):Boolean {
			return true;
		}
	}
}