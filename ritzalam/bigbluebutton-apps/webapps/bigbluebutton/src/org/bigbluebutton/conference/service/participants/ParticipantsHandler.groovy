
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
import org.bigbluebutton.conference.Roomimport org.bigbluebutton.conference.Participantimport org.bigbluebutton.conference.RoomListener
public class ParticipantsHandler extends ApplicationAdapter implements IApplication{

	protected static Logger log = LoggerFactory.getLogger( ParticipantsHandler.class )
	protected static Logger recorder = LoggerFactory.getLogger( "RECORD-BIGBLUEBUTTON" )
	
	private static final String PARTICIPANTS = "PARTICIPANTS"
	private static final String PARTICIPANTS_SO = "participantsSO"   
	private static final String APP = "PARTICIPANTS"

	private ApplicationAdapter application
	private ParticipantsApplication participantsApplication

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
		participantsApplication.participantLeft(scope.name, Red5.connectionLocal.client.id)
	}

	@Override
	public boolean roomStart(IScope scope) {
		log.debug("${APP} - roomStart ${scope.name}")

    	// create ParticipantSO if it is not already created
    	if (!hasSharedObject(scope, PARTICIPANTS_SO)) {
    		if (createSharedObject(scope, PARTICIPANTS_SO, false)) {
    			ISharedObject so = getSharedObject(scope, PARTICIPANTS_SO)
    			log.debug("Starting room ${scope.name}")
    			return participantsApplication.addRoomListener(scope.name, new RoomListener(so))
    		}    		
    	}  	
		log.error("Failed to start room ${scope.name}")
    	return false;
	}

	@Override
	public void roomStop(IScope scope) {
		log.debug("${APP}:roomStop ${scope.name}")
		if (!hasSharedObject(scope, PARTICIPANTS_SO)) {
    		clearSharedObjects(scope, PARTICIPANTS_SO)
    	}
	}
	
	public boolean participantJoin() {
		log.debug("${APP}:participantJoin")
//		ISharedObject so = getSharedObject(Red5.connectionLocal.scope, PARTICIPANTS_SO, false)
		log.debug("${APP}:participantJoin - getting userid")
		def userid = Red5.connectionLocal.client.id
		log.debug("${APP}:participantJoin - getting username")
		def username = Red5.connectionLocal.getAttribute("username")
		log.debug("${APP}:participantJoin - getting role")
		def role = Red5.connectionLocal.getAttribute("role")

		log.debug("${APP}:participantJoin")
		Map status = new HashMap()
		status.put("raiseHand", false)
		status.put("presenter", false)
		status.put("hasStream", false)
		
		log.debug("${APP}:participantJoin setting status")		
		return participantsApplication.participantJoin(Red5.connectionLocal.scope.name, userid, username, role, status)
	}
	
	public void setApplicationAdapter(ApplicationAdapter a) {
		application = a
		application.addListener(this)
	}
	
	public void setParticipantsApplication(ParticipantsApplication a) {
		log.debug("Setting participants application")
		participantsApplication = a
	}
}
