
package org.bigbluebutton.conference.service.voice

import org.slf4j.Logger
import org.slf4j.LoggerFactory

public class ConferenceServerListener implements IConferenceServerListener{
	protected static Logger log = LoggerFactory.getLogger( ConferenceServerListener.class )
	
	private VoiceApplication voiceApplication
	
	def joined(room, participant, name, muted, talking){
		voiceApplication.joined(room, participant, name, muted, talking)
	}
	

	def left(room, participant){
		voiceApplication.left(room, participant)
	}
	

	def mute(participant, room, mute){
		voiceApplication.mute(participant, room, mute)
	}
	

	def talk(participant, conference, talk){
		voiceApplication.talk(participant, room, talk)
	}
	
	def setVoiceApplication(VoiceApplication a) {
		voiceApplication = a
	}
}
