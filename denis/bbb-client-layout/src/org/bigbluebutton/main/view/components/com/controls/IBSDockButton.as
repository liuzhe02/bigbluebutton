package org.bigbluebutton.main.view.components.com.controls
{
	
	import org.bigbluebutton.main.view.components.com.skins.common.IBSDockIconSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.core.IFlexDisplayObject;
	import mx.core.IProgrammaticSkin;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Event(name="dockedChanged", type="flash.events.Event")]
	[Event(name="dockedChangedByUser", type="flash.events.Event")]
	
	public class IBSDockButton extends LinkButton
	{
		
		public function IBSDockButton()
		{
			super();
			this.buttonMode = false;
		}
		
		private var _docked:Boolean = true;
		
		public function get docked():Boolean
		{
			return _docked;
		}
		
		public function set docked(value:Boolean):void
		{
			_docked = value;
			this.invalidateProperties();
			this.invalidateDisplayList();
			this.dispatchEvent(new Event("dockedChanged"));
		}
		
		override public function get focusEnabled():Boolean
		{
			return false;
		}
		
		override public function get label():String
		{
			return "";
		}
		
		override public function get selected():Boolean
		{
			return false;
		}
		
		override public function get toggle():Boolean
		{
			return false;
		}
		
		private var dockIcon:Object = null;
		
		public function setDockStatus(value:Boolean):void
		{
			_docked = value;
			this.invalidateProperties();
			this.invalidateDisplayList();
		}
		
		override mx_internal function getCurrentIconName():String
		{
			return (_docked ? "docked" : "undocked");
		}
		
		override mx_internal function viewIconForPhase(
				tempIconName:String):IFlexDisplayObject
		{
			if (dockIcon == null)
			{
				dockIcon = new Object();
				dockIcon["docked"] = IFlexDisplayObject(new IBSDockIconSkin());
				this.addChild(DisplayObject(dockIcon["docked"]));
				dockIcon["docked"].name = "docked";
				dockIcon["undocked"] = IFlexDisplayObject(new IBSDockIconSkin());;
				this.addChild(DisplayObject(dockIcon["undocked"]));
				dockIcon["undocked"].name = "undocked";
			}
			dockIcon["docked"].visible = false;
			dockIcon["undocked"].visible = false;
			if (dockIcon[tempIconName] == undefined)
				return null;
			var currentIcon:IFlexDisplayObject = IFlexDisplayObject(
					dockIcon[tempIconName]);
			IProgrammaticSkin(currentIcon).validateDisplayList();
			this.setChildIndex(DisplayObject(currentIcon), this.numChildren - 1);
			currentIcon.setActualSize(currentIcon.measuredWidth, 
					currentIcon.measuredHeight);
			currentIcon.visible = true;
			return currentIcon;
		}
		
		override mx_internal function layoutContents(unscaledWidth:Number, 
				unscaledHeight:Number, offset:Boolean):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight, offset);
			var currentIcon:IFlexDisplayObject = this.getCurrentIcon();
			if (currentIcon)
			{
				currentIcon.x = (this.width - currentIcon.width) / 2;
				currentIcon.y = (this.height - currentIcon.height) / 2;
			}
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			if (!this.enabled)
			{
				event.stopImmediatePropagation();
				return;
			}
			this.docked = !this.docked;
			this.dispatchEvent(new Event("dockedChangedByUser"));
			event.updateAfterEvent();
		}
		
	}
	
}