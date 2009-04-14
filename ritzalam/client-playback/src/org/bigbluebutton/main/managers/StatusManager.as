package org.bigbluebutton.main.managers
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class StatusManager extends EventDispatcher
	{
		 /**
         * The current status text.
         */
        public var status:String = "";
        
        /**
         * More detailed information about the status.
         */
        public var message:String = "";

	}
}