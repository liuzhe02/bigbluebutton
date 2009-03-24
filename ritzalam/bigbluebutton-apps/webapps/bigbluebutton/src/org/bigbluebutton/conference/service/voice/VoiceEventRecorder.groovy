
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
	
	def newChatMessage(def message){
		log.debug("New chat message...")
		so.sendMessage("newChatMessage", [message])
		
		Map event = new HashMap()
		event.put("date", new Date().time)
		event.put("application", name)
		event.put("event", "newChatMessage")
		event.put("message", message)
		recordEvent(event)
	}

}
