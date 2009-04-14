package org.bigbluebutton.main.views.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class MainModel extends EventDispatcher
	{
		/** This property is injected by the application. */
		public var dispatcher : IEventDispatcher;
		
		public function MainModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
	}
}