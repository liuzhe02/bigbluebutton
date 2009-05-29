package deskShare;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;

import javax.imageio.ImageIO;

import org.red5.server.api.IScope;

/**
 * The ClientProxy receives images from the client which captures the screen
 * @author Snap
 *
 */
public class ClientProxy implements Runnable {
	
	private ServerSocket serverSocket;
	private boolean keepCapturing = true;
	
	private ArrayList<RoomThread> roomList;
	
	//Temporary scope assignment. Change later so that each room has own scope
	private IScope scope;
	
	/**
	 * The default constructor
	 */
	public ClientProxy(IScope scope){
		roomList = new ArrayList<RoomThread>();
		this.scope = scope;
		try{
			serverSocket = new ServerSocket(DeskShareConstants.PORT);
		} catch(IOException e){
			System.out.println(e.getMessage());
			e.printStackTrace(System.out);
		}
	}
	
	/**
	 * The run method for this thread. Should not be called directly
	 */
	public void run(){
		while(keepCapturing){
			try{
				acceptRoomConnection(serverSocket.accept());
			} catch(IOException e){
				System.out.println(e.getMessage());
				e.printStackTrace(System.out);
			}
		}
	}

	/**
	 * Stops this application from receiving images from the client
	 */
	public void stopCapture(){
		keepCapturing = false;
	}
	
	private void acceptRoomConnection(Socket socket){
		try{
			DataInputStream inStream = new DataInputStream(socket.getInputStream());
			int roomNum = inStream.readInt();
			RoomThread room = new RoomThread(roomNum, socket);
			Red5Streamer streamPublisher = new Red5Streamer(scope, Integer.toString(roomNum));
			room.registerListener(streamPublisher);
			roomList.add(room);
			Thread thread = new Thread(room);
			thread.start();
		} catch(IOException e){
			e.printStackTrace(System.out);
		}
		
	}
	
}
