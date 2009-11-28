package events
{
	import flash.events.Event;
	
	public class WaveEvent extends Event
	{
		public static const WAVE_OPENED:String = "WAVE_OPENED";
		public static const APPEND_LINE_TO_DOCUMENT:String = "APPEND_LINE";
		
		public var data:Object;
		
		public function WaveEvent(type:String)
		{
			super(type, true, false);
		}

	}
}