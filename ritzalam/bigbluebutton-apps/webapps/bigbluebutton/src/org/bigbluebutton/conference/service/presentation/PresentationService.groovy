package org.bigbluebutton.conference.service.presentation

import org.red5.server.api.so.ISharedObject
import org.red5.server.adapter.ApplicationAdapter
import org.red5.server.adapter.IApplication
import org.red5.server.api.IClient
import org.red5.server.api.IConnection
import org.red5.server.api.IScope
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.red5.server.api.Red5
import org.bigbluebutton.conference.Participantimport org.bigbluebutton.conference.service.participants.ParticipantsApplication
import org.bigbluebutton.conference.RoomsManagerimport org.bigbluebutton.conference.service.presentation.ConversionUpdatesListener

public class PresentationService extends ApplicationAdapter implements IApplication {
	protected static Logger log = LoggerFactory.getLogger( PresentationService.class )	
	protected static Logger recorder = LoggerFactory.getLogger( "RECORD-BIGBLUEBUTTON" )
	
	private ConversionUpdatesListener updatesListener
	
	private static final String PRESENTATION = "PRESENTATION";	
	private static final String PRESENTATION_SO = "presentationSO";   
	private static final String APP = "PRESENTATION";
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
		log.debug("${APP}:appStart")
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
		return true;
	}

	@Override
	public void roomLeave(IClient client, IScope scope) {
		log.debug("${APP}:roomLeave ${scope.name}")
	}

	@Override
	public boolean roomStart(IScope scope) {
		log.debug("${APP} - roomStart ${scope.name}")

    	// create PRESENTATION_SO if it is not already created
    	if (!hasSharedObject(scope, PRESENTATION_SO)) {
    		log.debug("${APP} - roomStart ${scope.name} - creating shared object.")
    		createSharedObject(scope, PRESENTATION_SO, false)
    		log.debug("${APP} - roomStart ${scope.name} - getting shared object.")
    		ISharedObject so = getSharedObject(scope, PRESENTATION_SO, false)
    		log.debug("${APP} - roomStart ${scope.name} - adding room listener.")
    		updatesListener.addRoom(scope.name, so)
    		log.debug("${APP} - roomStart ${scope.name} - room listener added.")
    	}  	
		log.debug("${APP} - roomStart ${scope.name} - room started.")
    	return true;
	}

	@Override
	public void roomStop(IScope scope) {
		log.debug("${APP}:roomStop ${scope.name}")
		if (!hasSharedObject(scope, PRESENTATION_SO)) {
    		clearSharedObjects(scope, PRESENTATION_SO)
    	}
	}

	public void assignPresenter(String userid, String name, String assignedBy) {
		IScope scope = Red5.connectionLocal.scope
		def presenter = [userid, name, assignedBy]
		scope.setAttribute("presenter", presenter)
		participantsApplication.setParticipantStatus(scope.name, userid.toLong(), "presenter", true)
		ISharedObject so = getSharedObject(scope, PRESENTATION_SO, false)
		so.sendMessage("assignPresenterCallback", presenter)
	}
	
	
	public void setApplicationAdapter(ApplicationAdapter a) {
		log.debug("Setting application adapter.")
		application = a
		application.addListener(this)
	}
	
	public void setParticipantsApplication(ParticipantsApplication a) {
		log.debug("Setting participants application")
		participantsApplication = a
	}
	
	public void setUpdatesListener(ConversionUpdatesListener updatesListener) {
		log.debug("Setting updates listener")
		this.updatesListener = updatesListener;
	}
}
