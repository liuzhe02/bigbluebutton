package screenshot;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;

import javax.imageio.ImageIO;

public class CaptureThread implements Runnable {
	
	private static final int PORT = 1026;
	//private static final String IP = "192.168.0.120";
	
	private Socket socket = null;
	public Capture capture;
	private String roomNumber;
	private String IP;
	
	public CaptureThread(Capture capture, String IP, String room){
		this.capture = capture;
		this.roomNumber = room;
		this.IP = IP;
	}
	
	public void run(){
		DataOutputStream outStream = null;
		try{
			socket = new Socket(IP, PORT);
			PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
			out.println(roomNumber);
			out.println(Integer.toString(capture.getWidth()) + "x" + Integer.toString(capture.getHeight()));
			outStream = new DataOutputStream(socket.getOutputStream());
		} catch(Exception e){
			e.printStackTrace(System.out);
			System.exit(0);
		}
		
		while (true){
			BufferedImage image = capture.takeSingleSnapshot();
			
			try{
				ByteArrayOutputStream byteConvert = new ByteArrayOutputStream();
				ImageIO.write(image, "jpeg", byteConvert);
				byte[] imageData = byteConvert.toByteArray();
				outStream.writeLong(imageData.length);
				outStream.write(imageData);
				System.out.println("Sent: "+ imageData.length);
			} catch(Exception e){
				e.printStackTrace(System.out);
				System.exit(0);
			}
			
			try{
				Thread.sleep(500);
			} catch (Exception e){
				System.exit(0);
			}
		}
	}
	
	public void closeConnection(){
		try{
			socket.close();
		} catch(IOException e){
			e.printStackTrace(System.out);
		}
	}
}
