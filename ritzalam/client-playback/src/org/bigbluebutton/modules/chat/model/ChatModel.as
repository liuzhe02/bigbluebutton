package org.bigbluebutton.modules.chat.model
{
	import org.bigbluebutton.main.model.Participant;
	import org.bigbluebutton.modules.chat.views.components.ChatWindow;
	
	public class ChatModel
	{
		public var participant:Participant;
		
		
		public var window:ChatWindow;
		
		public function ChatModel()
		{
			window = new ChatWindow();
			window.model = this;
		}

		public function getWindow():ChatWindow {
			return window;
		}
		
	}
}