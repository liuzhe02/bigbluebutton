
package org.bigbluebutton.conference.service.voice

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import net.jcip.annotations.ThreadSafeimport java.util.concurrent.ConcurrentHashMapimport java.util.concurrent.CopyOnWriteArrayListimport java.util.Collectionsimport java.util.Iterator
/**
 * Contains information about a Room. 
 */
@ThreadSafe
public class VoiceRoom {
	protected static Logger log = LoggerFactory.getLogger( VoiceRoom.class )
	
	private final String name
	private final Map<String, IVoiceRoomListener> listeners
	private final Map <Long, HashMap> participants
	
	public VoiceRoom(String name) {
		this.name = name
		listeners   = new ConcurrentHashMap<String, IVoiceRoomListener>()
		participants = new ConcurrentHashMap<Long, HashMap>()
	}
	
	public String getName() {
		return name
	}
	
	public void addRoomListener(IVoiceRoomListener listener) {
		if (! listeners.containsKey(listener.getName())) {
			log.debug("adding room listener")
			listeners.put(listener.getName(), listener)			
		}
	}
	
	public void removeRoomListener(IVoiceRoomListener listener) {
		log.debug("removing room listener")
		listeners.remove(listener)		
	}
	
	def joined(participant, name, muted, talking){
		Map p = new HashMap()
		p.put('participant', participant)
		p.put('name', name)
		p.put('muted', muted)
		p.put('talking', talking)
		participants.put(participant, p)
	}
	
	def left(participant){
		participants.remove(participant)
	}
	
	def mute(participant, mute){
		HashMap p = participants.get(participant)
		p.put('muted', mute)
	}
	

	def talk(participant, talk){
		HashMap p = participants.get(participant)
		p.put('talking', talk)
	}	
}
