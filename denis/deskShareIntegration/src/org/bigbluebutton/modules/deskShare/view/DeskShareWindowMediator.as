package org.bigbluebutton.modules.deskShare.view
{
	import org.bigbluebutton.modules.deskShare.DeskShareModuleConstants;
	import org.bigbluebutton.modules.deskShare.model.business.DeskShareProxy;
	import org.bigbluebutton.modules.deskShare.view.components.DeskShareWindow;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class DeskShareWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "DeskShareWindowMediator";
		
		private var _module:DeskShareModule;
		private var _window:DeskShareWindow;
		private var _deskShareWindowOpen:Boolean = false;
		
		public function DeskShareWindowMediator(module:DeskShareModule)
		{
			_module = module;
			_window = new DeskShareWindow();
			_window.name = _module.username;
		}
		
		override public function listNotificationInterests():Array{
			return [
					DeskShareModuleConstants.CLOSE_WINDOW,
					DeskShareModuleConstants.OPEN_WINDOW
					];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case DeskShareModuleConstants.CLOSE_WINDOW:
					if (_deskShareWindowOpen){
						facade.sendNotification(DeskShareModuleConstants.REMOVE_WINDOW, _window);
						_deskShareWindowOpen = false;
					}
					break;
				case DeskShareModuleConstants.OPEN_WINDOW:
					_window.width = 800;
					_window.height = 600;
					_window.title = "Desk Share";
					_window.showCloseButton = false;
					_window.xPosition = 400;
					_window.yPosition = 100;
					facade.sendNotification(DeskShareModuleConstants.ADD_WINDOW, _window);
					_deskShareWindowOpen = true;
					break;
			}
		}
		
		public function get proxy():DeskShareProxy{
			return facade.retrieveProxy(DeskShareProxy.NAME) as DeskShareProxy;
		}

	}
}