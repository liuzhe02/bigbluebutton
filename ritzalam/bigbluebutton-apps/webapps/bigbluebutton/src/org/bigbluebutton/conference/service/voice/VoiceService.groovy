package org.bigbluebutton.conference.service.voice
import org.slf4j.Loggerimport org.slf4j.LoggerFactoryimport org.red5.server.api.Red5
public class VoiceService {
	
	protected static Logger log = LoggerFactory.getLogger( VoiceService.class );
	
	private VoiceApplication application
	private IVoiceServer voiceServer
		
	public void setVoiceApplication(VoiceApplication a) {
		log.debug("Setting Voice Applications")
		application = a
	}
	
	public void setIVoiceServer(IVoiceServer s) {
		log.debug("Setting voice server")
		voiceServer = s
		log.debug("Setting voice server DONE")
	}
}
