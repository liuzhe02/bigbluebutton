package org.bigbluebutton.modules.whiteboard.model.component
{
	/**
	 * The Text class. Extends a DrawObject 
	 * @author boxu
	 * 
	 */	
	public class Text extends DrawObject
	{
		/**
		 * The dafault constructor. Creates a Text DrawObject 
		 * @param segment the array representing the points needed to create this Text
		 * @param color the Color of this Text
		 * @param thickness the thickness of this Text
		 * 
		 */		
		public function Text(segment:Array, color:uint, thickness:uint, text:String)
		{
			super(DrawObject.TEXT, segment, color, thickness, text);
		}
		
		/**
		 * Gets rid of the unnecessary data in the segment array, so that the object can be more easily passed to
		 * the server 
		 * 
		 */		
		override protected function optimize():void{
			var x1:Number = this.shape[0];
			var y1:Number = this.shape[1];
			var x2:Number = this.shape[this.shape.length - 2];
			var y2:Number = this.shape[this.shape.length - 1];
			
			this.shape = new Array();
			this.shape.push(x1);
			this.shape.push(y1);
			this.shape.push(x2);
			this.shape.push(y2);
		}
		
	}
}