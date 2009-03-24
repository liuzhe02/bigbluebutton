
package org.bigbluebutton.conference.service.voice

import java.util.Map
import org.bigbluebutton.conference.service.archive.record.IEventRecorder
import org.bigbluebutton.conference.service.archive.record.IRecorderimport org.red5.server.api.so.ISharedObject
import org.bigbluebutton.conference.Participant
import org.slf4j.Logger
import org.slf4j.LoggerFactory

public class VoiceEventRecorder implements IEventRecorder, IVoiceRoomListener {
	protected static Logger log = LoggerFactory.getLogger( VoiceEventRecorder.class )
	
	IRecorder recorder
	private ISharedObject so
	def name = 'VOICE'
	
	def acceptRecorder(IRecorder recorder){
		log.debug("Accepting IRecorder")
		this.recorder = recorder
	}
	
	def getName() {
		return name
	}
	
	def recordEvent(Map event){
		recorder.recordEvent(event)
	}
	
	public VoiceEventRecorder(ISharedObject so) {
		this.so = so 
	}
	
	def joined(participant, name, muted, talking){
		log.debug("Participant $name joining")
		List <Object>args = new ArrayList<Object>()
		args.add(participant)
		args.add(name) // Just send the name to represent callerId number for now
		args.add(name)
		args.add(muted)
		args.add(talking)
			
		so.sendMessage("userJoin", args);
					
		Map event = new HashMap()
		event.put("date", new Date().time)
		event.put("application", name)
		event.put("event", "joined")
		event.put('participant', participant)
		event.put('name', name)
		event.put('muted', muted)
		event.put('talking', talking)
		recordEvent(event)		
	}
	
	def left(participant){
		log.debug("Participant $participant leaving")
		List <Object>args = new ArrayList<Object>()
		args.add(participant);
		
		so.sendMessage("userLeft", args);

		Map event = new HashMap()
		event.put("date", new Date().time)
		event.put("application", name)
		event.put("event", "left")
		event.put('participant', participant)
		recordEvent(event)	
	}
	
	def mute(participant, mute){
		log.debug("Participant $participant mute $mute")
		List <Object>args = new ArrayList<Object>()
		args.add(participant);
		args.add(mute);
		
		so.sendMessage("userMute", args);

		Map event = new HashMap()
		event.put("date", new Date().time)
		event.put("application", name)
		event.put("event", "mute")
		event.put('participant', participant)
		event.put('mute', mute)
		recordEvent(event)	
	}
	

	def talk(participant, talk){
		log.debug("Participant $participant mute $talk")
		List <Object>args = new ArrayList<Object>()
		args.add(participant);
		args.add(talk);
		
		so.sendMessage("userTalk", args);

		Map event = new HashMap()
		event.put("date", new Date().time)
		event.put("application", name)
		event.put("event", "mute")
		event.put('participant', participant)
		event.put('talk', talk)
		recordEvent(event)
	}
}
