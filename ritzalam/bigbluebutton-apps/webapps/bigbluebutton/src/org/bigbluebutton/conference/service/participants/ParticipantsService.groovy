
package org.bigbluebutton.conference.service.participants

import org.red5.server.adapter.IApplication
import org.red5.server.api.IClient
import org.red5.server.api.IConnection
import org.red5.server.api.IScope
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.red5.server.api.so.ISharedObject
import org.red5.server.adapter.ApplicationAdapter
import org.red5.server.api.Red5import java.util.Map
public class ParticipantsService extends ApplicationAdapter implements IApplication{

	protected static Logger log = LoggerFactory.getLogger( ParticipantsService.class );

	private static final String PARTICIPANTS = "PARTICIPANTS";	
	private static final String PARTICIPANTS_SO = "participantsSO";   
	private static final String APP = "PARTICIPANTS";
	private ApplicationAdapter application;
		
	@Override
	public boolean appConnect(IConnection conn, Object[] params) {
		println "${APP}:appConnect"
		return true;
	}

	@Override
	public void appDisconnect(IConnection conn) {
		println "${APP}:appDisconnect"
	}

	@Override
	public boolean appJoin(IClient client, IScope scope) {
		println "${APP}:appJoin ${scope.name}"
		return true;
	}

	@Override
	public void appLeave(IClient client, IScope scope) {
		println "${APP}:appLeave ${scope.name}"

	}

	@Override
	public boolean appStart(IScope scope) {
		println "${APP}:appStart ${scope.name}"
		return true;
	}

	@Override
	public void appStop(IScope scope) {
		println "${APP}:appStop ${scope.name}"
	}

	@Override
	public boolean roomConnect(IConnection connection, Object[] params) {
		println "${APP}:roomConnect"

    	return true;
	}

	@Override
	public void roomDisconnect(IConnection connection) {
		println "${APP}:roomDisconnect"

	}

	@Override
	public boolean roomJoin(IClient client, IScope scope) {
		println "${APP}:roomJoin ${scope.name} - ${scope.parent.name}"
		println "${APP}: " + Red5.connectionLocal.getAttribute("conference")
		return true;
	}

	@Override
	public void roomLeave(IClient client, IScope scope) {
		println "${APP}:roomLeave ${scope.name}"

	}

	@Override
	public boolean roomStart(IScope scope) {
		println "${APP} - roomStart ${scope.name}"
    	log.info( "${APP} - roomStart ${scope.name}" )
		
    	// create ParticipantSO if it is not already created
    	if (!hasSharedObject(scope, PARTICIPANTS_SO)) {
    		createSharedObject(scope, PARTICIPANTS_SO, false)
    	}  	
    	return true;
	}

	@Override
	public void roomStop(IScope scope) {
		println "${APP}:roomStop ${scope.name}"
		if (!hasSharedObject(scope, PARTICIPANTS_SO)) {
    		clearSharedObjects(scope, PARTICIPANTS_SO)
    	}
	}

	public boolean participantJoin() {
		ISharedObject so = getSharedObject(Red5.connectionLocal.scope, PARTICIPANTS_SO, false)
		def userid = Red5.connectionLocal.client.id;
		def username = Red5.connectionLocal.getAttribute("username")
		List args = new ArrayList()
		args.add(userid)
		args.add(username)
		
		Map status = new HashMap()
		status.put("role",Red5.connectionLocal.getAttribute("role"))
		status.put("raiseHand", false)
		args.add(status)
		so.sendMessage("participantJoined", args)
		return true;
	}
	
	public void setApplicationAdapter(ApplicationAdapter a) {
		application = a
		application.addListener(this)
	}
}
