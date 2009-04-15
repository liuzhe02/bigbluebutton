package org.bigbluebutton.main.managers
{
	import flash.events.EventDispatcher;

	
	public class StatusManager extends EventDispatcher
	{
        [Bindable]
        public var loadedModuleStatus:String = "";
        [Bindable]
        public var loadingStatus:String = "";

		public function setLoadedModuleStatus(moduleName:String):void {
			LogUtil.debug("receieved status...");
			loadedModuleStatus += moduleName + " (loaded) ";
		}
		
		public function setLoadingStatus(moduleName:String, progress:String):void {
			LogUtil.debug("receieved status...");
			loadingStatus = "Loading: " + moduleName + " " + progress + "% loaded."
		}
	}
}