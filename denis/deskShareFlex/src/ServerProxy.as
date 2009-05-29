package
{
	import flash.net.NetConnection;
	
	import mx.controls.Alert;
	import mx.controls.SWFLoader;
	
	import org.red5.as3.net.Connection;
	import org.red5.as3.net.events.ConnectionEvent;
	
	public class ServerProxy
	{
		private var conn:Connection;
		private var nc:NetConnection;
		
		public static const URI:String = "rtmp://192.168.0.120/deskShare";
		public function ServerProxy()
		{
			conn = new Connection();
			conn.addEventListener(Connection.SUCCESS, connectionSuccessHandler);
			conn.addEventListener(Connection.FAILED, connectionFailedHandler);
			conn.addEventListener(Connection.REJECTED, connectionRejectedHandler);
			conn.setURI(URI);
			conn.connect();
		}
		
		private function connectionSuccessHandler(e:ConnectionEvent):void{
			nc = conn.getConnection();
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

	}
}