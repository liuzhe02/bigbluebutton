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
package org.bigbluebutton.modules.video.model.services
{
	import flash.events.*;
	import flash.net.NetConnection;
		
	public class NetConnectionDelegate
	{
		public static const NAME : String = "NetConnectionDelegate";

		private var _netConnection : NetConnection;	
		private var _uri : String;
		private var connectionId : Number;
		private var connected : Boolean = false;
		private var _connectionListener:Function;
				
		public function NetConnectionDelegate() : void
		{
			_netConnection = new NetConnection();
		}
		
		public function addConnectionListener(connectionListener:Function):void {
			_connectionListener = connectionListener;
		}
		
		public function get connection():NetConnection {
			return _netConnection;
		}
		
		public function connect(uri:String, proxy:String, encoding:uint) : void
		{					
			_netConnection.client = this;			
			_netConnection.objectEncoding = encoding;
			_netConnection.proxyType = proxy;
			
			_netConnection.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			_netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, netASyncError );
			_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, netSecurityError );
			_netConnection.addEventListener( IOErrorEvent.IO_ERROR, netIOError );
			
			try {
				trace( "Connecting to " + _uri);								
				_netConnection.connect(_uri );
				
			} catch( e : ArgumentError ) {
				// Invalid parameters.
				switch ( e.errorID ) 
				{
					case 2004 :						
						trace("Error! Invalid server location: " + _uri);											   
						break;						
					default :
					   break;
				}
			}	
		}
			
		public function disconnect() : void
		{
			_netConnection.close();
		}
					
		protected function netStatus( event : NetStatusEvent ) : void 
		{
			handleResult( event );
		}
		
		public function handleResult(  event : Object  ) : void {
			var info : Object = event.info;
			var statusCode : String = info.code;
			
			switch ( statusCode ) 
			{
				case "NetConnection.Connect.Success" :
					trace("Connection to video application succeeded.");
					_connectionListener(true);					
					break;
			
				case "NetConnection.Connect.Failed" :
					_connectionListener(false);					
					trace("Connection to video application failed");
					break;
					
				case "NetConnection.Connect.Closed" :					
					_connectionListener(false);					
					trace("Connection to video application closed");
					break;
					
				case "NetConnection.Connect.InvalidApp" :				
					_connectionListener(false);
					trace("video application not found on server");
					break;
					
				case "NetConnection.Connect.AppShutDown" :
					_connectionListener(false);
					trace("video application has been shutdown");
					break;
					
				case "NetConnection.Connect.Rejected" :
					_connectionListener(false);
					trace("No permissions to connect to the video application" );
					break;
					
				default :
				   // statements
				   break;
			}
		}
		
		/**
		 * The Red5 oflaDemo returns bandwidth stats.
		 */		
		public function onBWDone():void {
			
		}
			
		protected function netSecurityError( event:SecurityErrorEvent ):void 
		{
			trace("Security error - " + event.text);
			_connectionListener(false);
		}
		
		protected function netIOError( event:IOErrorEvent ):void 
		{
			trace("Input/output error - " + event.text);
			_connectionListener(false);
		}
			
		protected function netASyncError( event:AsyncErrorEvent ):void 
		{
			trace("Asynchronous code error - " + event.error );
			_connectionListener(false);
		}	
	}
}