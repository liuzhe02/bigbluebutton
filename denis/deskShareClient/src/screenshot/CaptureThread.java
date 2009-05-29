package screenshot;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;

import javax.imageio.ImageIO;

public class CaptureThread implements Runnable {
	
	private static final int PORT = 1026;
	private static final String IP = "192.168.0.120";
	private static final int ROOM_NUMBER = 1234;
	
	private Socket socket = null;
	public Capture capture;
	private int roomNumber;
	
	public CaptureThread(Capture capture, int room){
		this.capture = capture;
		this.roomNumber = room;
	}
	
	public void run(){
		DataOutputStream outStream = null;
		try{
			socket = new Socket(IP, PORT);
			outStream = new DataOutputStream(socket.getOutputStream());
			outStream.writeInt(roomNumber);
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
				Thread.sleep(333);
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
