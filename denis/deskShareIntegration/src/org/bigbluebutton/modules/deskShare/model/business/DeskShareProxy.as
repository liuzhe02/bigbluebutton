package org.bigbluebutton.modules.deskShare.model.business
{
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	import mx.controls.SWFLoader;
	
	import org.bigbluebutton.common.red5.Connection;
	import org.bigbluebutton.common.red5.ConnectionEvent;
	import org.bigbluebutton.modules.deskShare.DeskShareModuleConstants;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class DeskShareProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DeskShareProxy";
		//public static const URI:String = "rtmp://192.168.0.135/deskShare";
		
		private var module:DeskShareModule;
		
		private var conn:Connection;
		private var nc:NetConnection;
		private var deskSO:SharedObject;
		
		public function DeskShareProxy(module:DeskShareModule)
		{
			super(NAME);
			this.module = module;
			start();
			
			conn = new Connection();
			conn.addEventListener(Connection.SUCCESS, connectionSuccessHandler);
			conn.addEventListener(Connection.FAILED, connectionFailedHandler);
			conn.addEventListener(Connection.REJECTED, connectionRejectedHandler);
			conn.setURI(module.getRed5ServerUri());
			conn.connect();
		}
		
		public function start():void{
			
		}
		
		public function stop():void{
			
		}
		
		private function connectionSuccessHandler(e:ConnectionEvent):void{
			nc = conn.getConnection();
			deskSO = SharedObject.getRemote("drawSO", module.getRed5ServerUri(), false);
            deskSO.addEventListener(SyncEvent.SYNC, sharedObjectSyncHandler);
            deskSO.client = this;
            deskSO.connect(nc);
		}
		
		public function startWatching(player:SWFLoader):void{
			
		}
		
		public function getConnection():NetConnection{
			return nc;
		}
		
		public function connectionFailedHandler(e:ConnectionEvent):void{
			Alert.show("connection failed " + e.toString());
		}
		
		public function connectionRejectedHandler(e:ConnectionEvent):void{
			Alert.show("connection rejected " + e.toString());
		}
		
		public function sharedObjectSyncHandler(e:SyncEvent):void{
			
		}
		
		public function sendStartViewingNotification():void{
			try{
				deskSO.send("startViewing");
			} catch(e:Error){
				Alert.show("error while trying to send start viewing notification");
			}
		}
		
		public function startViewing():void{
			sendNotification(DeskShareModuleConstants.START_VIEWING);
		}

	}
}