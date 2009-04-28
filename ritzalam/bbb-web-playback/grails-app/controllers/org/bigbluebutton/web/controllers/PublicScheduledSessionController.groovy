package org.bigbluebutton.web.controllers

import org.bigbluebutton.web.domain.ScheduledSession
import grails.converters.*

class PublicScheduledSessionController {
	def index = {
	    redirect(action:show)
	}
	
	def show = {
		def tokenId = session['conference']
		def sessionId = session['room']
		
		if (!tokenId || !sessionId) {
			redirect(action:joinIn,id:tokenId)
		}
		
		def scheduledSessionInstance = ScheduledSession.findByTokenId( tokenId )

		if(!scheduledSessionInstance) {
			flash.message = "Could not find conference session."
	        redirect(action:joinIn)
	    }
	    else { 
	      	def hostUrl = grailsApplication.config.grails.serverURL
	       	def now = new Date().time
	       	
	       	def inSession = ((now > scheduledSessionInstance.startDateTime.time) && (now < scheduledSessionInstance.endDateTime.time))
	       	return [ scheduledSessionInstance : scheduledSessionInstance, hostUrl:hostUrl, inSession:inSession ] 
	    }
	}
	
	def joinIn = {
	    println "join $params.id"
	    return [ fullname: params.fullname, id:(params.id), password: params.password ]
	}
	
    def signIn = {    
		println 'signIn start'		
		def confSession = ScheduledSession.findByTokenId(params.id)
		def role = ''
		def signedIn = false
			
		if (confSession) {
			println 'signIn: has conference session'
			def long _10_minutes = 10*60*1000
			def now = new Date().time
							
			def startTime = confSession.startDateTime.time - _10_minutes
			def endTime = confSession.endDateTime.time + _10_minutes
			
			if ((startTime <= now) && (now <= endTime)) {
				
				println 'Found scheduled session'
				switch (params.password) {
					case confSession.hostPassword:
						println 'as host'
						role = "HOST"
						signedIn = true
						break
					case confSession.moderatorPassword:
						println 'as moderator'
						role = "MODERATOR"
						signedIn = true
						break
					case confSession.attendeePassword:
						println 'as viewer'
						role = "VIEWER"
						signedIn = true
						break
				}
				if (signedIn) {						
			    	println 'successful'
		   			session["fullname"] = params.fullname 
					session["role"] = role
					session["conference"] = params.id
					session["room"] = confSession.sessionId
					session["voicebridge"] = confSession.voiceConferenceBridge
					
			       	def fname = session["fullname"]
			       	def rl = session["role"]
			       	def cnf = session["conference"]
			       	def rm = session["room"]
			    	
			    	
			    	println 'rendering signIn'
			    	render(view:"signIn")			    	
				}
			}
		}
		
		if (!signedIn) {
			println 'failed'
			flash.message = "Failed to join the conference session."
			redirect(action:joinIn,id:params.id, params:[fullname:params.fullname])		
		}

	}
		
	def enter = {
	    def fname = session["fullname"]
	    def rl = session["role"]
	    def cnf = session["conference"]
	    def rm = session["room"]
		def vb = session["voicebridge"]   
	    
	    if (!rm) {
	    	withFormat {				
				xml {
					render(contentType:"text/xml") {
						'join'() {
							returnCode("FAILED")
							message("Could not find conference ${params.conference}.")
						}
					}
				}
			}
	    } else {	
	    	withFormat {				
				xml {
					render(contentType:"text/xml") {
						'join'() {
							returncode("SUCCESS")
							fullname("$fname")
	        				role("$rl")
	        				conference("$cnf")
	        				room("$rm")
	        				voicebridge("${vb}")
						}
					}
				}
			}
	    }    
	}

	def signOut = {
		// Log the user out of the application.
	    session.invalidate()

	    // For now, redirect back to the home page.
	    redirect(uri: '/')
	}
}
