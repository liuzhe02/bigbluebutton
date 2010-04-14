package org.bigbluebutton.main.view.components.com.containers
{
	
	import org.bigbluebutton.main.view.components.com.containers.dockablePanelClasses.IBSResizer;
	import org.bigbluebutton.main.view.components.com.controls.IBSDockButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.DividerState;
	import mx.containers.Panel;
	import mx.core.mx_internal;
	import mx.events.ResizeEvent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	use namespace mx_internal;
	
	[Style(name="dockButtonPositionX", type="Number", format="Length", inherit="no")]
	[Style(name="dockButtonPositionY", type="Number", format="Length", inherit="no")]
	[Style(name="dockButtonStyleName", type="String", inherit="no")]
	[Style(name="resizerThickness", type="Number", format="Length", inherit="no")]
	[Style(name="resizerAlpha", type="Number", inherit="no")]
	[Style(name="resizerColor", type="uint", format="Color", inherit="yes")]
	
	[Event(name="dockedChanged", type="flash.events.Event")]
	[Event(name="dockedChangedByUser", type="flash.events.Event")]
	[Event(name="resizedByUser", type="flash.events.Event")]
	
	public class IBSDockablePanel extends Panel
	{
		
		public function IBSDockablePanel()
		{
			super();
			addEventListener(ResizeEvent.RESIZE, resizeHandler);
		}
		
		[Embed(source="Assets.swf", symbol="mx.skins.cursor.HBoxDivider")]
		private var hDividerClass:Class;
		
		[Embed(source="Assets.swf", symbol="mx.skins.cursor.VBoxDivider")]
		private var vDividerClass:Class;
		
		private var _index:int = -1;
		
		internal function get index():int
		{
			return _index;
		}
		
		internal function set index(value:int):void
		{
			_index = value;
		}
		
		private var _docked:Boolean = true;
		private var dockedChanged:Boolean = false;
		
		public function get docked():Boolean
		{
			return _docked;
		}
		
		public function set docked(value:Boolean):void
		{
			_docked = value;
			dockedChanged = true;
			invalidateProperties();
		}
		
		public function get position():String
		{
			if (owner && owner["position"])
				return owner["position"];
			return null;
		}
		
		private var _dragging:Boolean = false;
		
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		protected var dockButton:IBSDockButton = null;
		
		protected var resizer:IBSResizer = null;
		
		private var cursorID:int = CursorManager.NO_CURSOR;
		
		private var resizerStartPosition:Number = 0;
		
		private var startStagePosition:Number = 0;
		
		override protected function createChildren():void
		{
			super.createChildren();
			if (!dockButton)
			{
				dockButton = new IBSDockButton();
				dockButton.width = 17;
				dockButton.height = 17;
				setDockButtonPosition();
				var dockButtonStyleName:String = 
						getStyle("dockButtonStyleName");
				dockButton.styleName = dockButtonStyleName;
				dockButton.setDockStatus(_docked);
				dockButton.addEventListener("dockedChanged", 
						dockButtonDockedChangedHandler);
				dockButton.addEventListener("dockedChangedByUser", 
						dockButtonDockedChangedByUserHandler);
				titleBar.addChild(dockButton);
				titleBar.addEventListener(ResizeEvent.RESIZE, 
						titleBarResizeHandler);
			}
			if (!resizer)
			{
				resizer = new IBSResizer();
				resizer.owner = this;
				resizer.focusEnabled = false;
				resizer.setStyle("resizerAlpha", getStyle("resizerAlpha"));
				resizer.setStyle("resizerColor", getStyle("resizerColor"));
				rawChildren.addChild(resizer);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (dockedChanged)
			{
				if (dockButton)
					dockButton.setDockStatus(_docked);
				dockedChanged = false;
				dispatchEvent(new Event("dockedChanged"));
			}
		}
		
		override public function styleChanged(styleProp:String):void
		{
			var allStyles:Boolean = (!styleProp || styleProp == "styleName");
			if (allStyles || styleProp == "dockButtonStyleName")
			{
				if (dockButton)
				{
					var dockButtonStyleName:String = 
							getStyle("dockButtonStyleName");
					dockButton.styleName = dockButtonStyleName;
				}
			}
			if (allStyles || styleProp == "dockButtonPositionX" 
					|| styleProp == "dockButtonPositionY")
			{
				if (dockButton)
					setDockButtonPosition();
			}
			if (resizer)
			{
				if (allStyles || styleProp == "resizerAlpha")
					resizer.setStyle("resizerAlpha", getStyle("resizerAlpha"));
				if (allStyles || styleProp == "resizerColor")
					resizer.setStyle("resizerColor", getStyle("resizerColor"));
			}
			super.styleChanged(styleProp);
		}
		
		override protected function startDragging(event:MouseEvent):void
		{
			// Do nothing
		}
		
		private function setDockButtonPosition():void
		{
			var offsetX:Number = getStyle("dockButtonPositionX");
			var offsetY:Number = getStyle("dockButtonPositionY");
			offsetX = (isNaN(offsetX) ? 5 : offsetX);
			offsetY = (isNaN(offsetY) ? 4 : offsetY);
			if (dockButton)
			{
				dockButton.x = width - dockButton.width - offsetX + 1;
				dockButton.y = offsetY;
			}
		}
		
		private function setResizerAppearance():void
		{
			if (!position || !resizer)
				return;
			var thickness:Number = getStyle("resizerThickness");
			if (isNaN(thickness))
				thickness = 4;
			if (position == "left" || position == "right")
				resizer.width = thickness;
			else
				resizer.height = thickness;
		}
		
		private function setResizerPosition():void
		{
			if (!isPopUp || !position)
				return;
			setResizerAppearance();
			switch (position)
			{
				case ("left"):
					resizer.x = width - resizer.width;
					resizer.y = 0;
					resizer.height = height;
					break;
				case ("right"):
					resizer.x = 0;
					resizer.y = 0;
					resizer.height = height;
					break;
				case ("top"):
					resizer.x = 0;
					resizer.y = height - resizer.height;
					resizer.width = width;
					break;
				case ("bottom"):
					resizer.x = 0;
					resizer.y = 0;
					resizer.width = width;
					break;
			}
		}
		
		public function changeCursor():void
		{
			if (cursorID == CursorManager.NO_CURSOR)
			{
				var cursorClass:Class = null;
				if (position == "left" || position == "right")
					cursorClass = hDividerClass;
				else
					cursorClass = vDividerClass;
				cursorID = cursorManager.setCursor(cursorClass, 
						CursorManagerPriority.HIGH, 0, 0);
			}
		}
		
		public function restoreCursor():void
		{
			if (cursorID != CursorManager.NO_CURSOR)
			{
				cursorManager.removeCursor(cursorID);
				cursorID = CursorManager.NO_CURSOR;
			}
		}
		
		public function startResize(resizer:IBSResizer, trigger:MouseEvent):void
		{
			resizerStartPosition = getMousePosition(trigger);
			startStagePosition = ((position == "left" || position == "right") ? 
					trigger.stageX : trigger.stageY);
			resizer.state = DividerState.DOWN;
			_dragging = true;
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, 
					mouseMoveHandler, true);
			systemManager.deployMouseShields(true);
		}
		
		public function stopResize(resizer:IBSResizer, trigger:MouseEvent):void
		{
			_dragging = false;
			resizer.state = DividerState.UP;
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, 
					mouseMoveHandler, true);
			systemManager.deployMouseShields(false);
			dispatchEvent(new Event("resizedByUser"));
			setResizerPosition();
		}
		
		private function getMousePosition(event:MouseEvent):Number
		{
			var point:Point = new Point(event.stageX, event.stageY);
			point = globalToLocal(point);
			return ((position == "left" || position == "right") ? point.x : point.y);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var currentStagePosition:Number = ((position == "left" || position == "right") ? 
					event.stageX : event.stageY);
			var dragDelta:Number = currentStagePosition - startStagePosition;
			if (position == "left" || position == "right")
			{
				if (resizerStartPosition + dragDelta + resizer.width >= minWidth && 
						resizerStartPosition + dragDelta + resizer.width <= maxWidth)
				{
					resizer.x = resizerStartPosition + dragDelta;
					width = resizer.x + resizer.width;
				}
			}
			else
			{
				if (resizerStartPosition + dragDelta + resizer.height >= minHeight && 
						resizerStartPosition + dragDelta + resizer.height <= maxHeight)
				{
					resizer.y = resizerStartPosition + dragDelta;
					height = resizer.y + resizer.height;
				}
			}
            invalidateDisplayList();
            updateDisplayList(unscaledWidth, unscaledHeight);
            resizer.invalidateDisplayList();
		}
		
		private function resizeHandler(event:ResizeEvent):void
		{
			if (!dragging)
				setResizerPosition();
		}
		
		private function titleBarResizeHandler(event:ResizeEvent):void
		{
			if (dockButton)
				setDockButtonPosition();
		}
		
		private function dockButtonDockedChangedHandler(event:Event):void
		{
			docked = (event.target as IBSDockButton).docked;
		}
		
		private function dockButtonDockedChangedByUserHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
	}
	
}