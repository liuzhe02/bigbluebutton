
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
		
		Map participants = new HashMap()
		if (p == null) {
			participants.put("count", 0)
		} else {		
			participants.put("count", p.size())
			if (p.size() > 0) {
				/**
				 * Somehow we need to convert to Map so the client will be
				 * able to decode it. Need to figure out if we can send Participant
				 * directly. (ralam - 2/20/2009)
				 */
				Collection pc = p.values()
	    		Map pm = new HashMap()
	    		for (Iterator it = pc.iterator(); it.hasNext();) {
	    			Participant ap = (Participant) it.next();
	    			pm.put(ap.userid, ap.toMap()); 
	    		}  
				participants.put("participants", pm)
			}
			return participants
		}
	}
	
	public void setParticipantsApplication(ParticipantsApplication a) {
		log.debug("Setting Participants Applications")
		application = a
	}
}
