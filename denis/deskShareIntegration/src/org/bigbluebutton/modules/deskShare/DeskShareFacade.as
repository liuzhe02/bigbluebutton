package org.bigbluebutton.modules.deskShare
{
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.modules.deskShare.controller.StartupCommand;
	import org.bigbluebutton.modules.deskShare.controller.StopCommand;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class DeskShareFacade extends Facade implements IFacade
	{
		public static const NAME:String = "DeskShareFacade";
		public static const STARTUP:String = "startup";
		public static const STOP:String = "STOP";
		
		public function DeskShareFacade()
		{
			super(NAME);
		}
		
		public static function getInstance():DeskShareFacade{
			if (instanceMap[NAME] == null) instanceMap[NAME] = new DeskShareFacade();
			return instanceMap[NAME] as DeskShareFacade;
		}
		
		override protected function initializeController():void{
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
			registerCommand(STOP, StopCommand);
		}
		
		public function startup(app:IBigBlueButtonModule):void{
			sendNotification(STARTUP, app);
		}
		
		public function stop(app:IBigBlueButtonModule):void{
			sendNotification(STOP, app);
			removeCore(NAME);
		}

	}
}