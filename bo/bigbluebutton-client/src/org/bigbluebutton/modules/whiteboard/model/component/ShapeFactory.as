package org.bigbluebutton.modules.whiteboard.model.component
{
	import flash.display.Shape;
	
	import mx.core.*;
	import mx.graphics.*;
	import flash.text.*;
	import flash.display.*;
	import flash.geom.Matrix;
	
	/**
	 * The ShapeFactory receives DrawObjects and converts them to Flash Shapes which can then be displayed
	 * <p>
	 * This approach is necessary because Red5 does not allow Graphical Objects to be stored 
	 * in remote shared objects 
	 * @author dzgonjan
	 * 
	 */	
	public class ShapeFactory
	{
		private var drawFactory:DrawObjectFactory;
		
		public function ShapeFactory()
		{
			drawFactory = new DrawObjectFactory();
		}
		
		/**
		 * Creates a Flash Shape, given a DrawObject representation of it 
		 * @param shape
		 * @return 
		 * 
		 */		
		public function makeShape(shape:DrawObject):Shape{
			var s:Shape = null;
			if (shape.getType() == DrawObject.PENCIL){
				s = makePencil(Pencil(shape));
			} else if (shape.getType() == DrawObject.RECTANGLE){
				s = makeRectangle(Rectangle(shape));
			} else if (shape.getType() == DrawObject.ELLIPSE){
				s = makeEllipse(Ellipse(shape));
			} else if (shape.getType() == DrawObject.TEXT){
				s = makeText(Text(shape));
			}

			return s;
		}
		
		/**
		 * Creates a shape from the specified parameters 
		 * @param segment
		 * @param type
		 * @param color
		 * @param thickness
		 * @return A Flash Shape object
		 * 
		 */		
		public function makeFeedback(segment:Array, type:String, color:uint, thickness:uint, text:String):Shape{
			return makeShape(drawFactory.makeDrawObject(type,segment, color, thickness, text));
		}
		
		/**
		 * Creates a Flash Shape from a Pencil DrawObject 
		 * @param p a Pencil DrawObject
		 * @return a Shape
		 * 
		 */		
		private function makePencil(p:Pencil):Shape{
			var newShape:Shape = new Shape();
			newShape.graphics.lineStyle(p.getThickness(), p.getColor());
            
	            for (var c:Number = 2; c < p.getShapeArray().length ; c += 2){
	            	newShape.graphics.moveTo(p.getShapeArray()[c-2], p.getShapeArray()[c-1]);
	            	newShape.graphics.lineTo(p.getShapeArray()[c],p.getShapeArray()[c+1]);
	            }
	            
	        return newShape;
		}
		
		/**
		 * Creates a Flash Shape from a Rectangle DrawObject 
		 * @param r a Rectangle DrawObject
		 * @return a Shape
		 * 
		 */		
		private function makeRectangle(r:Rectangle):Shape{
			var newShape:Shape = new Shape();
			newShape.graphics.lineStyle(r.getThickness(), r.getColor());
			var arrayEnd:Number = r.getShapeArray().length;
			var x:Number = r.getShapeArray()[0];
			var y:Number = r.getShapeArray()[1];
			var width:Number = r.getShapeArray()[arrayEnd-2] - x;
			var height:Number = r.getShapeArray()[arrayEnd-1] - y;
			
			newShape.graphics.drawRect(x,y,width,height);
			
			return newShape;	
		}

		/**
		 * Creates a Flash Shape from a Rectangle DrawObject 
		 * @param r a Rectangle DrawObject
		 * @return a Shape
		 * 
		 */		
		private function makeText(r:Text):Shape
		{
			var newShape:Shape = new Shape();

			var arrayEnd:Number = r.getShapeArray().length;
			var x:Number = r.getShapeArray()[0];
			var y:Number = r.getShapeArray()[1];
			var x2:Number = r.getShapeArray()[arrayEnd-2];
			var y2:Number = r.getShapeArray()[arrayEnd-1];
			
			var uit:UITextField = new UITextField();
			uit.htmlText = "<font size='" +r.getThickness()*10 + "'>" + r.getText() + "</font>";
			uit.textColor = r.getColor();
			uit.autoSize = TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
 
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			textBitmapData =ImageSnapshot.captureBitmapData(uit,sizeMatrix);
			var sm:Matrix = new Matrix();
			sm.tx = (x+x2)/2;
			sm.ty = (y+y2)/2;
			newShape.graphics.beginBitmapFill(textBitmapData,sm,false);

//			newShape.graphics.lineStyle(r.getThickness(), r.getColor());
//			newShape.graphics.lineStyle(0, r.getColor());
			newShape.graphics.drawRect((x+x2)/2, (y+y2)/2,uit.measuredWidth, uit.measuredHeight);
			newShape.graphics.endFill();			
			
			return newShape;	
		}

		
		/**
		 * Creates a Flash Shape from an Ellipse DrawObject 
		 * @param e an Ellipse DrawObject
		 * @return a Shape
		 * 
		 */		
		private function makeEllipse(e:Ellipse):Shape{
			var newShape:Shape = new Shape();
			newShape.graphics.lineStyle(e.getThickness(), e.getColor());
			var arrayEnd:Number = e.getShapeArray().length;
			var x:Number = e.getShapeArray()[0];
			var y:Number = e.getShapeArray()[1];
			var width:Number = e.getShapeArray()[arrayEnd-2] - x;
			var height:Number = e.getShapeArray()[arrayEnd-1] - y;
			
			newShape.graphics.drawEllipse(x,y,width,height);
			
			return newShape;
		}

	}
}