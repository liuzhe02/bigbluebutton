package org.bigbluebutton.main.view.components.com.containers.dockablePanelClasses
{
	
	import org.bigbluebutton.main.view.components.com.containers.IBSDockablePanel;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.DividerState;
	import mx.core.UIComponent;
	import mx.events.SandboxMouseEvent;
	
	[Style(name="resizerAlpha", type="Number", inherit="no")]
	[Style(name="resizerColor", type="uint", format="Color", inherit="yes")]
	
	public class IBSResizer extends UIComponent
	{
		public function IBSResizer()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private var isMouseOver:Boolean = false;
		
		private var _state:String = DividerState.UP;
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, 
				unscaledHeight:Number):void
		{
			if (isNaN(width) || isNaN(height))
				return;
			if (!parent || !owner)
				return;
			if (!(owner as IBSDockablePanel).position)
				return;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			if (state != DividerState.DOWN && !(owner as IBSDockablePanel).dragging)
				return;
			var position:String = (owner as IBSDockablePanel).position;
			var alpha:Number = getStyle("resizerAlpha");
			var color:uint = getStyle("resizerColor");
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			if ((owner as IBSDockablePanel).docked)
				return;
			if (event.buttonDown)
				return;
			isMouseOver = true;
			state = DividerState.OVER;
			(owner as IBSDockablePanel).changeCursor();
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			if ((owner as IBSDockablePanel).docked)
				return;
			isMouseOver = false
			state = DividerState.UP;
			if (!(owner as IBSDockablePanel).dragging)
				(owner as IBSDockablePanel).restoreCursor();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			if ((owner as IBSDockablePanel).docked)
				return;
			(owner as IBSDockablePanel).changeCursor();
			(owner as IBSDockablePanel).startResize(this, event);
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			sbRoot.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpHandler);
		}
		
		private function mouseUpHandler(event:Event):void
		{
			if ((owner as IBSDockablePanel).docked)
				return;
			state = DividerState.OVER;
			(owner as IBSDockablePanel).stopResize(this, event as MouseEvent);
			if (!isMouseOver)
				(owner as IBSDockablePanel).restoreCursor();
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			sbRoot.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpHandler);
		}
		
	}
	
}