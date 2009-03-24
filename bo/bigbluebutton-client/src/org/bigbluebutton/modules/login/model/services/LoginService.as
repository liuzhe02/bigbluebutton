package org.bigbluebutton.modules.login.model.services
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	        	
	public class LoginService
	{  
		private var request:URLRequest = new URLRequest();
		private var vars:URLVariables = new URLVariables();
		
		private var urlLoader:URLLoader;
		public function LoginService(){}
		
		/**
		 * Load slides from an HTTP service. Response is received in the Responder class' onResult method 
		 * @param url
		 * 
		 */		
		public function load(url:String, fullname:String, conference:String, password:String, handleComplete:Function) : void
		{
			LogUtil.debug("LoginService:load(...) " + url);
			            
            vars.fullname = fullname;
            vars.conference = conference;
            vars.password = password;
            request = new URLRequest(url);
            request.data = vars;
            request.method = URLRequestMethod.POST;		
            
            urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleComplete);	
            urlLoader.load(request);	
		}	
	}
}