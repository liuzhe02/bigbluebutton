package org.bigbluebutton.modules.whiteboard.model.business
{
	import org.bigbluebutton.modules.whiteboard.model.component.DrawObject;

	public interface IWhiteboardService
	{
		function join():void;
		function leave():void;
		function sendMessage(message:String):void;
		function getWhiteboardTranscript():void;
		function addMessageListener(msgListener:Function):void;
		function addConnectionStatusListener(connectionListener:Function):void;

		function sendShape(shape:DrawObject):void;
	}
}