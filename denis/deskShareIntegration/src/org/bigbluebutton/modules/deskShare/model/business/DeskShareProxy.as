package org.bigbluebutton.modules.deskShare.model.business
{
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	
	import org.bigbluebutton.common.red5.Connection;
	import org.bigbluebutton.common.red5.ConnectionEvent;
	import org.bigbluebutton.modules.deskShare.DeskShareModuleConstants;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	/**
	 * The DeskShareProxy communicates with the Red5 deskShare server application 
	 * @author Snap
	 * 
	 */	
	public class DeskShareProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DeskShareProxy";
		//public static const URI:String = "rtmp://192.168.0.135/deskShare";
		
		private var module:DeskShareModule;
		
		private var conn:Connection;
		private var nc:NetConnection;
		private var deskSO:SharedObject;
		private var responder:Responder;
		
		/**
		 * The constructor. 
		 * @param module - The DeskShareModule for which this class is a proxy
		 * 
		 */		
		public function DeskShareProxy(module:DeskShareModule)
		{
			super(NAME);
			this.module = module;
			
			conn = new Connection();
			conn.addEventListener(Connection.SUCCESS, connectionSuccessHandler);
			conn.addEventListener(Connection.FAILED, connectionFailedHandler);
			conn.addEventListener(Connection.REJECTED, connectionRejectedHandler);
			conn.setURI(module.uri);
			conn.connect();
			
			responder = new Responder(
							function(result:Object):void{
								if (result != null && (result as Boolean)) startViewing();
							},
							function(status:Object):void{
								LogUtil.error("Error while trying to call remote mathod on server");
							}
									);
		}
		
		/**
		 * Called when the application starts
		 * @not implemented 
		 * 
		 */		
		public function start():void{
			
		}
		
		/**
		 * Called when the application stops
		 * @not implemented
		 * 
		 */		
		public function stop():void{
			
		}
		
		/**
		 * Called when a successful server connection is established 
		 * @param e
		 * 
		 */		
		private function connectionSuccessHandler(e:ConnectionEvent):void{
			nc = conn.getConnection();
			deskSO = SharedObject.getRemote("drawSO", module.uri, false);
            deskSO.addEventListener(SyncEvent.SYNC, sharedObjectSyncHandler);
            deskSO.client = this;
            deskSO.connect(nc);
            
            checkIfStreamIsPublishing();
		}
		
		/**
		 * Returns the connection object which this object is using to communicate to the Red5 server
		 * @return - The NetConnection object
		 * 
		 */		
		public function getConnection():NetConnection{
			return nc;
		}
		
		/**
		 * Called in case the connection to the server fails 
		 * @param e
		 * 
		 */		
		public function connectionFailedHandler(e:ConnectionEvent):void{
			Alert.show("connection failed " + e.toString());
		}
		
		/**
		 * Called in case the connection is rejected 
		 * @param e
		 * 
		 */		
		public function connectionRejectedHandler(e:ConnectionEvent):void{
			Alert.show("connection rejected " + e.toString());
		}
		
		/**
		 * A sync handler for the deskShare Shared Objects 
		 * @param e
		 * 
		 */		
		public function sharedObjectSyncHandler(e:SyncEvent):void{
			
		}
		
		/**
		 * Call this method to send out a room-wide notification to start viewing the stream 
		 * 
		 */		
		public function sendStartViewingNotification():void{
			try{
				deskSO.send("startViewing");
			} catch(e:Error){
				LogUtil.error("error while trying to send start viewing notification");
			}
		}
		
		/**
		 * Called by the server when a notification is received to start viewing the broadcast stream .
		 * 
		 */		
		public function startViewing():void{
			sendNotification(DeskShareModuleConstants.START_VIEWING);
		}
		
		/**
		 * Sends a notification through the server to all the participants in the room to stop viewing the stream 
		 * 
		 */		
		public function sendStopViewingNotification():void{
			try{
				deskSO.send("stopViewing");
			} catch(e:Error){
				LogUtil.error("could not send stop viewing notification");
			}
		}
		
		/**
		 * Sends a notification to the module to stop viewing the stream 
		 * 
		 */		
		public function stopViewing():void{
			sendNotification(DeskShareModuleConstants.STOP_VIEWING);
		}
		
		/**
		 * Check if anybody is publishing the stream for this room 
		 * 
		 */		
		private function checkIfStreamIsPublishing():void{
			nc.call("checkIfStreamIsPublishing", responder);
		}

	}
}