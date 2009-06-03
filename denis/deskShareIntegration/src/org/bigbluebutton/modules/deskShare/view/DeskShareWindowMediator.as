package org.bigbluebutton.modules.deskShare.view
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
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
					DeskShareModuleConstants.START_VIEWING
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
					startViewing();
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
			_window.height = 673;
			_window.width = 812;
			_window.canvas.visible = true;
			_window.canvas.width = 800;
			_window.canvas.height = 600;
			_window.ns = new NetStream(proxy.getConnection());
			_window.ns.client = this;
			_window.ns.bufferTime = 0;
			_window.ns.receiveVideo(true);
			_window.ns.receiveAudio(false);
			_window.videoPlayer.attachNetStream(_window.ns);
			_window.ns.play(_module.getRoom());
			
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
				_window.btnStartViewing.visible = false;
			
				_window.capturing = true;
				//proxy.sendStartViewingNotification();
				_window.height = _window.bar.height + _window.dimensionsBox.height + 33;
				_window.width = _window.dimensionsBox.width + 7;
				sharing = true;
				_window.btnStartApplet.label = "Stop Sharing";
				_window.dimensionsBox.x = 0;
				_window.dimensionsBox.y = _window.bar.height + 5;
			} else{
				sharing = false;
				_window.btnStartApplet.label = "Start Sharing";
				_window.btnStartViewing.visible = true;
				_window.width = 236;
				_window.height = 70;
				_window.dimensionsBox.visible = false;
				stopApplet();
			}
			
		}
		
		/**
		 * Called when the start viewing button is pressed, this mathod starts viewing the stream 
		 * @param e
		 * 
		 */		
		private function onStartViewingEvent(e:Event):void{
			if (!viewing){
				startViewing();
				viewing = true;
				_window.btnStartViewing.label = "Stop Viewing";
				_window.btnStartApplet.visible = false;
			}
			else {
				stopViewing();
				viewing = false;
				_window.btnStartViewing.label = "Start Viewing";
				_window.btnStartApplet.visible = true;
				_window.canvas.visible = false;
				_window.width = 236;
				_window.height = 74;
			}
		}

	}
}