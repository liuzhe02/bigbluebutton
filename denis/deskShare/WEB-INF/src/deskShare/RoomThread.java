package deskShare;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.InputStream;
import java.net.Socket;
import java.util.ArrayList;

import javax.imageio.ImageIO;

/**
 * The RoomThread class is responsible for accepting client traffic relating to a particular room
 * @author Snap
 *
 */
public class RoomThread implements Runnable {
	
	private String roomNumber;
	private Socket socket;
	private boolean keepCapturing;
	private ArrayList<IImageListener> imageListeners;
	
	/**
	 * The default constructor
	 * @param roomNumber - the room number of the room this object is accepting images for
	 */
	public RoomThread(String roomNumber, Socket socket){
		this.roomNumber = roomNumber;
		this.socket = socket;
		this.keepCapturing = true;
		imageListeners = new ArrayList<IImageListener>();
	}
	
	/**
	 * The run method of this thread. Should not be called directly
	 */
	public void run(){
		while (keepCapturing){
			acceptImage();
		}
		notifyEndOfStream();
	}
	
	/**
	 * Notify all the listeners
	 */
	private void notifyEndOfStream() {
		for (IImageListener i : imageListeners) i.streamEnded();
		
	}
	
	/**
	 * Notifies all the listeners that a new image has been received and send the image to them
	 * @param image
	 */
	public void notifyListeners(BufferedImage image){
		for (IImageListener i : imageListeners) i.imageReceived(image);
	}
	
	/**
	 * Registers a listener to listen for received images
	 * @param imageListener
	 */
	public void registerListener(IImageListener imageListener){
		this.imageListeners.add(imageListener);
	}
	
	/**
	 * This method accepts an image from the network over a socket
	 * @param socket
	 */
	public void acceptImage(){
		if (socket.isClosed()){
			keepCapturing = false;
			return;
		}
		
		DataInputStream inStream = null;
		//2^16 is the maximum number of bytes sent over the network in one go. Need several times that
		byte[][] buffer = new byte[10][65536];
		//This is the array to which we will append the partial buffers
		byte[] appendedBuffer = new byte[10 * 65536];
		try{
			inStream = new DataInputStream(socket.getInputStream());
			long totalBytes = inStream.readLong();
			System.out.println("Receiving " + totalBytes + " bytes");
			if (totalBytes > 150000 || totalBytes < 0) return;
			
			int bytesRead = 0, index = 0, totalRead = 0;
			while(totalRead < totalBytes){
				//Read bytes sent from the socket
				bytesRead = inStream.read(buffer[index]);
				index++;
				totalRead += bytesRead;
				//System.out.println("Read bytes: " + bytesRead);
			}

			//Append the partial arrays to the big one
			for (index = 0; index<4; index++){
				for (int i = 0; i<buffer[index].length; i++){
					appendedBuffer[index*65536 + i] = buffer[index][i];
				}
			}

			System.out.println("Read bytes in total: " + totalRead);
			//Create a convenience InputStream from the big buffer we now have
			InputStream imageData = new ByteArrayInputStream(appendedBuffer);
			//re-Create a BufferedImage we received over the network 
			BufferedImage image = ImageIO.read(imageData);

			//Notify all the listening classes that a new image has been received
			if (image == null) return;
			notifyListeners(image);

		} catch(Exception e){
			e.printStackTrace(System.out);
			keepCapturing = false;
			return;
		}
	}
}
