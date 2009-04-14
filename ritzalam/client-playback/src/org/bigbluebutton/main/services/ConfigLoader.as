package org.bigbluebutton.main.services
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.bigbluebutton.main.model.ModuleDescriptor;
	
	public class ConfigLoader {
		
		private var _urlLoader:URLLoader;
		private var _numModules:int = 0;		
		private var _modules:Dictionary = new Dictionary();
		private var _mode:String;
		
		public function ConfigLoader()
		{
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, handleComplete);			
		}
		
		public function loadConfig(mode:String, configUri:String):void {
			_mode = mode;
			_urlLoader.load(new URLRequest(configUri));
		}
				
		private function handleComplete(e:Event):void{
			parse(new XML(e.target.data));				
		}
				
		public function parse(xml:XML):void{
			var list:XMLList = xml.module;
			var item:XML;
						
			for each(item in list){
				var mod:ModuleDescriptor = new ModuleDescriptor(item);
				_modules[item.@name] = mod;
				_numModules++;
			}					
		}
		
		public function get numberOfModules():Number {
			return _numModules;
		}
		
		public function get moduleDescriptors():Dictionary {
			return _modules;
		}
	}
}