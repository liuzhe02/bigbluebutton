/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2008 by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
* 
*/

package org.bigbluebutton.conference;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.bigbluebutton.conference.vo.Room;

import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IScope;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.so.ISharedObject;
import org.springframework.core.io.Resource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;


/**
 * This is the base class of conference server application. It overwrites the methods of ApplicationAdapter class.
 * This class plays main role in the conference room, handling and controlling conference participants list and assigning roles to the users of the conference rooms.
 * 
 * TO-DO
 * (1) Client conference room registration
 * (2)
 */

public class Application extends ApplicationAdapter implements
	IPendingServiceCallback {
	
	/** Logger log is used for logging conference server messages in log file. */
	protected static Logger log = LoggerFactory.getLogger( Application.class );

	/** The app scope. */
	private static IScope appScope;
	
	/** conferenceRooms Map : where details of all conference rooms are stored. */
	private Map<String, Room> conferenceRooms = new HashMap<String, Room>();
	
	/** The Constant PARTICIPANTS. */
	private static final String PARTICIPANTS = "PARTICIPANTS";
	
	/** The Constant PARTICIPANTS_SO. */
	private static final String PARTICIPANTS_SO = "participantsSO";
    
   
    @Override
    /** 
	   * This method is called once on scope start. overrides MultiThreadedApplicationAdapter.appStart(IScope).
	   * Calls Initialize() to do initialization tasks. Since this is the Application start handler method, 
	   * all the initialization tasks that the server application needs, have to go here.
	   *   
	   * @param app the Application scope
	   * @return true if Application can be started, or esle false
	   * 
	   * 
	   * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#appStart(org.red5.server.api.IScope)
	   */
    public boolean appStart (IScope app )
    {
        log.info( "Blindside.appStart" );
        appScope = app;
        
        return true;
    }
    
    
    /**
     * This method is automatically called when conference Server application is stopped.
     * Tasks that are needed to be executed before exiting the server, have to go here.
     */
    public void appStop ( )
    {
        log.info( "Blindside.appStop" );
    }

    /**
     * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#appConnect(org.red5.server.api.IConnection, java.lang.Object[])
     */
    public boolean appConnect( IConnection conn , Object[] params )
    {
        log.info( "Blindside.appConnect " + conn.getClient().getId() );
    	
        return true;
    }
    
    /**
     * This method is called to get the conference room details. Room name is given as a parameter.
     * When conference server starts details of all conference rooms, are stored in conferenceRooms HashMap.
     * 
     * @param room conference room name
     * 
     * @return Room object containing the conference room details
     */
    private Room getRoom(String room)
    {
    	if (! conferenceRooms.containsKey(room)) {
    		return null;
    	}
    	
    	return conferenceRooms.get(room);
    }



    /**
     * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#appDisconnect(org.red5.server.api.IConnection)
     */
    public void appDisconnect( IConnection conn)
    {
        log.info( "Blindside.appDisconnect " + conn.getClient().getId() );
    }
    
    /**
     * This method is called once on room scope start (when first client connects to the scope). overrides MultiThreadedApplicationAdapter.roomStart(IScope).
     * 
     * @param room the Room scope
     * 
     * @return true if Room can be started or esle false
     * 
     * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#roomStart(org.red5.server.api.IScope)
     */
    public boolean roomStart(IScope room) {
    	log.info( "Blindside.roomStart " );
    	if (!super.roomStart(room))
    		return false;
    	Room r = new Room(room.getName());
    	log.info( "Blindside.roomStart - " + room.getName() );
    	conferenceRooms.put(r.getRoom(), r);
    	return true;
    }
    
    public void roomStop(IScope room) {
    	log.info( "Blindside.roomStart " );
    	if (conferenceRooms.containsKey(room.getName())) {
    		conferenceRooms.remove(room.getName());
    	}
    }

    private void setUserId(IConnection conn)
    {
		IServiceCapableConnection service = (IServiceCapableConnection) conn;
		
		log.info("Setting userId and role [" + conn.getClient().getId() + "]");
		// remotely invoke client method with his/her role as on of the parameters
		service.invoke("setUserId", new Object[] { conn.getClient().getId()},
						this);
    }
    
    /**
     * This method is called every time new client connects to the application. NetConnection.connect() call from client side, call this function in server side.
     * It also takes parameters from the client. This method is a powerful handler method which allows developers to add tasks here that are needed to be executed every time a new client connects to the server.
     * 
     * 
     * In this method, client sends login ID to the server and server verifies it. It then assign user's role and send it to the client.
     * It also adds the client to the participants list in ParticipantSO
     * 
     * @param conn the connection between server and client
     * @param params parameter array passed from client
     * 
     * @return true
     */
    public boolean roomConnect(IConnection conn, Object[] params) {
    	log.info( "Blindside.roomConnect - " + conn.getClient().getId() );

        String username = ((String) params[0]).toString();
        String role = ((String) params[1]).toString();
        log.info("User logging [" + username + "," + role + "]" + conn.getScope().getName());
        // see if the room exists
        Room confRoom = getRoom(conn.getScope().getName());        
        if (confRoom == null) {
        	// room does not exist
        	log.info("Cannot find room[" + conn.getScope().getName() + "]");
        	// reject client with error message
        	rejectClient("Room not found.");
        	return true;
        }
      
        setUserId(conn); 
        
    	ISharedObject so = null;
    	// create ParticipantSO if it is not already created
    	if (!hasSharedObject(conn.getScope(), PARTICIPANTS_SO)) {
    		createSharedObject(conn.getScope(), PARTICIPANTS_SO, false);
    		so = getSharedObject(conn.getScope(), PARTICIPANTS_SO, false);
    	} else {        	
        	so = getSharedObject(conn.getScope(), PARTICIPANTS_SO, false);        	   		
    	}    	
    	
    	Participant newParticipant = new Participant(new Integer(conn.getClient().getId()), username, role);
    	// add new participant to the conference room
    	confRoom.addParticipant(newParticipant);
    	
    	ArrayList<Participant> participants = confRoom.getParticipants();
      	// add new participant to the sharedobject's attribute
    	// so that other clients can be notified about new client and update their
    	// participants list
    	so.beginUpdate();
    	so.setAttribute(newParticipant.userid.toString(), newParticipant);
    	
    	log.info("Blindside::roomConnect - Adding[" + newParticipant.userid + "," + participants.size() + "]");
    	so.endUpdate();
    	
    	return true;
    }
    
    /**
     * This method is called every time client leaves room scope. Developer can add tasks here that are needed to be executed when a client disconnects from the server.
     * Removes the client from the participants list (Stored in participantsSO SharedObject).
     * 
     * @param client conference client
     * @param room room scope
     * 
     * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#roomLeave(org.red5.server.api.IClient, org.red5.server.api.IScope)
     */
    public void roomLeave(IClient client, IScope room) {
    	super.roomLeave(client, room);
    	ISharedObject so = getSharedObject(room, PARTICIPANTS_SO, false);
    	
    	Room confRoom = getRoom(room.getName()); 
    	confRoom.removeParticipant(new Integer(client.getId()));

    	ArrayList<Participant> participants = confRoom.getParticipants();
      	
    	so.beginUpdate();
    	so.removeAttribute(client.getId());
    	log.info("Blindside::roomLeave - Removing[" + client.getId() + "," + participants.size() + "]");
    	so.endUpdate();
    
    }
    
    /**
     * This handler method is called every time client joins room scope.
     * 
     * @param client conference client
     * @param room Room scope
     * 
     * @return true, if room join
     */
    public boolean roomJoin(IClient client, IScope room) {
    	super.roomJoin(client, room);    	
    	
    	log.info("Blindside::roomJoin - " + client.getId());
  	
    	return true;
    }    
    
	/* (non-Javadoc)
	 * @see org.red5.server.api.service.IPendingServiceCallback#resultReceived(org.red5.server.api.service.IPendingServiceCall)
	 */
	public void resultReceived(IPendingServiceCall call) {
		log.info("Received result " + call.getResult() + " for "
				+ call.getServiceMethodName());		
	}     
}
