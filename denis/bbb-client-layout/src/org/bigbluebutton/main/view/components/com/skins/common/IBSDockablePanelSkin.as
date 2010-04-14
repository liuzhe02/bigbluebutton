package org.bigbluebutton.main.view.components.com.skins.common
{
	
	import flash.display.Graphics;
	
	import mx.skins.halo.PanelSkin;
	
	public class IBSDockablePanelSkin extends PanelSkin
	{
		
		public function IBSDockablePanelSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			var g:Graphics = graphics;
			if (isNaN(w) || isNaN(h))
				return;	
			g.clear();
			g.lineStyle(0, 0x000000, 0);
			g.beginFill(0x7699C7, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();
			g.lineStyle(1, 0xD5E4F2, 1);
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(2, 2, w - 5, h - 5);
			g.endFill();
			g.lineStyle(0, 0x000000, 0);
			g.beginFill(0xE3EFFF, 1);
			g.drawRect(3, 3, w - 6, h - 6);
			g.endFill();
			g.beginFill(0xB7CFE9, 1);
			g.drawRect(3, 3, w - 6, 20);
			g.endFill();
		}
		
	}
	
}