package org.bigbluebutton.modules.deskShare.view
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.bigbluebutton.modules.deskShare.DeskShareModuleConstants;
	import org.bigbluebutton.modules.deskShare.model.business.DeskShareProxy;
	import org.bigbluebutton.modules.deskShare.view.components.DeskShareWindow;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * The DeskShareWindowMediator is a mediator class for the DeskShareWindow. It listens to the window events and dispatches them accordingly 
	 * @author Snap
	 * 
	 */	
	public class DeskShareWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DeskShareWindowMediator";
		public static const START_SHARING:String = "START_SHARING";
		public static const START_VIEWING:String = "START_VIEWING";
		
		private var _module:DeskShareModule;
		private var _window:DeskShareWindow;
		private var _deskShareWindowOpen:Boolean = false;
		
		private var sharing:Boolean = false;
		private var viewing:Boolean = false;
		
		/**
		 * The default constructor 
		 * @param module - the DeskShareModule to which the window belongs to
		 * 
		 */		
		public function DeskShareWindowMediator(module:DeskShareModule)
		{
			_module = module;
			_window = new DeskShareWindow();
			_window.name = _module.username;
			
			_window.addEventListener(START_SHARING, onStartSharingEvent);
			_window.addEventListener(START_VIEWING, onStartViewingEvent);
		}
		
		/**
		 * Lists the notifications to which this class should listen to 
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array{
			return [
					DeskShareModuleConstants.CLOSE_WINDOW,
					DeskShareModuleConstants.OPEN_WINDOW,
					DeskShareModuleConstants.START_VIEWING,
					DeskShareModuleConstants.STOP_VIEWING
					];
		}
		
		/**
		 * Handles the notifications to which this class listens to as they appear 
		 * @param notification
		 * 
		 */		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case DeskShareModuleConstants.CLOSE_WINDOW:
					if (_deskShareWindowOpen){
						facade.sendNotification(DeskShareModuleConstants.REMOVE_WINDOW, _window);
						_deskShareWindowOpen = false;
					}
					break;
				case DeskShareModuleConstants.OPEN_WINDOW:
					_window.title = "Desk Share";
					_window.showCloseButton = false;
					_window.xPosition = 400;
					_window.yPosition = 100;
					facade.sendNotification(DeskShareModuleConstants.ADD_WINDOW, _window);
					_deskShareWindowOpen = true;
					break;
				case DeskShareModuleConstants.START_VIEWING:
					if (!sharing) startViewing();
					break;
				case DeskShareModuleConstants.STOP_VIEWING:
					if (viewing) stopViewing();
					break;
			}
		}
		
		/**
		 * A convinience getter for the proxy of the module 
		 * @return 
		 * 
		 */		
		private function get proxy():DeskShareProxy{
			return facade.retrieveProxy(DeskShareProxy.NAME) as DeskShareProxy;
		}
		
		/**
		 * Starts viewing the broadcast stream for this room 
		 * 
		 */		
		private function startViewing():void{
			_window.videoPlayer = new Video(800, 600);
			_window.videoHolder.setActualSize(800, 600);
			_window.videoHolder.addChild(_window.videoPlayer);
			_window.canvas.addChild(_window.videoHolder);
			_window.videoHolder.x = 0;
			_window.videoHolder.y = 0;
				
			_window.height = 673;
			_window.width = 812;
			_window.canvas.visible = true;
			_window.canvas.width = 800;
			_window.canvas.height = 600;
			_window.ns = new NetStream(proxy.getConnection());
			_window.ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_window.ns.client = this;
			_window.ns.bufferTime = 0;
			_window.ns.receiveVideo(true);
			_window.ns.receiveAudio(false);
			_window.videoPlayer.attachNetStream(_window.ns);
			
			var room:String = _module.getRoom();
			_window.ns.play(room);
			_window.lblStatus.text = "You are viewing the desktop for presenter of room " + room;
			
			viewing = true;
			_window.btnStartApplet.visible = false;
			
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void{
			
		}
		
		/**
		 * Sends a call to the capture applet to stop broadcasting 
		 * 
		 */		
		private function stopApplet():void{
			ExternalInterface.call("stopApplet");
		}
		
		/**
		 * Stops the client from viewing the broadcast stream  
		 * 
		 */		
		private function stopViewing():void{
			_window.ns.close();
			viewing = false;
			_window.btnStartApplet.visible = true;
			_window.canvas.visible = false;
			_window.width = 236;
			_window.height = 74;
			_window.lblStatus.text = "";
		}
		
		/**
		 * Called when the start sharing button is pressed, this method calls javascript to start the capture applet 
		 * @param e
		 * 
		 */		
		private function onStartSharingEvent(e:Event):void{
			if (!sharing){
				//Alert.show(_module.getRoom().toString());
				ExternalInterface.call("startApplet", _module.getCaptureServerUri(), _module.getRoom());
				_window.dimensionsBox.visible = true;
			
				_window.capturing = true;
				_window.height = _window.bar.height + _window.dimensionsBox.height + 33;
				_window.width = _window.dimensionsBox.width + 7;
				sharing = true;
				_window.btnStartApplet.label = "Stop Sharing";
				//_window.lblStatus.text = "You are sharing your desktop with room " + _module.getRoom();
				_window.dimensionsBox.x = 0;
				_window.dimensionsBox.y = _window.bar.height + 5;
				_window.dimensionsBox.startThumbnail(proxy.getConnection(), _module.getRoom());
				
				//Send a notification to all room participants to start viewing the stream
				proxy.sendStartViewingNotification();
			} else{
				sharing = false;
				_window.btnStartApplet.label = "Start Sharing";
				_window.btnStartApplet.selected = false;
				_window.width = 236;
				_window.height = 70;
				_window.dimensionsBox.visible = false;
				
				stopApplet();
				proxy.sendStopViewingNotification();
			}
			
		}
		
		/**
		 * Called when the start viewing button is pressed, this mathod starts viewing the stream 
		 * @param e
		 * 
		 */		
		private function onStartViewingEvent(e:Event):void{
			if (!viewing) startViewing();
			else stopViewing();
		}

	}
}