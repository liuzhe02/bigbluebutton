package org.bigbluebutton.web.controllers

import org.bigbluebutton.web.domain.ScheduledSession

class PublicScheduledSessionController {

	def show = {
	        def scheduledSessionInstance = ScheduledSession.get( params.id )

	        if(!scheduledSessionInstance) {
	            flash.message = "ScheduledSession not found with id ${params.id}"
	            redirect(action:list)
	        }
	        else { 
	        	def hostUrl = grailsApplication.config.grails.serverURL
	        	def now = new Date().time
	        	
	        	def expired = ((now > scheduledSessionInstance.startDateTime.time) && (now < scheduledSessionInstance.endDateTime.time))
	        	println "$scheduledSessionInstance.startDateTime.time $now $scheduledSessionInstance.endDateTime.time $expired"
	        	return [ scheduledSessionInstance : scheduledSessionInstance, hostUrl:hostUrl, expired:expired ] 
	        }
	    }
}
