package org.bigbluebutton.modules.whiteboard.model.business
{
	import flash.events.*;
	import flash.net.NetConnection;
		
	public class NetConnectionDelegate
	{
		public static const NAME : String = "NetConnectionDelegate";

		private var _netConnection : NetConnection;	
		private var _uri : String;
		private var connectionId : Number;
		private var connected : Boolean = false;
		private var _connectionListener:Function;
		private var _connectionError:Array;
				
		public function NetConnectionDelegate(uri:String, connectionListener:Function) : void
		{
			_netConnection = new NetConnection();
			_uri = uri;
			_connectionListener = connectionListener;
		}
		
		public function get connection():NetConnection {
			return _netConnection;
		}
		
		public function connect() : void
		{					
			_netConnection.client = this;
			_netConnection.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			_netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, netASyncError );
			_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, netSecurityError );
			_netConnection.addEventListener( IOErrorEvent.IO_ERROR, netIOError );
			
			try {
				LogUtil.debug( "whiteboard Connecting to " + _uri);
				_connectionError = null;								
				_netConnection.connect(_uri );
				
			} catch( e : ArgumentError ) {
				// Invalid parameters.
				switch ( e.errorID ) 
				{
					case 2004 :						
						LogUtil.debug("Error! Invalid server location: " + _uri);											   
						break;						
					default :
					   break;
				}
			}	
		}
			
		public function disconnect() : void
		{
			_netConnection.close();
		}
					
		protected function netStatus( event : NetStatusEvent ) : void 
		{
			handleResult( event );
		}
		
		public function handleResult(  event : Object  ) : void {
			var info : Object = event.info;
			var statusCode : String = info.code;
			
			switch ( statusCode ) 
			{
				case "NetConnection.Connect.Success" :
					LogUtil.debug("Connection to Whiteboard server succeeded.");
					_connectionListener(true);					
					break;
			
				case "NetConnection.Connect.Failed" :
					addError("Failed to connect to the application.");
					//_connectionListener(false);					
					LogUtil.debug("Connection to Whiteboard server failed");
					break;
					
				case "NetConnection.Connect.Closed" :	
					addError("Connection to application closed.");		
					LogUtil.debug("Connection to Whiteboard application closed");		
					_connectionListener(false, _connectionError);										
					break;
					
				case "NetConnection.Connect.InvalidApp" :	
					addError("Could not find the application.");			
					//_connectionListener(false);
					LogUtil.debug("Whiteboard application not found on server");
					break;
					
				case "NetConnection.Connect.AppShutDown" :
					addError("Application has shutdown.");
					//_connectionListener(false);
					LogUtil.debug("Whiteboard Application has shutdown");
					break;
					
				case "NetConnection.Connect.Rejected" :
					addError("Connection to the application was rejected.");
					//_connectionListener(false);
					LogUtil.debug("No permissions to connect to the Whiteboard application" );
					break;
					
				default :
				   // statements
				   break;
			}
		}
		
			
		protected function netSecurityError(event:SecurityErrorEvent):void 
		{
			addError("Encountered security error on connection to the application.");
			LogUtil.debug("Security error - " + event.text);
			//_connectionListener(false);
		}
		
		protected function netIOError(event:IOErrorEvent):void 
		{
			addError("Encountered Input/Output error on connection to the application.");
			LogUtil.debug("Input/output error - " + event.text);
			//_connectionListener(false);
		}
			
		protected function netASyncError( event : AsyncErrorEvent ) : void 
		{
			addError("Encountered Asynchronous error on connection to the application.");
			LogUtil.debug("Asynchronous code error - " + event.error );
			//_connectionListener(false);
		}	
		
		private function addError(error:String):void {
			if (_connectionError == null) {
				_connectionError = new Array();				
			} 			
			_connectionError.push(error);
		}
	}
}