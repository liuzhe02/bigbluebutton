package org.bigbluebutton.main.view.components.com.controls.dockBarClasses
{
	
	import org.bigbluebutton.main.view.components.com.controls.IBSDockBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	
	import mx.core.EdgeMetrics;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IProgrammaticSkin;
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.DynamicEvent;
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	import mx.styles.ISimpleStyleClient;
	
	[Style(name="color", type="uint", format="Color", inherit="yes")]
	[Style(name="disabledColor", type="uint", format="Color", inherit="yes")]
	[Style(name="fontAntiAliasType", type="String", enumeration="normal,advanced", inherit="yes")]
	[Style(name="fontFamily", type="String", inherit="yes")]
	[Style(name="fontGridFitType", type="String", enumeration="none,pixel,subpixel", inherit="yes")]
	[Style(name="fontSharpness", type="Number", inherit="yes")]
	[Style(name="fontSize", type="Number", format="Length", inherit="yes")]
	[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]
	[Style(name="fontThickness", type="Number", inherit="yes")]
	[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]
	[Style(name="kerning", type="Boolean", inherit="yes")]
	[Style(name="letterSpacing", type="Number", inherit="yes")]
	[Style(name="textAlign", type="String", enumeration="left,center,right", inherit="yes")]
	[Style(name="textDecoration", type="String", enumeration="none,underline", inherit="yes")]
	[Style(name="textIndent", type="Number", format="Length", inherit="yes")]
	[Style(name="skin", type="Class", inherit="no", 
			states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]
	[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]
	[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]
	
	[Event(name="valueCommit", type="mx.events.FlexEvent")]
	[Event(name="autoSelect", type="mx.events.DynamicEvent")]
	
	public class IBSDockTab extends UIComponent
	{
		
		public static const AUTO_SELECT:String = "autoSelect";
		
		public static const AUTO_SELECT_TIMEOUT:int = 400;
		
		public function IBSDockTab()
		{
			super();
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private var textField:IUITextField = null;
		
		private var currentSkin:IFlexDisplayObject = null;
		
		private var skins:Array = [];
		
		private var phase:String = "up";
		
		private var bitmap:Bitmap = null;
		private var bitmapData:BitmapData = null;
		
		private var selectTimer:Timer = null;
		private var unselectTimer:Timer = null;
		private var rollOverFlag:Boolean = false;
		
		private var _label:String = "";
		private var labelChanged:Boolean = false;
		
		[Bindable("labelChanged")]
		[Inspectable(category="General", defaultValue="")]
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			labelChanged = true;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("labelChanged"));
		}
		
		private var _rebound:Boolean = false;
		private var reboundChanged:Boolean = false;
		
		[Bindable("reboundChanged")]
		[Inspectable(category="General", defaultValue="false")]
		public function get rebound():Boolean
		{
			return _rebound;
		}
		
		public function set rebound(value:Boolean):void
		{
			_rebound = value;
			reboundChanged = true;
			invalidateProperties();
			invalidateDisplayList();
			dispatchEvent(new Event("reboundChanged"));
		}
		
		private var _selected:Boolean = false;
		
		[Bindable("click")]
		[Bindable("valueCommit")]
		[Inspectable(category="General", defaultValue="false")]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			invalidateDisplayList();
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT, true));
		}
		
		private var _position:String = "left";
		
		[Bindable("positionChanged")]
		[Inspectable(category="General", defaultValue="left")]
		public function get position():String
		{
			return _position;
		}
		
		public function set position(value:String):void
		{
			if (value == "left" || value == "right" || value == "top" || value == "bottom")
			{
				_position = value;
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("positionChanged"));
			}
		}
		
		public function get padding():EdgeMetrics
		{
			var left:Number = 0;
			var right:Number = 0;
			var top:Number = 0;
			var bottom:Number = 0;
			var _left:Number = getStyle("left");
			var _right:Number = getStyle("right");
			var _top:Number = getStyle("top");
			var _bottom:Number = getStyle("bottom");
			switch (_position)
			{
				case ("left"):
					top = _left;
					bottom = _right;
					right = _top;
					left = _bottom;
					break;
				case ("right"):
					bottom = _left;
					top = _right;
					left = _top;
					right = _bottom;
					break;
				case ("top"):
					right = _left;
					left = _right;
					bottom = _top;
					top = _bottom;
					break;
				case ("bottom"):
					left = _left;
					right = _right;
					top = _top;
					bottom = _bottom;
					break;
			}
			left = isNaN(left) ? 0 : left;
			right = isNaN(right) ? 0 : right;
			top = isNaN(top) ? 0 : top;
			bottom = isNaN(bottom) ? 0 : bottom;
			return new EdgeMetrics(left, top, right, bottom);
		}
		
		override public function get focusEnabled():Boolean
		{
			return false;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if (!textField)
			{
				textField = IUITextField(createInFontContext(UITextField));
				textField.type = TextFieldType.DYNAMIC;
				textField.background = false;
				textField.border = false;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.visible = false;
				textField.styleName = this;
				addChild(textField as DisplayObject);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (reboundChanged)
			{
				if (rebound)
					selected = false;
				reboundChanged = false;
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			var textWidth:Number = textField.width;
			var textHeight:Number = textField.height;
			if (textField.text != _label)
			{
				textField.text = _label;
				textField.scaleX = 1;
				textField.scaleY = 1;
				textWidth = textField.width;
				textHeight = textField.height;
				if (textField.width > 2880)
				{
					textField.scaleX = 2880 / textField.width;
					textWidth = 2880;	
				}
				if (textField.height > 2880)
				{
					textField.scaleY = 2880 / textField.height;
					textHeight = 2880;
				}
			}				
			if (_position == "top" || _position == "bottom")
			{
				measuredMinWidth = textWidth;
				measuredMinHeight = textHeight;
			}
			else
			{
				measuredMinWidth = textHeight;
				measuredMinHeight = textWidth;
			}
			var paddingMetrics:EdgeMetrics = padding;
			measuredWidth = measuredMinWidth + paddingMetrics.left + paddingMetrics.right;
			measuredHeight = measuredMinHeight + paddingMetrics.top + paddingMetrics.bottom;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, 
				unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x000000, 0);
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
			changeSkins();
			var n:int = skins.length;
			for (var i:int = 0; i < n; i++)
			{
				var skin:IFlexDisplayObject = IFlexDisplayObject(skins[i]);
				skin.move(0, 0);
				skin.setActualSize(unscaledWidth, unscaledHeight);
			}
			var paddingMetrics:EdgeMetrics = padding;
			var leftPadding:Number = 0;
			var topPadding:Number = 0;
			if (unscaledWidth > measuredMinWidth)
				leftPadding = paddingMetrics.left;
			else
				leftPadding = (unscaledWidth - measuredMinWidth) / 2;
			if (unscaledHeight > measuredMinHeight)
				topPadding = paddingMetrics.top;
			else
				topPadding = (unscaledHeight - measuredMinHeight) / 2;
			if (labelChanged)
			{
				bitmapData = null;
				labelChanged = false;
			}
			// 注释掉下面的代码, 因为对于英文字体执行下面代码, 鼠标每次经过都会使文本加粗
			/*
			if (!bitmapData)
				bitmapData = new BitmapData(Math.min(textField.width, 2880), 
						Math.min(textField.height, 2880), true, 0xFFFFFF);
			*/
			bitmapData = new BitmapData(Math.min(textField.width, 2880), 
					Math.min(textField.height, 2880), true, 0xFFFFFF);
			var matrix:Matrix = new Matrix();
			bitmapData.draw(textField, matrix);
			if (bitmap)
				removeChild(bitmap);
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bitmap.x = 0;
			bitmap.y = 0;
			switch (_position)
			{
				case ("left"):
					bitmap.rotation = 90;
					bitmap.x = bitmap.x + bitmapData.height + leftPadding;
					bitmap.y = bitmap.y + topPadding;
					break;
				case ("right"):
					bitmap.rotation = -90;
					bitmap.x = bitmap.x + leftPadding;
					bitmap.y = bitmap.y + bitmapData.width + topPadding;
					break;
				case ("top"):
					bitmap.rotation = -180;
					bitmap.x = bitmap.x + bitmapData.width + leftPadding;
					bitmap.y = bitmap.y + bitmapData.height + topPadding;
					break;
				case ("bottom"):
					bitmap.rotation = 0;
					bitmap.x = bitmap.x + leftPadding;
					bitmap.y = bitmap.y + topPadding;
					break;
			}
			addChild(bitmap);
			if (textField.visible)
				textField.visible = false;
		}
		
		override public function setStyle(styleProp:String, newValue:*):void
		{
			super.setStyle(styleProp, newValue);
			if (styleProp == "styleName" || styleProp == "left" || styleProp == "right" || 
					styleProp == "top" || styleProp == "bottom" || styleProp == "skin" || 
					styleProp == "color" || styleProp == "textRollOverColor" || 
					styleProp == "textSelectedColor")
			{
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private function changeSkins():void
		{
			var n:int = skins.length;
			for (var i:int = 0; i < n; i++)
				removeChild(skins[i]);
			skins = [];
			viewSkin();
		}
		
		private function viewSkin():void
		{
			var stateName:String = "";
			var skin:IFlexDisplayObject = null;
			if (!enabled)
				stateName = (selected ? "selectedDisabled" : "disabled");
			else if (phase == "up")
				stateName = (selected ? "selectedUp" : "up");
			else if (phase == "over")
				stateName = (selected ? "selectedOver" : "over");
			else if (phase == "down")
				stateName = (selected ? "selectedDown" : "down");
			if (enabled && rebound)
			{
				if (phase == "up")
					stateName = "up";
				if (phase == "over")
					stateName = "selectedOver";
				if (phase == "down")
					stateName = "selectedDown";
			}
			var skinClass:Class = Class(getStyle("skin"));
			if (skinClass)
			{
				skin = (new skinClass() as IFlexDisplayObject);
				var styleableSkin:ISimpleStyleClient = (skin as ISimpleStyleClient);
				if (styleableSkin)
					styleableSkin.styleName = this;
				skin.name = stateName + "Skin";
				addChild(DisplayObject(skin));
				skin.setActualSize(unscaledWidth, unscaledHeight);
				if (skin is IInvalidating && initialized)
					IInvalidating(skin).validateNow();
				else if (skin is IProgrammaticSkin && initialized)
					IProgrammaticSkin(skin).validateDisplayList();
				skins.push(skin);
			}
			if (currentSkin)
				currentSkin.visible = false;
			currentSkin = skin;
			if (currentSkin)
				currentSkin.visible = true;
			var labelColor:Number = 0;
			if (enabled)
			{
				if (stateName == "over")
					labelColor = textField.getStyle("textRollOverColor");
				else if (phase == "down")
					labelColor = textField.getStyle("textSelectedColor");
				else
					labelColor = textField.getStyle("color");
			}
			else
			{
				labelColor = textField.getStyle("disabledColor");
			}
			textField.setColor(labelColor);
		}
		
		private function enableSelectTimer(enable:Boolean = true):void
		{
			if (!enable)
			{
				if (selectTimer)
					selectTimer.stop();
				return;
			}
			if (!selectTimer)
			{
				selectTimer = new Timer(AUTO_SELECT_TIMEOUT, 1);
				selectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, 
						selectTimerCompleteHandler);
			}
			selectTimer.stop();
			selectTimer.reset();
			selectTimer.start();
		}
		
		private function enableUnselectTimer(enable:Boolean = true):void
		{
			if (!enable)
			{
				if (unselectTimer)
					unselectTimer.stop();
				return;
			}
			if (!unselectTimer)
			{
				unselectTimer = new Timer(AUTO_SELECT_TIMEOUT, 1);
				unselectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, 
						unselectTimerCompleteHandler);
			}
			unselectTimer.stop();
			unselectTimer.reset();
			unselectTimer.start();
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			rollOverFlag = true;
			enableUnselectTimer(false);
			if (phase == "up")
			{
				if (event.buttonDown)
					return;
				if (rebound && !selected)
				{
					selected = true;
					enableSelectTimer();
				}
				phase = "over";
				invalidateDisplayList();
				event.updateAfterEvent();
			}
			else if (phase == "over")
			{
				phase = "down";
				invalidateDisplayList();
				event.updateAfterEvent();
			}
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			rollOverFlag = false;
			enableSelectTimer(false);
			if (phase == "over")
			{
				if (rebound && selected)
				{
					selected = false;
					enableUnselectTimer();
				}
				phase = "up";
				invalidateDisplayList();
				event.updateAfterEvent();
			}
			else if (phase == "down")
			{
				phase = "over";
				invalidateDisplayList();
				event.updateAfterEvent();
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if (!enabled || rebound)
				return;
			systemManager.getSandboxRoot().addEventListener(
					MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			systemManager.getSandboxRoot().addEventListener(
					SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
			phase = "down";
			dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
			invalidateDisplayList();
			event.updateAfterEvent();
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (!enabled || rebound)
				return;
			phase = "over";
			systemManager.getSandboxRoot().removeEventListener(
					MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			systemManager.getSandboxRoot().removeEventListener(
					SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
			invalidateDisplayList();
			event.updateAfterEvent();
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (!enabled || rebound)
			{
				event.stopImmediatePropagation();
				return;
			}
			if (!selected)
				selected = true;
			event.updateAfterEvent();
		}
		
		private function systemManager_mouseUpHandler(event:MouseEvent):void
		{
			if (contains(event.target as DisplayObject))
				return;
			phase = "up";
			systemManager.getSandboxRoot().removeEventListener(
					MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			systemManager.getSandboxRoot().removeEventListener(
					SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
			invalidateDisplayList();
			event.updateAfterEvent();
		}
		
		private function stage_mouseLeaveHandler(event:Event):void
		{
			phase = "up";
			systemManager.getSandboxRoot().removeEventListener(
					MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			systemManager.getSandboxRoot().removeEventListener(
					SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
		}
		
		private function selectTimerCompleteHandler(event:TimerEvent):void
		{
			var newEvent:DynamicEvent = null;
			if (rollOverFlag)
			{
				newEvent = new DynamicEvent(AUTO_SELECT, true);
				newEvent.select = true;
				dispatchEvent(newEvent);
			}
		}
		
		private function unselectTimerCompleteHandler(event:TimerEvent):void
		{
			var newEvent:DynamicEvent = new DynamicEvent(AUTO_SELECT, true);
			newEvent.select = false;
			dispatchEvent(newEvent);
		}
		
	}
	
}