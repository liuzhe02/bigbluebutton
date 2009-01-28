/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2008 by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
* 
*/
package org.bigbluebutton.modules.login.view
{
	import org.bigbluebutton.modules.login.LoginModuleConstants;
	import org.bigbluebutton.modules.login.model.LoginProxy;
	import org.bigbluebutton.modules.login.view.components.LoginWindow;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	
	public class LoginWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChatMediator";
		public static const NEW_MESSAGE:String = "newMessage";
		
		private var _module:LoginModule;
		private var _loginWindow:LoginWindow;
		private var _loginWindowOpen:Boolean = false;
		
		public function LoginWindowMediator(module:LoginModule)
		{
			super(NAME, module);
			_module = module;
			_loginWindow = new LoginWindow();
			_loginWindow.name = _module.username;
		}

        private function time() : String
		{
			var date:Date = new Date();
			var t:String = date.toLocaleTimeString();
			return t;
		}		

		override public function listNotificationInterests():Array
		{
			return [
					LoginModuleConstants.NEW_MESSAGE,
					LoginModuleConstants.CLOSE_WINDOW,
					LoginModuleConstants.OPEN_WINDOW
				   ];
		}
						
		/**
		 * Handlers for notification(s) this class is listening to 
		 * @param notification
		 * 
		 */		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LoginModuleConstants.CLOSE_WINDOW:
					if (_loginWindowOpen) {
						facade.sendNotification(LoginModuleConstants.REMOVE_WINDOW, _loginWindow);
						_loginWindowOpen = false;
					}
					break;					
				case LoginModuleConstants.OPEN_WINDOW:
		   			_loginWindow.width = 250;
		   			_loginWindow.height = 220;
		   			_loginWindow.title = "Group Chat";
		   			_loginWindow.showCloseButton = false;
		   			_loginWindow.xPosition = 675;
		   			_loginWindow.yPosition = 0;
		   			facade.sendNotification(LoginModuleConstants.ADD_WINDOW, _loginWindow); 
		   			_loginWindowOpen = true;
					break;
			}
		}
			
		public function get proxy():LoginProxy
		{
			return facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
		} 
	}
}