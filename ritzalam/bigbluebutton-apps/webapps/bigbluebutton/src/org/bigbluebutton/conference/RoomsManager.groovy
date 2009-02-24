package org.bigbluebutton.conference

public class RoomsManager {
	private Map <String, Room> rooms = new HashMap<String, Room>();
	
	public void addRoom(Room room) {
		rooms.put(room.name, room)
	}
	
	public void removeRoom(String name) {
		rooms.remove(name)
	}
	
	public Room getRoom(String name) {
		rooms.get(name)
	}
	
	public boolean hasRoom(String name) {
		return rooms.containsKey(name)
	}
	
	
}
