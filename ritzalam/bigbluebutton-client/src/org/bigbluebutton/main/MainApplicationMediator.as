package org.bigbluebutton.main
{
	import org.bigbluebutton.main.model.ModulesProxy;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class MainApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'MainApplicationMediator';
		
		private var chatLoaded:Boolean = false;
		private var presentLoaded:Boolean = false;
		private var listenerLoaded:Boolean = false;
		private var viewerLoaded:Boolean = false;
		private var videoLoaded:Boolean = false;
		private var loginLoaded:Boolean = false;
		private var joinLoaded:Boolean = false;
		
		public function MainApplicationMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
					MainApplicationConstants.APP_STARTED,
					MainApplicationConstants.APP_MODEL_INITIALIZED,
					MainApplicationConstants.MODULE_LOADED,
					MainApplicationConstants.MODULES_START,
					MainApplicationConstants.MODULE_STARTED,
					MainApplicationConstants.RESTART_MODULE,
					MainApplicationConstants.USER_LOGGED_IN,
					MainApplicationConstants.USER_JOINED,
					MainApplicationConstants.LOGOUT
					];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case MainApplicationConstants.APP_STARTED:
					LogUtil.debug(NAME + "::Received APP_STARTED");
					facade.sendNotification(MainApplicationConstants.APP_MODEL_INITIALIZE);
					break;
				case MainApplicationConstants.APP_MODEL_INITIALIZED:
					LogUtil.debug(NAME + "::Received APP_MODEL_INITIALIZED");
					//proxy.loadModule("VideoModule");
					proxy.loadModule("LoginModule");
					break;
				case MainApplicationConstants.MODULE_LOADED:
					
					var ml:String = notification.getBody() as String;
					LogUtil.debug(NAME + "::Received MODULE_LOADED - " + ml);
					
					if (ml == "ViewersModule") {
						viewerLoaded = true;
					}
					
					if (ml == "LoginModule") {
						loginLoaded = true;
					//	proxy.loadModule("JoinModule");
						proxy.loadModule("ChatModule");
					}
					
					if (ml == "JoinModule") {
						joinLoaded = true;
						proxy.loadModule("ChatModule");
					}
					
					if (ml == "ChatModule") {
						chatLoaded = true;
						proxy.loadModule("PresentationModule");
					}
					if (ml == "PresentationModule") {
						presentLoaded = true;
						proxy.loadModule("ListenersModule");
					}
					if (ml == "ListenersModule") {
						listenerLoaded = true;
						proxy.loadModule("VideoModule");
					}
					if (ml == "VideoModule") {
						videoLoaded = true;
						proxy.loadModule("ViewersModule");
					}
					
					facade.sendNotification(MainApplicationConstants.LOADED_MODULE, ml);
					
					// SHortcircuit videomodule start. This is only for refactoring of videoModule.
					//facade.sendNotification(MainApplicationConstants.MODULE_START, "VideoModule");
					
					if (videoLoaded && viewerLoaded && chatLoaded && presentLoaded && listenerLoaded && loginLoaded) {
						facade.sendNotification(MainApplicationConstants.MODULE_START, "LoginModule");
					}
					
					//proxy.startModule(notification.getBody() as String);
					break;
				case MainApplicationConstants.LOGOUT:
					LogUtil.debug(NAME + '::Received LOGOUT');
					proxy.stopModule("ChatModule");
					proxy.stopModule("PresentationModule");
					proxy.stopModule("ListenersModule");
					proxy.stopModule("VideoModule");
					proxy.stopModule("ViewersModule");	
					proxy.stopModule("LoginModule");
//					proxy.stopModule("JoinModule");				
					break;
				case MainApplicationConstants.RESTART_MODULE:
					LogUtil.debug(NAME + '::Received RESTART_MODULE for ' + notification.getBody() as String);
					proxy.stopModule(notification.getBody() as String);
					facade.sendNotification(MainApplicationConstants.MODULE_START, notification.getBody());
					break;	
				case MainApplicationConstants.USER_LOGGED_IN:
					LogUtil.debug(NAME + '::Received USER_LOGGED_IN');
					facade.sendNotification(MainApplicationConstants.MODULE_START, "ViewersModule");
					break;
				case MainApplicationConstants.USER_JOINED:
					LogUtil.debug(NAME + '::Received USER_JOINED');
					facade.sendNotification(MainApplicationConstants.MODULE_START, "ChatModule");
					facade.sendNotification(MainApplicationConstants.MODULE_START, "PresentationModule");
					facade.sendNotification(MainApplicationConstants.MODULE_START, "ListenersModule");
					facade.sendNotification(MainApplicationConstants.MODULE_START, "VideoModule");
					break;

			}
		}		
		
		private function get proxy():ModulesProxy {
			return facade.retrieveProxy(ModulesProxy.NAME) as ModulesProxy;
		}		
	}
}