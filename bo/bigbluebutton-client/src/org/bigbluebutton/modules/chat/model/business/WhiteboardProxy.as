package org.bigbluebutton.modules.whiteboard.model.business
{
	import org.bigbluebutton.modules.whiteboard.WhiteboardModuleConstants;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import org.bigbluebutton.modules.whiteboard.model.component.DrawObject;
		
	public class WhiteboardProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "WhiteboardProxy";
		
		private var module:WhiteboardModule;		
		private var whiteboardService:IWhiteboardService;
		
		// Is teh disconnection due to user issuing the disconnect or is it the server
		// disconnecting due to t fault?
		private var manualDisconnect:Boolean = false;
		
		public function WhiteboardProxy(module:WhiteboardModule)
		{
			super(NAME);
			this.module = module;
			start();
		}
		
		public function start():void 
		{
			LogUtil.debug("WhiteboardProxy::start ... ");
			
			whiteboardService = new WhiteboardSOService(this, module);
			manualDisconnect = false;
			whiteboardService.addMessageListener(newMessageHandler);
//			whiteboardService.addConnectionStatusListener(connectionStatusListener);
			whiteboardService.join();

			whiteboardService.sendMessage("lalalalala hahahahaha 12345");
		}
		
		public function stop():void {
			// USer is issuing a disconnect.
			manualDisconnect = true;
			whiteboardService.leave();
		}
		
		private function connectionStatusListener(connected:Boolean, errors:Array):void {
			if (connected) {
				LogUtil.debug('Sending WhiteboardModuleConstants.CONNECTED');
				sendNotification(WhiteboardModuleConstants.CONNECTED);
			} else {
				LogUtil.debug('Sending WhiteboardModuleConstants.DISCONNECTED');
				sendNotification(WhiteboardModuleConstants.DISCONNECTED, {manual:manualDisconnect, errors:errors});
			}
		}
		
		private function newMessageHandler(message:String):void {
			sendNotification(WhiteboardModuleConstants.NEW_MESSAGE, message);
		}
		
		public function sendMessage(message:String):void
		{
			whiteboardService.sendMessage(message);
		}
		
		public function getWhiteboardTranscript():void {
			whiteboardService.getWhiteboardTranscript();
		}

		public function sendShape(share:DrawObject):void
		{
			LogUtil.debug('WhiteboardProxy::sendShape ... ');

			whiteboardService.sendShape(share);
		}

	}
}