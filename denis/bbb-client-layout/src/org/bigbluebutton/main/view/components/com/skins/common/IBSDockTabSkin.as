package org.bigbluebutton.main.view.components.com.skins.common
{
	
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	import mx.skins.Border;
	
	public class IBSDockTabSkin extends Border
	{
		
		public function IBSDockTabSkin()
		{
			super();
		}
		
		override public function get measuredWidth():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		
		override public function get measuredHeight():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var position:String = null;
			if (parent && parent["position"] && parent["position"] is String)
				position = parent["position"];
			if (position == null)
				position = "left";
			if (position != "left" && position != "right" && 
					position != "top" && position != "bottom")
				position = "left";
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x000000, 0);
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(0, 0, w, h);
			g.endFill();
			switch (name)
			{
				case ("selectedUpSkin"):
					drawSkin(g, position, w, h, 0x4A74AC, 0xB8CFE9, 0x9EBDE0);
					break;
				case ("selectedOverSkin"):
					drawSkin(g, position, w, h, 0xD59A3A, 0xFCAB58, 0xFC942C);
					break;
				case ("upSkin"):
					drawSkin(g, position, w, h, 0x7793B9, 0xE2ECFA, 0xCEDEF3);
					break;
				case ("overSkin"):
					drawSkin(g, position, w, h, 0xC1A965, 0xFBE6AF, 0xF6D27A);
					break;
				case "downSkin":
				case "selectedDownSkin":
					drawSkin(g, position, w, h, 0xD59A3A, 0xFCAB58, 0xFC942C);
					break;
				case "disabledSkin":
				case "selectedDisabledSkin":
					drawSkin(g, position, w, h, 0xD59A3A, 0xFCAB58, 0xFCA54F, 0.7, 0.8);
					break;
			}
		}
		
		private function drawSkin(g:Graphics, position:String, 
				w:Number, h:Number, borderColor:uint, 
				backgroundColor:uint, darkBackgroundColor:uint, 
				backgroundAlpha:Number = 1.0, 
				darkBackgroundAlpha:Number = 1.0):void
		{
			switch (position)
			{
				case ("left"):
					h = h - 1;
					g.lineStyle(1, borderColor, 1);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(-1, 0);
					g.lineTo(w - 7, 0);
					g.lineTo(w - 2, 5);
					g.lineTo(w - 2, h - 4);
					g.lineTo(w - 5, h - 1);
					g.lineTo(-1, h - 1);
					g.lineTo(-1, 0);
					g.endFill();
					g.lineStyle(0, 0x000000, 0);
					g.beginFill(darkBackgroundColor, darkBackgroundAlpha);
					g.drawRect(0, 1, 5, h - 2);
					g.endFill();
					break;
				case ("right"):
					h = h - 1;
					g.lineStyle(1, borderColor, 1);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(4, 1);
					g.lineTo(w, 0);
					g.lineTo(w, h - 1);
					g.lineTo(6, h - 1);
					g.lineTo(1, h - 6);
					g.lineTo(1, 3);
					g.lineTo(4, 0);
					g.endFill();
					g.lineStyle(0, 0x000000, 0);
					g.beginFill(darkBackgroundColor, darkBackgroundAlpha);
					g.drawRect(w - 5, 1, 5, h - 2);
					g.endFill();
					break;
				case ("top"):
					w = w - 1;
					g.lineStyle(1, borderColor, 1);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(0, -1);
					g.lineTo(w - 1, -1);
					g.lineTo(w - 1, h - 7);
					g.lineTo(w - 6, h - 2);
					g.lineTo(3, h - 2);
					g.lineTo(0, h - 5);
					g.lineTo(0, -1);
					g.endFill();
					g.lineStyle(0, 0x000000, 0);
					g.beginFill(darkBackgroundColor, darkBackgroundAlpha);
					g.drawRect(1, 0, w - 2, 5);
					g.endFill();
					break;
				case ("bottom"):
					w = w - 1;
					g.lineStyle(1, borderColor, 1);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(5, 1);
					g.lineTo(w - 4, 1);
					g.lineTo(w - 1, 3);
					g.lineTo(w - 1, h);
					g.lineTo(0, h);
					g.lineTo(0, 6);
					g.lineTo(5, 1);
					g.endFill();
					g.lineStyle(0, 0x000000, 0);
					g.beginFill(darkBackgroundColor, darkBackgroundAlpha);
					g.drawRect(1, h - 5, w - 2, 5);
					g.endFill();
					break;
			}
		}
		
	}
	
}