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
package org.bigbluebutton.modules.viewers.model.vo
{
	import org.bigbluebutton.common.Role;
	
	[Bindable]	
	public class User
	{
		public var me:Boolean = false;
		public var userid:Number;
		public var name:String;
		
		public var role:String = Role.VIEWER;	
		public var room:String = "";
		public var authToken:String = "";
		
		/**
		 * This is a workaround until we figure out how to make 
		 * status Bindable in StatusItemRenderer.mxml (ralam 2/20/2009)
		 */
		private var _status:Object;
		public var streamName:String = "";
		public var presenter:Boolean = false;
		public var hasStream:Boolean = false;
		
		public function set status(s:Object):void {
			_status = s;
			hasStream = s["hasStream"];
			presenter = s["presenter"];
			streamName = s["streamName"];
		}
	}
}