package org.bigbluebutton.modules.deskShare
{
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.Endpoint;
	import org.bigbluebutton.common.messaging.EndpointMessageConstants;
	import org.bigbluebutton.common.messaging.Router;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
	public class DeskShareEndpointMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DeskShareEndpointMediator";
		
		private var _module:IBigBlueButtonModule;
		private var _router:Router;
		private var _endpoint:Endpoint;
		
		private static const TO_DESK_SHARE_MODULE:String = "TO_DESK_SHARE_MODULE";
		private static const FROM_DESK_SHARE_MODULE:String = "FROM_DESK_SHARE_MODULE";
		
		private static const PLAYBACK_MESSAGE:String = "PLAYBACK_MESSAGE";
		private static const PLAYBACK_MODE:String = "PLAYBACK_MODE";
		
		public function DeskShareEndpointMediator(module:IBigBlueButtonModule)
		{
			super(NAME, module);
			_module = module;
			_router = module.router;
			LogUtil.debug("creating endpoint for DeskShare module");
			_endpoint = new Endpoint(_router, FROM_DESK_SHARE_MODULE, TO_DESK_SHARE_MODULE, messageReceiver);
		}
		
		override public function getMediatorName():String{
			return NAME;
		}
		
		override public function listNotificationInterests():Array{
			return [
					DeskShareModuleConstants.ADD_WINDOW,
					DeskShareModuleConstants.REMOVE_WINDOW,
					DeskShareModuleConstants.CONNECTED,
					DeskShareModuleConstants.DISCONNECTED
					];
		}
		
		override public function handleNotification(notification:INotification):void{
			LogUtil.debug("DeskShareEndpoint MSG. " + notification.getName());
			switch(notification.getName()){
				case DeskShareModuleConstants.ADD_WINDOW:
					LogUtil.debug("sending DeskShare OPEN_WINDOW message to main");
					_endpoint.sendMessage(EndpointMessageConstants.ADD_WINDOW, EndpointMessageConstants.TO_MAIN_APP, notification.getBody());
					break;
				case DeskShareModuleConstants.REMOVE_WINDOW:
					LogUtil.debug("sending DeskShare CLOSE_WINDOW message to main");
					_endpoint.sendMessage(EndpointMessageConstants.REMOVE_WINDOW, EndpointMessageConstants.TO_MAIN_APP, notification.getBody());
					break;
				case DeskShareModuleConstants.CONNECTED:
					LogUtil.debug("sending DeskShare MODULE_STARTED message to main");
					_endpoint.sendMessage(EndpointMessageConstants.MODULE_STARTED, EndpointMessageConstants.TO_MAIN_APP, _module.moduleId);
					facade.sendNotification(DeskShareModuleConstants.OPEN_WINDOW);
					break;
				case DeskShareModuleConstants.DISCONNECTED:
					LogUtil.debug("sending DeskShare MODULE_STOPPER message to main");
					facade.sendNotification(DeskShareModuleConstants.CLOSE_WINDOW);
					var info:Object = new Object();
					info["moduleId"] = _module.moduleId;
					_endpoint.sendMessage(EndpointMessageConstants.MODULE_STOPPED, EndpointMessageConstants.TO_MAIN_APP, info);
					break;
			}
		}
		
		private function messageReceiver(message:IPipeMessage):void{
			var msg:String = message.getHeader().MSG as String;
			switch(msg){
				case EndpointMessageConstants.OPEN_WINDOW:
					break;
				case EndpointMessageConstants.CLOSE_WINDOW:
					facade.sendNotification(DeskShareModuleConstants.CLOSE_WINDOW);
					break;
			}
		}
		
		private function playMessage(message:XML):void{
			
		}

	}
}