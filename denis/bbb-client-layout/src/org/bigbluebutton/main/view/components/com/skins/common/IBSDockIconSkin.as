package org.bigbluebutton.main.view.components.com.skins.common
{
	
	import mx.skins.ProgrammaticSkin;
	
	public class IBSDockIconSkin extends ProgrammaticSkin
	{
		
		public function IBSDockIconSkin()
		{
			super();
		}
		
		override public function get measuredWidth():Number
		{
			return 11;
		}
		
		override public function get measuredHeight():Number
		{
			return 11;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			graphics.clear();
			if (isNaN(w) || isNaN(h))
				return;
			switch (name)
			{
				case ("docked"):
					graphics.lineStyle(0, 0x000000, 0);
					graphics.beginFill(0x915100, 1);
					graphics.drawRect(3, 1, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x917384, 1);
					graphics.drawRect(3, 2, 1, 5);
					graphics.endFill();
					graphics.beginFill(0x000000, 1);
					graphics.drawRect(4, 1, 3, 1);
					graphics.endFill();
					graphics.beginFill(0x915100, 1);
					graphics.drawRect(6, 2, 1, 5);
					graphics.endFill();
					graphics.beginFill(0xBAC7BA, 1);
					graphics.drawRect(7, 2, 1, 5);
					graphics.endFill();
					graphics.beginFill(0x005184, 1);
					graphics.drawRect(7, 1, 1, 6);
					graphics.endFill();
					graphics.beginFill(0xBAC7BA, 1);
					graphics.drawRect(8, 1, 1, 6);
					graphics.endFill();
					graphics.beginFill(0xCCA26B, 1);
					graphics.drawRect(1, 7, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x000000, 1);
					graphics.drawRect(2, 7, 7, 1);
					graphics.endFill();
					graphics.beginFill(0x75A2BA, 1);
					graphics.drawRect(9, 7, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x917384, 1);
					graphics.drawRect(5, 8, 1, 3);
					graphics.endFill();
					graphics.beginFill(0xBAC7BA, 1);
					graphics.drawRect(6, 8, 1, 3);
					graphics.endFill();
					break;
				case ("undocked"):
					graphics.lineStyle(0, 0x000000, 0);
					graphics.beginFill(0xBA8D4D, 1);
					graphics.drawRect(0, 5, 1, 1);
					graphics.endFill();
					graphics.beginFill(0xBA8D4D, 1);
					graphics.drawRect(0, 5, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x000000, 1);
					graphics.drawRect(1, 5, 3, 1);
					graphics.endFill();
					graphics.beginFill(0xCCB584, 1);
					graphics.drawRect(3, 2, 1, 3);
					graphics.endFill();
					graphics.beginFill(0xCCB584, 1);
					graphics.drawRect(3, 6, 1, 3);
					graphics.endFill();
					graphics.beginFill(0x758DAA, 1);
					graphics.drawRect(4, 2, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x530000, 1);
					graphics.drawRect(4, 3, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x758DAA, 1);
					graphics.drawRect(4, 4, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x538DAA, 1);
					graphics.drawRect(4, 5, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x530000, 1);
					graphics.drawRect(4, 6, 1, 2);
					graphics.endFill();
					graphics.beginFill(0x758DAA, 1);
					graphics.drawRect(4, 8, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x000000, 1);
					graphics.drawRect(5, 3, 5, 1);
					graphics.drawRect(5, 6, 5, 2);
					graphics.endFill();
					graphics.beginFill(0x538DAA, 1);
					graphics.drawRect(10, 3, 1, 1);
					graphics.endFill();
					graphics.beginFill(0x918DAA, 1);
					graphics.drawRect(10, 4, 1, 2);
					graphics.endFill();
					graphics.beginFill(0x538DAA, 1);
					graphics.drawRect(10, 6, 1, 2);
					graphics.endFill();
					break;
			}
		}
		
	}
	
}