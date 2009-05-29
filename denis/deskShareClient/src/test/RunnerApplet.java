package test;
import javax.swing.JApplet;

import screenshot.Capture;
import screenshot.CaptureThread;

public class RunnerApplet extends JApplet {
	
	CaptureThread capThread;
	
	public void init(){
		Capture capture = new Capture();
		int roomNumber = Integer.parseInt(getParameter("ROOM"));
		capThread = new CaptureThread(capture, roomNumber);
	}
	
	public void stop(){
		
	}
	
	public void start(){
		Thread thread = new Thread(capThread);
		thread.start();
	}
	
	/**
	 * This method is called when the user closes the browser window containing the applet
	 */
	public void destroy(){
		capThread.closeConnection();
	}
	
	public void setScreenCoordinates(int x, int y){
		capThread.capture.setX(x);
		capThread.capture.setY(y);
	}
}
