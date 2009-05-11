package org.bigbluebutton.modules.whiteboard.model.component
{
	/**
	 * The DrawObjectFactory class receives a series of parameters and constructs an appropriate 
	 * concrete DrawObject given those parameters.
	 * <p>
	 * DrawObjectFactory is a simple implementation of the Factory design pattern 
	 * @author dzgonjan
	 * 
	 */	
	public class DrawObjectFactory
	{
		/**
		 * The default constructor 
		 * 
		 */		
		public function DrawObjectFactory()
		{
		}
		
		/**
		 * Creates a DrawObject by calling the appropriate helper method 
		 * @param type The type of DrawObject to be created
		 * @param shape The array holding the different points needed to create the DrawObject
		 * @param color The color of the DrawObject to be created
		 * @param thickness The thickness of the DrawObject to be created
		 * @return the DrawObject created from the parameters
		 * 
		 */		
		public function makeDrawObject(type:String, shape:Array, color:uint, thickness:uint, text:String):DrawObject{
			var d:DrawObject = null;
			if (type == DrawObject.PENCIL)
			{
				d = makePencil(shape, color, thickness, text);
			} else if (type == DrawObject.RECTANGLE)
			{
				d = makeRectangle(shape, color, thickness, text);
			} else if (type == DrawObject.ELLIPSE)
			{
				d = makeEllipse(shape, color, thickness, text);
			} else if (type == DrawObject.TEXT)
			{
				d = makeText(shape, color, thickness, text);
			}

			return d;
		}
		
		/**
		 * A helper method for the makeDrawObject method which creates a Pencil DrawObject 
		 * <p>
		 * Even though it is a helper method it is made public for testing purposes
		 * @param shape The array holding the different points needed to create the DrawObject
		 * @param color The color of the DrawObject to be created
		 * @param thickness The thickness of the DrawObject to be created
		 * @return the Pencil DrawObject created from the parameters
		 * 
		 */		
		public function makePencil(shape:Array, color:uint, thickness:uint, text:String):DrawObject{
			return new Pencil(shape, color, thickness, text);
		}
		
		/**
		 * A helper method for the makeDrawObject method which creates a Rectangle DrawObject
		 * <p>
		 * Even though it is a helper method it is made public for testing purposes
		 * @param shape The array holding the different points needed to create the DrawObject
		 * @param color The color of the DrawObject to be created
		 * @param thickness The thickness of the DrawObject to be created
		 * @return the Rectangle DrawObject created from the parameters
		 * 
		 */		
		public function makeRectangle(shape:Array, color:uint, thickness:uint, text:String):DrawObject{
			return new Rectangle(shape, color, thickness, text);
		}
		
		/**
		 * A helper method for the makeDrawObject method whitch creates an Ellipse DrawObject
		 * <p>
		 * Even though it is a helper method it is made public for testing purposes
		 * @param shape The array holding the different points needed to create the DrawObject
		 * @param color The color of the DrawObject to be created
		 * @param thickness The thickness of the DrawObject to be created
		 * @return the Ellipse DrawObject created from the parameters
		 * 
		 */		
		public function makeEllipse(shape:Array, color:uint, thickness:uint, text:String):DrawObject{
			return new Ellipse(shape, color, thickness, text);
		}

		/**
		 * A helper method for the makeDrawObject method whitch creates an Text DrawObject
		 * <p>
		 * Even though it is a helper method it is made public for testing purposes
		 * @param shape The array holding the different points needed to create the DrawObject
		 * @param color The color of the DrawObject to be created
		 * @param thickness The thickness of the DrawObject to be created
		 * @return the Ellipse DrawObject created from the parameters
		 * 
		 */		
		public function makeText(shape:Array, color:uint, thickness:uint, text:String):DrawObject{
			return new Text(shape, color, thickness, text);
		}
	}
}