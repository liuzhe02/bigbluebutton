
package org.bigbluebutton.conference.service.voice

import java.util.Map
import org.bigbluebutton.conference.service.archive.playback.IPlaybackNotifier
import org.red5.server.api.so.ISharedObjectimport org.slf4j.Logger
import org.slf4j.LoggerFactory

public class VoicePlaybackNotifier implements IPlaybackNotifier{
	protected static Logger log = LoggerFactory.getLogger( VoicePlaybackNotifier.class )
	
	private ISharedObject so
	def name = 'VOICE'
	
	public VoicePlaybackNotifier(ISharedObject so) {
		this.so = so
	}
	
	def sendMessage(Map event){
		log.debug("Playback chat message...")
		def message = event['message']
		so.sendMessage("newChatMessage", [message])
	}
	
	def notifierName(){
		return name
	}
}
