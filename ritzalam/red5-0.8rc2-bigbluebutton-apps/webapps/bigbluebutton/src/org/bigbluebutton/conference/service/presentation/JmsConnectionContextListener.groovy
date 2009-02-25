package org.bigbluebutton.conference.service.presentation

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class JmsConnectionContextListener implements ServletContextListener {

	protected static Logger logger = LoggerFactory.getLogger(JmsConnectionContextListener.class);
	
	public void contextInitialized(ServletContextEvent event) {
		
		WebApplicationContext ctx = 
			WebApplicationContextUtils.getRequiredWebApplicationContext(
				event.getServletContext());
		
		IConversionUpdatesService service = (IConversionUpdatesService) ctx.getBean("conversionUpdatesService");
		logger.info("Connecting to conversionUpdates service");
		service.start();
		logger.info("Connected to conversionUpdates service");
	}
	
	public void contextDestroyed(ServletContextEvent event) {
		WebApplicationContext ctx = 
			WebApplicationContextUtils.getRequiredWebApplicationContext(
				event.getServletContext());

		IConversionUpdatesService service = (IConversionUpdatesService) ctx.getBean("conversionUpdatesService");
		logger.info("Disconnecting from conversionUpdates service");
		service.stop();
		logger.info("Disconnected to conversionUpdates service");
	
	}	
}
