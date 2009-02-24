package org.bigbluebutton.conference

import org.slf4j.Logger
import org.slf4j.LoggerFactory

public class RoomsManager {
	protected static Logger log = LoggerFactory.getLogger( RoomsManager.class );
	
	private Map <String, Room> rooms = new HashMap<String, Room>();
	
	public void addRoom(Room room) {
		log.debug("In RoomsManager adding room ${room.name}")
		rooms.put(room.name, room)
	}
	
	public void removeRoom(String name) {
		log.debug("In RoomsManager remove room ${name}")
		rooms.remove(name)
	}
	
	public Room getRoom(String name) {
		log.debug("In RoomsManager get room ${name}")
		rooms.get(name)
	}
	
	public boolean hasRoom(String name) {
		log.debug("In RoomsManager has Room ${name}")
		return ((HashMap)rooms).containsKey(name)
	}
	
	
}
