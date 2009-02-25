
package org.bigbluebutton.conference

import org.red5.server.adapter.IApplication
import org.red5.server.api.IClient
import org.red5.server.api.IConnection
import org.red5.server.api.IScope
import org.red5.server.api.service.IPendingServiceCallbackimport org.red5.server.api.service.IServiceCapableConnectionimport org.slf4j.Loggerimport org.slf4j.LoggerFactoryimport org.bigbluebutton.conference.Roomimport org.red5.server.api.service.IPendingServiceCallimport org.red5.server.api.so.ISharedObjectimport org.red5.server.adapter.ApplicationAdapter
public class ParticipantsService implements IApplication, IPendingServiceCallback {
	
	/** Logger log is used for logging conference server messages in log file. */
	protected static Logger log = LoggerFactory.getLogger( ParticipantsService.class );

	protected static Logger recorder = LoggerFactory.getLogger("bigbluebuttonrecorder");
	
	/** conferenceRooms Map : where details of all conference rooms are stored. */
	private Map<String, Room> conferenceRooms = new HashMap<String, Room>();
	
	private static final String PARTICIPANTS = "PARTICIPANTS";	
	private static final String PARTICIPANTS_SO = "participantsSO";   
	private static final String APP = "PARTICIPANTS ";
	private ApplicationAdapter application;
	
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


	
	@Override
	public boolean appConnect(IConnection conn, Object[] params) {
		println "${APP}:appConnect"
		return false;
	}

	@Override
	public void appDisconnect(IConnection conn) {
		println "${APP}:appDisconnect"
	}

	@Override
	public boolean appJoin(IClient client, IScope scope) {
		println "${APP}:appJoin ${scope.name}"
		return false;
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

    	log.info( "Blindside.roomConnect - " + conn.getClient().getId() );

        String username = ((String) params[0]).toString();
        String role = ((String) params[1]).toString();
        String conference = ((String) params[2]).toString();
        String mode = ((String) params[3]).toString();
        String room = conn.getScope().getName();
        
        if ("PLAYBACK".equals(mode)) {
        	room = ((String) params[4]).toString();
        }
		
        connection.setAttribute("conference", conference)
		
        log.info("User logging [" + username + "," + role + "]" + conn.getScope().getName());
        System.out.println(conference + " " + mode + " " + room);
        recorder.debug(APP + "ConferenceJoinEvent [" + username + "," + role + "]" + conn.getScope().getName());
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

	@Override
	public void roomDisconnect(IConnection connection) {
		println "${APP}:roomDisconnect"

	}

	@Override
	public boolean roomJoin(IClient client, IScope scope) {
		println "${APP}:roomJoin ${scope.name} - ${scope.parent.name}"
		println "${APP}: " + Red5.connectionLocal.getAttribute("conference")
		return false;
	}

	@Override
	public void roomLeave(IClient client, IScope scope) {
		println "${APP}:roomLeave ${scope.name}"
    	ISharedObject so = getSharedObject(room, PARTICIPANTS_SO, false);
    	
    	Room confRoom = getRoom(room.getName()); 
    	confRoom.removeParticipant(new Integer(client.getId()));

    	ArrayList<Participant> participants = confRoom.getParticipants();
      	
    	so.beginUpdate();
    	so.removeAttribute(client.getId());
    	log.info("Blindside::roomLeave - Removing[" + client.getId() + "," + participants.size() + "]");
    	so.endUpdate();
	}

	@Override
	public boolean roomStart(IScope scope) {
		println "Blindside.roomStart ${scope.name}"
    	log.info( "Blindside.roomStart ${scope.name}" );
    	Room r = new Room(room.getName());
    	log.info( "Blindside.roomStart - " + room.getName() );
    	conferenceRooms.put(r.getRoom(), r);
    	return true;
	}

	@Override
	public void roomStop(IScope scope) {
		println "${APP}:roomStop ${scope.name}"
    	log.info( "Blindside.roomStart " );
    	if (conferenceRooms.containsKey(room.getName())) {
    		conferenceRooms.remove(room.getName());
    	}
	}

	public void setApplicationAdapter(ApplicationAdapter a) {
		application = a;
		application.addListener(this);
	}
    
    private void setUserId(IConnection conn)
    {
		IServiceCapableConnection service = (IServiceCapableConnection) conn;
		
		log.info("Setting userId and role [" + conn.getClient().getId() + "]");
		// remotely invoke client method with his/her role as on of the parameters
		service.invoke("setUserId", conn.getClient().getId(), this);
    }
    
    
	/* (non-Javadoc)
	 * @see org.red5.server.api.service.IPendingServiceCallback#resultReceived(org.red5.server.api.service.IPendingServiceCall)
	 */
	public void resultReceived(IPendingServiceCall call) {
		log.info("Received result " + call.getResult() + " for "
				+ call.getServiceMethodName());		
	}     
	
}
