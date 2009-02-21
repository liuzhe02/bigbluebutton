
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
public class ParticipantsService extends ApplicationAdapter implements IApplication{

	protected static Logger log = LoggerFactory.getLogger( ParticipantsService.class );
	
	protected static Logger recorder = LoggerFactory.getLogger( "RECORD-BIGBLUEBUTTON" );
	
	private static final String PARTICIPANTS = "PARTICIPANTS";	
	private static final String PARTICIPANTS_SO = "participantsSO";   
	private static final String APP = "PARTICIPANTS";
	private ApplicationAdapter application;
	private RoomsManager roomsManager
	
	@Override
	public boolean appConnect(IConnection conn, Object[] params) {
		log.debug("${APP}:appConnect")
		return true
	}

	@Override
	public void appDisconnect(IConnection conn) {
		log.debug( "${APP}:appDisconnect")
	}

	@Override
	public boolean appJoin(IClient client, IScope scope) {
		log.debug( "${APP}:appJoin ${scope.name}")
		return true
	}

	@Override
	public void appLeave(IClient client, IScope scope) {
		log.debug("${APP}:appLeave ${scope.name}")

	}

	@Override
	public boolean appStart(IScope scope) {
		log.debug("${APP}:appStart ${scope.name}")
		return true;
	}

	@Override
	public void appStop(IScope scope) {
		log.debug("${APP}:appStop ${scope.name}")
	}

	@Override
	public boolean roomConnect(IConnection connection, Object[] params) {
		log.debug("${APP}:roomConnect")

    	return true;
	}

	@Override
	public void roomDisconnect(IConnection connection) {
		log.debug("${APP}:roomDisconnect")

	}

	@Override
	public boolean roomJoin(IClient client, IScope scope) {
		log.debug("${APP}:roomJoin ${scope.name} - ${scope.parent.name}")
		participantJoin();
		return true;
	}

	@Override
	public void roomLeave(IClient client, IScope scope) {
		log.debug("${APP}:roomLeave ${scope.name}")
		participantLeft()
	}

	@Override
	public boolean roomStart(IScope scope) {
		log.debug("${APP} - roomStart ${scope.name}")

    	// create ParticipantSO if it is not already created
    	if (!hasSharedObject(scope, PARTICIPANTS_SO)) {
    		createSharedObject(scope, PARTICIPANTS_SO, false)
    	}  	
    	return true;
	}

	@Override
	public void roomStop(IScope scope) {
		log.debug("${APP}:roomStop ${scope.name}")
		if (!hasSharedObject(scope, PARTICIPANTS_SO)) {
    		clearSharedObjects(scope, PARTICIPANTS_SO)
    	}
	}
	
	public Map getParticipants() {
		log.debug("${APP}:getParticipants")
		Room room = roomsManager.getRoom(Red5.connectionLocal.scope.name)
		
		Map participants = new HashMap()
		participants.put("count", room.numberOfParticipants)
		if (room.numberOfParticipants > 0) {
			/**
			 * Somehow we need to convert to Map so the client will be
			 * able to decode it. Need to figure out if we can send Participant
			 * directly. (ralam - 2/20/2009)
			 */
			Collection pc = room.participants.values()
    		Map pm = new HashMap()
    		for (Iterator it = pc.iterator(); it.hasNext();) {
    			Participant ap = (Participant) it.next();
    			pm.put(ap.userid, ap.toMap()); 
    		}  
			participants.put("participants", pm)
		}
		log.debug("${APP}:getParticipants " + participants.get("count"))
		return participants
	}
	
	public boolean assignPresenter(Integer userid, Integer assignedBy) {
		log.debug("Assigning presenter to ${userid} by ${assignedBy}")
	}
	
	public boolean participantLeft() {
		ISharedObject so = getSharedObject(Red5.connectionLocal.scope, PARTICIPANTS_SO, false)
		def userid = Red5.connectionLocal.client.id
		Room room = roomsManager.getRoom(Red5.connectionLocal.scope.name)
		room.removeParticipant(userid)
		
		List args = new ArrayList()
		args.add(userid)
		
		recorder.debug("${APP} - ParticipantLeftEvent - ${userid}")
		so.sendMessage("participantLeft", args)
		return true;
	}
	
	public boolean participantJoin() {
		ISharedObject so = getSharedObject(Red5.connectionLocal.scope, PARTICIPANTS_SO, false)
		def userid = Red5.connectionLocal.client.id;
		def username = Red5.connectionLocal.getAttribute("username")
		def role = Red5.connectionLocal.getAttribute("role")
/*		
		Map user = new HashMap()
		user.put("userid", userid)
		user.put("username", username)
		user.put("role", Red5.connectionLocal.getAttribute("role"))
*/

		Map status = new HashMap()
		status.put("raiseHand", false)
		status.put("presenter", true)
		status.put("hasStream", false)
//		user.put("status", status)
		
		Participant p = new Participant(userid, username, role, status)
		
		Room room = roomsManager.getRoom(Red5.connectionLocal.scope.name)
		room.addParticipant(p)
		
		log.debug("${APP}:participantJoin " + room.participants.size) 
		
		List args = new ArrayList()
		args.add(p.toMap())
		
		recorder.debug("${APP} - ParticipantJoinEvent - ${userid}")
		
		so.sendMessage("participantJoined", args)
		return true;
	}
	
	public void setApplicationAdapter(ApplicationAdapter a) {
		application = a
		application.addListener(this)
	}
	
	public void setRoomsManager(RoomsManager r) {
		roomsManager = r
	}
}
