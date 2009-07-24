package org.bigbluebutton.modules.chat.managers
{
	public class ChatManager
	{
		public function ChatManager()
		{
		}

		public function receivedMessage():void {
			trace("Got New Chat message");
		}
		
		public function receivedPrivateMessage():void {
			trace("Got New Private Chat message");
		}
		
		public function receivedGlobalMessage():void {
			trace("Got New Global Chat message");
		}
	}
}