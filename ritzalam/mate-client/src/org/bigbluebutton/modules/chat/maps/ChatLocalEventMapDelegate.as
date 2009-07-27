package org.bigbluebutton.modules.chat.maps
{
	import com.asfusion.mate.events.Dispatcher;
	
	import flash.events.IEventDispatcher;
	
	import org.bigbluebutton.main.events.OpenWindowEvent;
	import org.bigbluebutton.modules.chat.events.SendPublicChatMessageEvent;
	import org.bigbluebutton.modules.chat.views.components.ChatWindow;
	
	public class ChatLocalEventMapDelegate
	{
		private var dispatcher:IEventDispatcher;

		private var _chatWindow:ChatWindow;
		private var _chatWindowOpen:Boolean = false;
				
		public function ChatLocalEventMapDelegate(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
			_chatWindow = new ChatWindow();
		}

		public function openChatWindow():void {
		   	_chatWindow.title = "Chat";
		   	_chatWindow.showCloseButton = false;
		   	_chatWindow.xPosition = 675;
		   	_chatWindow.yPosition = 0;
		   	
		   	// Set the local dispatcher for this window so that it can send messages
		   	// that can be heard by the LocalEventMap.
		   	_chatWindow.setLocalDispatcher(dispatcher);
		   	
		   	// Use the GLobal Dispatcher so that this message will be heard by the
		   	// main application.
		   	var globalDispatcher:Dispatcher = new Dispatcher();
			var event:OpenWindowEvent = new OpenWindowEvent(OpenWindowEvent.OPEN_WINDOW_EVENT);
			event.window = _chatWindow;
			trace("Dispatching OPEN CHAT WINDOW EVENT");
			globalDispatcher.dispatchEvent(event);
		   	
		   	_chatWindowOpen = true;

		}
		
		public function receivedOpenWindowEvent():void {
			trace("Receive open window event");
		}
	}
}