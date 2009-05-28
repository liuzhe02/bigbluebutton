package org.bigbluebutton.modules.deskShare.model.business
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class DeskShareProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DeskShareProxy";
		
		private var module:DeskShareModule;
		
		public function DeskShareProxy(module:DeskShareModule)
		{
			super(NAME);
			this.module = module;
			start();
		}
		
		public function start():void{
			
		}
		
		public function stop():void{
			
		}

	}
}