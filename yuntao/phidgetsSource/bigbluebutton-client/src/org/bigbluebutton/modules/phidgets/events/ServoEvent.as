package org.bigbluebutton.modules.phidgets.events
{
	import flash.events.Event;

	public class ServoEvent extends Event
	{
		public static const OPEN:String = "Open";
		public static const HANDS_UP:String = "HandsUp";
		public static const HANDS_DOWN:String = "HandsDown";
		
		public function ServoEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}