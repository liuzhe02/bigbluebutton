package org.bigbluebutton.web.controllers

import org.bigbluebutton.web.controllers.JoinController
import org.bigbluebutton.web.domain.Conference
import org.bigbluebutton.web.domain.Schedule
import org.jsecurity.crypto.hash.Sha1Hash
import org.bigbluebutton.web.domain.User

class JoinControllerTests extends GroovyTestCase {
	
	 void testIndex() { 
		 def jc = new JoinController() 
		 jc.index()
		 assertEquals "/join/login", jc.response.redirectedUrl
	 }

	 void testSignIn() {
		 def controller = new JoinController()
		 controller.params.fullname = "Richard"
		 controller.params.password = "secret"
		 controller.params.conference = 85115
		 controller.signIn()
		 def result = new XmlSlurper().parseText(controller.response.contentAsString)
		 assertEquals 'FAILED', result.returnCode.toString()
	} 
	 
	 void testJoinSuccess() {
		 def adminUser = new User(username: "admin", passwordHash: new Sha1Hash("admin").toHex(),
					email: "admin@test.com", fullName: "Admin").save()
			assertEquals 1, User.list().size()
			
	    	def conference = new Conference()
	    	conference.username = "Test User" 
	    	conference.conferenceName = "test-conference"
	    	conference.conferenceNumber = new Integer(85115)
	    	conference.user = adminUser
	    	
			try {
				conference*.save(flush:true)
			} catch (Exception e) {
				println e.toString()
			}
			
			assertEquals 1, Conference.list().size()
				
		def schedule = new Schedule(
				scheduleName:'test-schedule',
				scheduleId:'test-schedule-id',
				lengthOfConference:3,
				numberOfAttendees:5,
				hostPassword: 'modpass',
				attendeePassword: 'viewpass',
				scheduledBy:'test-user'
		)	
		conference.addToSchedules(schedule)
		conference*.save(flush:true)
		
		def conf = Conference.findAllByConferenceName('test-conference')
		println conf.username
		def sched = Schedule.findAllByScheduleId('test-schedule-id')
		assertEquals 1, Schedule.list().size()
		assertEquals 'test-schedule', sched[0].scheduleName
		
		def controller = new JoinController()
		controller.params.fullname = "Richard"
		controller.params.password = "modpass"
		controller.params.conference = 85115
		controller.signIn()
		def result = new XmlSlurper().parseText(controller.response.contentAsString)
		assertEquals 'Richard', result.participantname.toString() 
	 }
}
