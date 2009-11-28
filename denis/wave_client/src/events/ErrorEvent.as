package events
{
	import flash.events.Event;
	
	public class ErrorEvent extends Event
	{
		public static const ERROR:String = "ERROR_OCCURED";
		
		public function ErrorEvent(type:String = ERROR)
		{
			super(type, true, false);
		}

	}
}