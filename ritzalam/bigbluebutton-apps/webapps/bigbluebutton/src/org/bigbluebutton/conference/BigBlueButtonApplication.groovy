package org.bigbluebutton.conference

import org.red5.server.api.Red5import org.bigbluebutton.conference.service.participants.ParticipantsApplicationimport org.bigbluebutton.conference.service.archive.ArchiveApplication
import org.red5.server.adapter.ApplicationAdapter
import org.red5.server.adapter.IApplication
import org.red5.server.api.IClient
import org.red5.server.api.IConnection
import org.red5.server.api.IScope
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.red5.server.api.so.ISharedObject

public class BigBlueButtonApplication extends ApplicationAdapter{

	protected static Logger log = LoggerFactory.getLogger( BigBlueButtonApplication.class );

	private static final String APP = "BigBlueButtonApplication"
	private ParticipantsApplication participantsApplication
	private ArchiveApplication archiveApplication
	
    public boolean appStart (IScope app )
    {
        log.info( "${APP} - appStart" )
        return super.appStart(app)
    }
        
    public void appStop (IScope app )
    {
        log.info( "${APP} - appStop" )
        super.appStop(app)
    }

    public boolean appConnect( IConnection conn , Object[] params )
    {
        log.info( "${APP} - appConnect ")
    	
        return super.appConnect(conn, params)
    }
    
    public void appDisconnect( IConnection conn)
    {
        log.info( "${APP} - appDisconnect ")
        super.appDisconnect(conn)
    }
    
    public boolean roomStart(IScope room) {
    	log.info( "${APP} - roomStart " )
//    	assert participantsApplication != null
    	participantsApplication.createRoom(room.name)
    	return super.roomStart(room)
    }	
	
    public void roomStop(IScope room) {
    	log.info( "${APP} - roomStop " )
    	super.roomStop(room)
//    	assert participantsApplication != null
    	participantsApplication.destroyRoom(room.name)
    }
    
	public boolean roomConnect(IConnection connection, Object[] params) {
    	log.info( "${APP} - roomConnect - ")

        String username = ((String) params[0]).toString()
        String role = ((String) params[1]).toString()
        String conference = ((String) params[2]).toString()
        String mode = ((String) params[3]).toString()
        def userid = Red5.connectionLocal.client.id
        def sessionName = connection.scope.name
        
        def room                
        if (Constants.PLAYBACK_MODE.equals(mode)) {
        	room = ((String) params[4]).toString()   
//        	assert archiveApplication != null
        	archiveApplication.createPlaybackSession(sessionName)
        } else {
        	room = sessionName
//        	assert archiveApplication != null
        	archiveApplication.createRecordSession(sessionName)
        }
    	
    	BigBlueButtonSession bbbSession = new BigBlueButtonSession(sessionName, userid,  username, role, conference, mode, room)
        connection.setAttribute(Constants.SESSION, bbbSession)        
		log.info("${APP} - roomConnect - [${username},${role},${conference},${room}]") 

        super.roomConnect(connection, params)
    	return true;
	}

	public String getMyUserId() {
		log.debug("Getting userid for connection.")
		BigBlueButtonSession bbbSession = Red5.connectionLocal.getAttribute(Constants.SESSION)
		assert bbbSession != null
		return bbbSession.userid;
	}
	
	public void setParticipantsApplication(ParticipantsApplication a) {
		log.debug("Setting participants application")
		participantsApplication = a
	}
	
	public void setArchiveApplication(ArchiveApplication a) {
		log.debug("Setting archive application")
		archiveApplication = a
	}
	
	public void setApplicationListeners(Set listeners) {
		log.debug("Setting application listeners")
		def count = 0
		Iterator iter = listeners.iterator()
		while (iter.hasNext()) {
			log.debug("Setting application listeners $count")
			super.addListener((IApplication) iter.next())
			count++
		}
		log.debug("Finished Setting application listeners")
	}
}
