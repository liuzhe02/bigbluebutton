package org.bigbluebutton.conference.service.presentation

import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MapMessage;
import org.apache.activemq.command.ActiveMQQueue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.core.JmsTemplate;

public class ConversionUpdatesService implements IConversionUpdatesService {
	protected static Logger logger = LoggerFactory.getLogger(ConversionUpdatesService.class);
	protected static Logger recorder = LoggerFactory.getLogger("RECORD-BIGBLUEBUTTON");
	
    private JmsTemplate template = null;    
    private Destination destination = null;    
    private volatile Thread updatesListenerThread;    
    private boolean waitForMessage = true;
    private ConversionUpdatesListener updatesListener;
    
    private static String APP = "PRESENTATION ";
    
	public void start() {
		
		Thread.start {
	        logger.info("${APP} - Will wait for document conversion updates messages.");
	        
	        while (waitForMessage) {
	        	Message jmsMessage = template.receive(destination);
	        	
	        	System.out.println("${APP} - Got JMS message.");
	        	
	        	if (jmsMessage instanceof MapMessage) {
	                try {
	                	MapMessage mapMessage = ((MapMessage) jmsMessage);
						String room = mapMessage.getString("room");
						String code = mapMessage.getString("returnCode");

						if ("SUCCESS".equals(code)) {
							String message = mapMessage.getStringProperty("message");
							recorder.debug(APP + "PresentationUploadEvent room=" + room + " code=" + code + " message=" + message);
							updatesListener.updateMessage(room, code, message);
						} else if ("EXTRACT".equals(code) || "CONVERT".equals(code)) {
							System.out.println("${APP} - totalSlide = " + mapMessage.getString("totalSlides"));
							int totalSlides = mapMessage.getInt("totalSlides");
							int completedSlides = mapMessage.getInt("slidesCompleted");
							recorder.debug(APP + "PresentationUploadEvent room=" + room + " code=" + code + 
									" totalSlides=" + totalSlides + " completedSlides=" + completedSlides);
							updatesListener.updateMessage(room, code, totalSlides, completedSlides);
						} else {
							logger.error("Cannot handle recieved message.");
						}
			        	System.out.println("${APP} - Room = [" + room + "," + code + "]");	                    
			        	logger.debug(mapMessage.toString());
	                }
	                catch (JMSException ex) {
	                    throw new RuntimeException(ex);
	                }
	            }
	        }
		}
	}

	public void stop() {
		waitForMessage = false;
	}

	public void setDestination(ActiveMQQueue destination) {
		this.destination = (Destination) destination;
	}

	public void setJmsTemplate(JmsTemplate jmsTemplate) {
		this.template = jmsTemplate;
	}
	
	public void setUpdatesListener(ConversionUpdatesListener updatesListener) {
		this.updatesListener = updatesListener;
	}	
}
