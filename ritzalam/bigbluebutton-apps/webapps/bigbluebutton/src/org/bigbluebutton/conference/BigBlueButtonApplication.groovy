package org.bigbluebutton.conference

import org.red5.server.api.Red5
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

	private static final String APP = "BigBlueButtonApplication";

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
    	return super.roomStart(room)
    }	
	
	public boolean roomConnect(IConnection connection, Object[] params) {
    	log.info( "${APP} - roomConnect - ")

        String username = ((String) params[0]).toString()
        String role = ((String) params[1]).toString()
        String conference = ((String) params[2]).toString()
        String mode = ((String) params[3]).toString()
        connection.setAttribute("conference", conference)
        connection.setAttribute("username", username)
        connection.setAttribute("role", role)
        connection.setAttribute("mode", mode)
        
        String room = "No room 'cause LIVE"                
        if ("PLAYBACK".equals(mode)) {
        	room = ((String) params[4]).toString()
        	connection.setAttribute("room", room)
        }
		log.info("${APP} - roomConnect - [${username},${role},${conference},${room}]") 

        super.roomConnect(connection, params)
    	return true;
	}

	public String getMyUserId() {
		return Red5.connectionLocal.client.id;
	}
}
