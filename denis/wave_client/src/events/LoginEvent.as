package events
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN:String = "ATTEMPT_LOGIN";
		public static const LOGIN_SUCCESS:String = "LOGIN_SUCCESS";
		public static const LOGIN_FAILED:String = "LOGIN_FAILED";
		
		public var username:String;
		
		public function LoginEvent(type:String)
		{
			super(type, true, false);
		}

	}
}