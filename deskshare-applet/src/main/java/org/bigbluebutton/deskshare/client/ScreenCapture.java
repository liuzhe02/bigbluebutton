package org.bigbluebutton.deskshare.client;

import java.awt.AWTException;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;

/**
 * The Capture class uses the java Robot class to capture the screen
 * The image captured is scaled down. This is done because of bandwidth issues and because it
 * is unnecessary for the Flex Client to be able to see the full screen, in fact it is undesirable
 * to do so.
 * The image can then be sent for further processing
 * @author Snap
 *
 */
public class ScreenCapture {
	
	private Robot robot;
	private Toolkit toolkit;
	private Rectangle screenBounds;
	
	private int width, height, x,y, videoWidth, videoHeight;
	private boolean needScale = true;
	
	public ScreenCapture(int x, int y, int screenWidth, int screenHeight){
		this.width = screenWidth;
		this.height = screenHeight;
		try{
			robot = new Robot();
		}catch (AWTException e){
			System.out.println(e.getMessage());
		}
		this.toolkit = Toolkit.getDefaultToolkit();
		this.screenBounds = new Rectangle(x, y, this.width, this.height);
		this.needScale = areDimensionsScaled(this.width, this.height);
	}
	
	public BufferedImage takeSingleSnapshot(){
		if (needScale) {
			return getScaledImage(robot.createScreenCapture(this.screenBounds));
		}
		else {
			return robot.createScreenCapture(this.screenBounds);
		}
	}
	
	public int getScreenshotWidth(){
		return toolkit.getScreenSize().width;
	}
	
	public int getScreenshotHeight(){
		return toolkit.getScreenSize().height;
	}
	
	public void setWidth(int width){
		int screenWidth = toolkit.getScreenSize().width;
		if (width > screenWidth) this.width = screenWidth;
		else this.width = width;
		updateBounds();
	}
	
	public void setHeight(int height){
		int screenHeight = toolkit.getScreenSize().height;
		if (height > screenHeight) {
			this.height = screenHeight;
		}
		else {
			this.height = height;
		}
		updateBounds();
	}
	
	public void setX(int x){
		this.x = x;
		updateBounds();
	}
	
	public void setY(int y){
		this.y = y;
		updateBounds();
	}
	
	public void updateBounds(){
		this.screenBounds = new Rectangle(x,y,width,height);
	}
	
	 public int getWidth(){
		 return this.width;
	 }
	 
	 public int getHeight(){
		 return this.height;
	 }
	 
	 public int getProperFrameRate(){
		 long area = width*height;
		 if (area > 1000000) return 1;
		 else if (area > 600000) return 2;
		 else if (area > 300000) return 4;
		 else if (area > 150000) return 8;
		 else return 10;
	 }
	 
	 private boolean areDimensionsScaled(int width, int height){
		int bigger = Math.max(width, height);
		if (bigger < 800){
			videoWidth = width;
			videoHeight = height;
			return false;
		}
		else{
			if (width >= height){
				 videoWidth = 800;
				 videoHeight = Math.round(height/(width/800));
			 } else if (height > width){
				 videoHeight = 800;
				 videoWidth = Math.round(width/(height/800));
			 }
			return true;
		}
	 }

	 private BufferedImage getScaledImage(BufferedImage image){
		 BufferedImage scaledImage = new BufferedImage(
				 videoWidth, videoHeight, BufferedImage.TYPE_3BYTE_BGR);

		 // Paint scaled version of image to new image
		 Graphics2D graphics2D = scaledImage.createGraphics();
		 graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
				 RenderingHints.VALUE_INTERPOLATION_BILINEAR);
		 graphics2D.drawImage(image, 0, 0, videoWidth, videoHeight, null);

		 // clean up

		 graphics2D.dispose();

		 return scaledImage;
	 }
	 
	 public int getVideoWidth(){
		 return videoWidth;
	 }
	 
	 public int getVideoHeight(){
		 return videoHeight;
	 }

}
