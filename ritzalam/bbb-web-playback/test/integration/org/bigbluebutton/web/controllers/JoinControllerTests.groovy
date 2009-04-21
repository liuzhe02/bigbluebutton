package org.bigbluebutton.web.controllers

import org.bigbluebutton.web.controllers.JoinController
import org.bigbluebutton.web.domain.Conference
import org.bigbluebutton.web.domain.Schedule

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
		def conference = new Conference(username:"Test User", conferenceName:"test-conference", conferenceNumber: 85115)

		def schedule = new Schedule(
				scheduleName:'test-schedule',
				scheduleId:'test-schedule-id',
				lengthOfConference:3,
				numberOfAttendees:5,
				hostPassword: 'host-pass',
				attendeePassword: 'viewpass',
				scheduledBy:'test-user'
		)	
		conference.addToSchedules(schedule)
		conference*.save(flush:true)
		
		def sched = Schedule.findByScheduleId('test-schedule-id')
		println Schedule.list().size()
	 }
}
