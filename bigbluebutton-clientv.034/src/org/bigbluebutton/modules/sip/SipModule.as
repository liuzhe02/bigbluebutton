package org.bigbluebutton.modules.sip
{
	import flash.system.Capabilities;
	
	import flexlib.mdi.containers.MDIWindow;
	
	import org.bigbluebutton.common.BigBlueButtonModule;
	import org.bigbluebutton.common.IRouterAware;
	import org.bigbluebutton.common.Router;
	import org.bigbluebutton.main.view.components.MainApplicationShell;
	
	public class SipModule extends BigBlueButtonModule implements IRouterAware
	{
		public static const NAME:String = "Sip Module";
		
		private var facade:SipModuleFacade;
		public var activeWindow:MDIWindow;
		
		public function SipModule()
		{
			super(NAME);
			facade = SipModuleFacade.getInstance();
			this.preferedX = Capabilities.screenResolutionX/2 - 200;
			this.preferedY = 500;
			this.startTime = BigBlueButtonModule.START_ON_LOGIN;
		}
		
		override public function acceptRouter(router:Router, shell:MainApplicationShell):void{
			super.acceptRouter(router, shell);
			facade.startup(this);
		}
		
		override public function getMDIComponent():MDIWindow{
			return this.activeWindow;
		}
		
		override public function logout():void{
			facade.removeCore(SipModuleFacade.NAME);
		}

	}
}