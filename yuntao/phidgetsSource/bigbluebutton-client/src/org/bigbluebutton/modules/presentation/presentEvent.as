package org.bigbluebutton.modules.presentation.events
{
	import flash.events.Event;

	public class presentEvent extends Event
	{
		public static const NEXT_SLIDE:String = "NextSlide"; 
		public static const PREVIOUS_SLIDE:String = "PreviousSlide"; 
		
		public function presentEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}