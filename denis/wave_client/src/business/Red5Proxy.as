package business
{
	import com.asfusion.mate.events.Dispatcher;
	
	import events.ErrorEvent;
	import events.InboxEvent;
	import events.LoginEvent;
	import events.WaveEvent;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	
	import red5.Connection;
	import red5.ConnectionEvent;
	
	public class Red5Proxy
	{
		public static const DEFAULT_URI:String = "rtmp://192.168.0.124/video";
		
		private var conn:Connection;
		private var nc:NetConnection;
		private var waveSO:SharedObject;
		
		private var uri:String;
		private var dispatcher:Dispatcher;
		
		public function Red5Proxy()
		{
			connect(DEFAULT_URI);
		}
		
		public function connect(uri:String):void{
			dispatcher = new Dispatcher();
			this.uri = uri;
			conn = new Connection();
			conn.addEventListener(Connection.SUCCESS, connectionSuccessHandler);
			conn.addEventListener(Connection.FAILED, connectionFailedHandler);
			conn.addEventListener(Connection.REJECTED, connectionRejectedHandler);
			conn.setURI(this.uri);
			conn.connect();
			
		}
		
		private function connectionSuccessHandler(e:ConnectionEvent):void{
			nc = conn.getConnection();
			waveSO = SharedObject.getRemote("waveSO", uri, false);
            waveSO.client = this;
            waveSO.connect(nc);
		}
		
		private function connectionFailedHandler(e:ConnectionEvent):void{
			Alert.show("connection failed");
		}
		
		private function connectionRejectedHandler(e:ConnectionEvent):void{
			Alert.show("connection rejected");
		}
		
		public function startWaveClient(nameAtDomain:String):void{
			var responder:Responder = new Responder(
							function(result:Object):void{
								if (result != null && (result as Boolean)){
									var e:LoginEvent = new LoginEvent(LoginEvent.LOGIN_SUCCESS);
									e.username = nameAtDomain;
									dispatcher.dispatchEvent(e);
								}
							},
							function(status:Object):void{
								dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAILED));
							}
									);
			nc.call("startWaveClient", responder, nameAtDomain);
		}
		
		public function getWaves():void{
			var responder:Responder = new Responder(
							function(result:Object):void{
								if (result != null){
									var e:InboxEvent = new InboxEvent(InboxEvent.GOT_WAVES);
									e.data = result;
									dispatcher.dispatchEvent(e);
								}
							},
							function(status:Object):void{
								Alert.show("there was an error");
								dispatcher.dispatchEvent(new ErrorEvent());
							}
									);
			nc.call("getWaves", responder);
		}
		
		public function openWave(index:Number):void{
			var responder:Responder = new Responder(
							function(result:Object):void{
								if (result != null){
									var e:WaveEvent = new WaveEvent(WaveEvent.WAVE_OPENED);
									e.data = result;
									dispatcher.dispatchEvent(e);
								}
							},
							function(status:Object):void{
								Alert.show("there was an error");
								dispatcher.dispatchEvent(new ErrorEvent());
							}
									);
			nc.call("openWave", responder, index);
		}

	}
}