package org.bigbluebutton.modules.whiteboard.model.business
{
	import org.bigbluebutton.modules.whiteboard.BoardFacade;
	import org.bigbluebutton.modules.whiteboard.model.component.DrawObject;
	import org.bigbluebutton.modules.whiteboard.model.component.DrawObjectFactory;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;

	public class WhiteboardSOService implements IWhiteboardService
	{
		public static const NAME:String = "WhiteboardSOService";
		
		private static const TRANSCRIPT:String = "TRANSCRIPT";
		private var whiteboardSO : SharedObject;
		private var netConnectionDelegate: NetConnectionDelegate;
		private var module:WhiteboardModule;
		private var proxy:WhiteboardProxy;
		private var _msgListener:Function;
		private var _connectionListener:Function;
		private var _soErrors:Array;
		
		private var needsTranscript:Boolean = false;
		
		private var drawFactory:DrawObjectFactory = new DrawObjectFactory();
		
		public function WhiteboardSOService(proxy:WhiteboardProxy, module:WhiteboardModule)
		{			
			this.module = module;
			this.proxy = proxy		
		}
				
		private function connectionListener(connected:Boolean, errors:Array=null):void {
			if (connected) {
				LogUtil.debug(NAME + ":Connected to the Whiteboard application");
				join();
				notifyConnectionStatusListener(true);
			} else {
				leave();
				LogUtil.debug(NAME + ":Disconnected from the Whiteboard application");
				notifyConnectionStatusListener(false, errors);
			}
		}
		
	    public function join() : void
		{
			LogUtil.debug("WhiteboardSOService::join ... ");

			whiteboardSO = SharedObject.getRemote("whiteboardSO", module.uri, false);
			whiteboardSO.client = this;
			whiteboardSO.connect(module.connection);
			LogUtil.debug(NAME + ":Whiteboard is connected to Shared object");
			notifyConnectionStatusListener(true);
			if (module.mode == 'LIVE') {
				getWhiteboardTranscript();
			}						
		}
		
	    public function leave():void
	    {
	    	if (whiteboardSO != null) whiteboardSO.close();
	    	notifyConnectionStatusListener(false);
	    }

		public function addMessageListener(messageListener:Function):void {
			_msgListener = messageListener;
		}
		
		public function addConnectionStatusListener(connectionListener:Function):void {
			_connectionListener = connectionListener;
		}

		public function getWhiteboardTranscript():void 
		{
			var nc:NetConnection = module.connection;
			
			nc.call(
				"whiteboard.getWhiteboardMessages",// Remote function name
				new Responder(
	        		// On successful result
					function(result:Object):void { 
						LogUtil.debug("Whiteboard Successfully sent message: "); 
						if (result != null) {
							newWhiteboardMessage(result as String);
						}	
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
						} 
					}
				)//new Responder
			); //_netConnection.call				
		}
		
		private function notifyConnectionStatusListener(connected:Boolean, errors:Array=null):void {
			if (_connectionListener != null) {
				LogUtil.debug('notifying connectionListener for Whiteboard');
				_connectionListener(connected, errors);
			} else {
				LogUtil.debug("_connectionListener is null");
			}
		}
		
		private function addError(error:String):void {
			if (_soErrors == null) {
				_soErrors = new Array();
			}
			_soErrors.push(error);
		}
		
		public function sendMessage(message:String):void
		{
			var nc:NetConnection = module.connection;

			//with NetConnection.call, will go to bigbluebutton-apps.xml::whiteboard.service.....
			nc.call(
				"whiteboard.sendMessage",// Remote function name
				new Responder(
	        		// On successful result
					function(result:Object):void { 
						LogUtil.debug("WhiteboardSOService::sendMessage ... Successfully sent message: message=" + message); 
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
						} 
					}
				),//new Responder
				message
			); //_netConnection.call
		}
		
		/**
		 * Called by the server to deliver a new Whiteboard message.
		 */	
		public function newWhiteboardMessage(message:String):void
		{
			LogUtil.debug("WhiteboardSOService::newWhiteboardMessage ... callback message=" + message); 
			
			if (_msgListener != null) {
				_msgListener( message);
			}		   
		}
		
		/**
		 * Sends a shape to the Shared Object on the red5 server, and then triggers an update across all clients
		 * @param shape The shape sent to the SharedObject
		 * 
		 */		
		public function sendShape(shape:DrawObject):void
		{
			LogUtil.debug('WhiteboardSOService::sendShape ... ');
			
			try
			{
				//with SharedObject.send(callback-methot-name, params.....), all participants's callback-methot-name method will be callbacked(this method should be define inside "so.client")
				whiteboardSO.send("addSegment", shape.getShapeArray(), shape.getType(), shape.getColor(), shape.getThickness());	
			} catch(e:Error)
			{
				proxy.sendNotification(BoardFacade.FAILED_CONNECTION);
			}
		}
		
		/**
		 * Adds a shape to the ValueObject, then triggers an update event
		 * @param array The array representation of a shape
		 * 
		 */		
		public function addSegment(array:Array, type:String, color:uint, thickness:uint):void
		{
			LogUtil.debug("WhiteboardSOService::addSegment ... callback type=" + type); 

			var d:DrawObject = drawFactory.makeDrawObject(type, array, color, thickness);
			//this.drawVO.segment = d;
			proxy.sendNotification(BoardFacade.UPDATE, d);
		}
		
	}
}