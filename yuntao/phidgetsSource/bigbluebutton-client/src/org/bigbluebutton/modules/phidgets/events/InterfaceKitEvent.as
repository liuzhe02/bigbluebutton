package org.bigbluebutton.modules.phidgets.events
{
	import flash.events.Event;

	public class InterfaceKitEvent extends Event
	{
		public static const OPEN:String = "Open";
				
		public function InterfaceKitEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}