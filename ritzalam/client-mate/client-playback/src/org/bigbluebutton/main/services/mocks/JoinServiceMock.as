package org.bigbluebutton.main.services.mocks
{
	public class JoinServiceMock
	{
		public function JoinServiceMock()
		{
		}

		public function join(authToken:String):Object {
			var joinInfo:Object = new Object();
			joinInfo.room = '85115';
			joinInfo.role = 'MODERATOR';
			joinInfo.name = 'User Juan';
		}
	}
}