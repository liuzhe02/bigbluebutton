package events
{
	import flash.events.Event;
	
	public class InboxEvent extends Event
	{
		public static const GOT_WAVES:String = "GOT_WAVES";
		public static const OPEN_WAVE:String = "OPEN_WAVE";
		
		public var data:Object;
		
		public function InboxEvent(type:String)
		{
			super(type, true, false);
		}

	}
}