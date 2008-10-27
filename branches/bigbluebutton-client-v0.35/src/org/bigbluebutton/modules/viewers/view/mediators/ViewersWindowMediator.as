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
package org.bigbluebutton.modules.viewers.view.mediators
{
	import flash.events.Event;
	
	import org.bigbluebutton.modules.viewers.ViewersModuleConstants;
	import org.bigbluebutton.modules.viewers.model.ViewersProxy;
	import org.bigbluebutton.modules.viewers.view.components.ViewersWindow;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 *  The ViewersWindowMediator is a mediator class for the ViewersWindow gui component
	 * @author Denis Zgonjanin
	 * 
	 */	
	public class ViewersWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ViewersWindowMediator";
		
		public static const CHANGE_STATUS:String = "Change Status";
		
		private var _viewersWindow:ViewersWindow;
		
		/**
		 * The constructor. Registers this mediator with the gui component 
		 * @param view
		 * 
		 */		
		public function ViewersWindowMediator()
		{
			super(NAME);
			_viewersWindow = new ViewersWindow();
			_viewersWindow.addEventListener(CHANGE_STATUS, changeStatus);
		}
		
		/**
		 * Lists the notifications to which this mediator listens to 
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array{
			return [
					ViewersModuleConstants.OPEN_VIEWERS_WINDOW,
					ViewersModuleConstants.CLOSE_VIEWERS_WINDOW
					];
		}
		
		/**
		 * Handles the notifications upon reception 
		 * @param notification
		 * 
		 */		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case ViewersModuleConstants.OPEN_VIEWERS_WINDOW:
					trace('Received request to OPEN_VIEWERS_WINDOW');
					var p:ViewersProxy = facade.retrieveProxy(ViewersProxy.NAME) as ViewersProxy;
					_viewersWindow.participants = p.participants;
					_viewersWindow.width = 350;
		   			_viewersWindow.height = 270;
		   			_viewersWindow.title = "Viewers";
		   			_viewersWindow.showCloseButton = false;
		   			_viewersWindow.xPosition = 400;
		   			_viewersWindow.yPosition = 50;
		   			facade.sendNotification(ViewersModuleConstants.ADD_WINDOW, _viewersWindow); 				
					break;
			}
		}
				
		/**
		 * Change the raisehand/lowerhand status 
		 * @param e
		 * 
		 */		
		private function changeStatus(e:Event):void{
		var newStatus : String;
		
//			if (viewersWindow.conference.me.status == "raisehand") {
//				newStatus = "lowerhand";	
//				viewersWindow.toggleTooltip = "Click to raise hand.";
//				viewersWindow.toggleIcon = viewersWindow.images.raisehand;
//			} else {
//				newStatus = "raisehand";
//				viewersWindow.toggleTooltip = "Click to lower hand.";
//				viewersWindow.toggleIcon = viewersWindow.images.participant;
//			}
//
//			proxy.sendNewStatus(newStatus);
		}
		
		private function get proxy():ViewersProxy {
			return facade.retrieveProxy(ViewersProxy.NAME) as ViewersProxy;
		}

	}
}