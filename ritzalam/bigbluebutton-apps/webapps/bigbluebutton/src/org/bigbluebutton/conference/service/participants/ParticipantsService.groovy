
package org.bigbluebutton.conference.service.participants

import org.red5.server.adapter.IApplication
import org.red5.server.api.IClient
import org.red5.server.api.IConnection
import org.red5.server.api.IScope
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.red5.server.api.so.ISharedObject
import org.red5.server.adapter.ApplicationAdapter
import org.red5.server.api.Red5import java.util.Mapimport org.bigbluebutton.conference.RoomsManager
import org.bigbluebutton.conference.Roomimport org.bigbluebutton.conference.Participant
public class ParticipantsService {

	protected static Logger log = LoggerFactory.getLogger( ParticipantsService.class );	
	private ParticipantsApplication application

	public Map getParticipants() {
		String roomName = Red5.connectionLocal.scope.name
		log.debug("getting participants for ${roomName}")
		Map p = application.getParticipants(roomName)
		log.debug("${roomName} has " + p.get("count") + " participants")
		return p
	}
	
	public void setParticipantsApplication(ParticipantsApplication a) {
		log.debug("Setting ParticipantsApplications")
		application = a
	}
}
