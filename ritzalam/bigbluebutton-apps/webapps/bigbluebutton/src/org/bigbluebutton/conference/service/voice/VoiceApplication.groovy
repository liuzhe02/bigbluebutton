
package org.bigbluebutton.conference.service.voice


import org.slf4j.Logger
import org.slf4j.LoggerFactoryimport java.util.Mapimport org.bigbluebutton.conference.Participant
public class VoiceApplication {

	protected static Logger log = LoggerFactory.getLogger( VoiceApplication.class );	
		
	private static final String APP = "VOICE";
	private VoiceRoomsManager roomsManager
	
	public boolean createRoom(String name) {
		roomsManager.addRoom(new VoiceRoom(name))
		return true
	}
	
	public boolean destroyRoom(String name) {
		if (roomsManager.hasRoom(name)) {
			roomsManager.removeRoom(name)
		}
		return true
	}
	
	public boolean hasRoom(String name) {
		return roomsManager.hasRoom(name)
	}
	
	public boolean addRoomListener(String room, IVoiceRoomListener listener) {
		if (roomsManager.hasRoom(room)){
			roomsManager.addRoomListener(room, listener)
			return true
		}
		log.warn("Adding listener to a non-existant room ${room}")
		return false
	}
	
	def joined(room, participant, name, muted, talking){
		roomsManager.joined(room, participant, name, muted, talking)
	}
	

	def left(room, participant){
		roomsManager.left(room, participant)
	}
	

	def mute(participant, room, mute){
		roomsManager.mute(participant, room, mute)
	}
	

	def talk(participant, room, talk){
		roomsManager.talk(participant, room, talk)
	}
	
	public void setRoomsManager(VoiceRoomsManager r) {
		log.debug("Setting room manager")
		roomsManager = r
	}
}
