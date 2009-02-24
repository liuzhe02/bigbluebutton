package org.bigbluebutton.conference.service.presentation

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.red5.server.api.so.ISharedObject;

public class ConversionUpdatesListener {
	protected static Logger log = LoggerFactory.getLogger(ConversionUpdatesListener.class);	
	private static Map<String, ISharedObject> presentationSOs = new HashMap<String, ISharedObject>();

	private static String APP = "PRESENTATION ";
	
    public void addRoom(String room, ISharedObject so) {
    	presentationSOs.put(room, so);
    }

    public void updateMessage(String room, String code, String message) {
    	if (! presentationSOs.containsKey(room)) {
    		log.info("${APP} - Getting updates message from unknown room [" + room + "]");
    		return;
    	}
    	
    	ISharedObject so = presentationSOs.get(room);
    	Map <String, Object> update = new HashMap<String, Object>();
    	// update the atribute space of the sharedobject and clients sync with it.
    	so.beginUpdate();
    	
    	if ("SUCCESS".equals(code)) {
    		update.put("returnCode", "SUCCESS");
        	update.put("message", message);
    	} else if ("UPDATE".equals(code)) {
    		update.put("returnCode", "UPDATE");
        	update.put("message", message);    		
    	} else {
    		update.put("returnCode", "FAILED");
        	update.put("message", message);
    	}
    	so.setAttribute("updateMessage", update);
    	so.endUpdate();
    }
    
    public void updateMessage(String room, String code, Integer totalSlides, Integer completedSlides) {
    	if (! presentationSOs.containsKey(room)) {
    		log.info("${APP} - Getting updates message from unknown room [" + room + "]");
    		return;
    	}
    	
    	log.info("${APP} - Getting updates message for room [" + room + "]");
    	System.out.println("${APP} - Getting updates message for room [" + room + "]");
    	
    	ISharedObject so = presentationSOs.get(room);
    	Map <String, Object> update = new HashMap<String, Object>();
    	// update the atribute space of the sharedobject and clients sync with it.
    	so.beginUpdate();
    	if ("EXTRACT".equals(code)) {
    		System.out.println("${APP} - " + room + " EXTRACT " + totalSlides + " " + completedSlides);
    		update.put("returnCode", "EXTRACT");
    		update.put("totalSlides", totalSlides);
    		update.put("completedSlides", completedSlides);
    	} else if ("CONVERT".equals(code)) {  
    		System.out.println("${APP} - " + room + " CONVERT " + totalSlides + " " + completedSlides);
    		update.put("returnCode", "CONVERT");
    		update.put("totalSlides", totalSlides);
    		update.put("completedSlides", completedSlides);
    	}
    	
    	so.setAttribute("updateMessage", update);
    	so.endUpdate();
    }    
	
	
}
