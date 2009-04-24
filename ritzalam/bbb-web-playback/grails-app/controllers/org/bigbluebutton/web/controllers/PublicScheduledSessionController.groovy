package org.bigbluebutton.web.controllers

import org.bigbluebutton.web.domain.ScheduledSession
import grails.converters.*

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
	       	return [ scheduledSessionInstance : scheduledSessionInstance, hostUrl:hostUrl, expired:expired ] 
	    }
	}
	
	def joinIn = {
	    println "join $params.id"
	    return [ fullname: params.fullname, id: (params.id), password: params.password ]
	}
	
    def signIn = {    
		println 'signIn start'
		def fullname = params.fullname		
		def confSession = ScheduledSession.findByTokenId(params.id)
		def schedule = null
		def role = ''
			
		if (!confSession) {
			println 'signIn: no conference session'
			withFormat {				
				xml {
					render(contentType:"text/xml") {
						'join'() {
							returnCode("FAILED")
						}
					}
				}
			}
		} else {
			println 'signIn: has conference session'
			def long _10_minutes = 10*60*1000
			def now = new Date().time
							
			def startTime = confSession.startDateTime.time - _10_minutes
			def endTime = confSession.endDateTime.time + _10_minutes
			
			if ((startTime <= now) && (now <= endTime)) {
				def signedIn = false
				println 'Found scheduled session'
				switch (params.password) {
					case confSession.hostPassword:
						role = "HOST"
						signedIn = true
						break
					case confSession.moderatorPassword:
						role = "MODERATOR"
						signedIn = true
						break
					case confSession.attendeePassword:
						role = "VIEWER"
						signedIn = true
						break
				}
				
			    if (!signedIn) {
			    	println 'Wrong password'
			   // 	withFormat {				
				//		xml {
							render(contentType:"text/xml") {
								'join'() {
									returnCode("FAILED")
								}
							}
				//		}
				//	}
			    } else {
			    	println 'successful'
		   			session["fullname"] = params.fullname 
					session["role"] = role
					session["conference"] = params.conference
					session["room"] = schedule.scheduleId
			        	
			       	def fname = session["fullname"]
			       	def rl = session["role"]
			       	def cnf = session["conference"]
			       	def rm = session["room"]
			        
		   			signInPassed()
			       	
			   }									
			} else {
				signInFailed()
			}
		}   
	}
	
	def signInFailed = {
		withFormat {				
			xml {
				render(contentType:"text/xml") {
					'join'() {
						returnCode("FAILED")
					}
				}
			}
		}			
	}
	
	def signInPassed = {
		withFormat {				
	    	xml {
	    		render(contentType:"text/xml") {
	    			'join'() {
	       				returncode("SUCCESS")
	       			}
	       		}
	       	}
		}	
	}
	
	def enter = {
	    def fname = session["fullname"]
	    def rl = session["role"]
	    def cnf = session["conference"]
	    def rm = session["room"]
		        	
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
							returnCode("SUCCESS")
							fullname("$fname")
	        				role("$rl")
	        				conference("$cnf")
	        				room("$rm")
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
