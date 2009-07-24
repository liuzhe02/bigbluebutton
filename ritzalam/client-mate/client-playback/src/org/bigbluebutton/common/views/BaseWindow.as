package org.bigbluebutton.common.views
{
	import flexlib.mdi.containers.MDIWindow;

	public class BaseWindow extends MDIWindow
	{
		private var _xPosition:int;
		private var _yPosition:int;
			
		public function BaseWindow()
		{
			super();
		}
		
		public function get x():int {
			return _xPosition;
		}
			
		public function get y():int {
			return _yPosition;
		}
			
		public function set x(x:int):void {
			_xPosition = x;
		}
			
		public function set y(y:int):void {
			_yPosition = y;
		}
	}
}