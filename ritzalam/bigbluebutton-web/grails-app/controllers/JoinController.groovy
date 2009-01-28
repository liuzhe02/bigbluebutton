import org.jsecurity.authc.AuthenticationException
import org.jsecurity.authc.UsernamePasswordToken
import org.jsecurity.SecurityUtils
import org.jsecurity.session.Session
import org.jsecurity.subject.Subject

class JoinController {
 
    def index = { redirect(action: 'login', params: params) }

    def login = {
        return [ fullname: params.fullname, conference: (params.conference), password: params.password ]
    }

    def signIn = {    
		def fullname = params.fullname		
		def conference = Conference.findByConferenceNumber(params.conference)
		def schedule = null
		def role = ''
		
		if (!conference) {
	        def returnString = """
				  	<join>
						<returncode>FAILED</returncode>
						<message>Could not find conference ${params.conference}.</message>
					</join> """
	        render(text:"${returnString}",contentType:"text/xml",encoding:"UTF-8")
		} else {
			def long _10_minutes = 10*60*1000
			def now = new Date().time
						
			conference.schedules.each {
				def startTime = it.startDateTime.time - _10_minutes
				def endTime = it.startDateTime.time + _10_minutes + (it.lengthOfConference * 60 * 60 * 1000) // length * min * sec * ms
				
				if ((startTime <= now) && (now <= endTime)) {
					if (it.hostPassword == params.password) {
						role = "MODERATOR"
						schedule = it
					} else if (it.attendeePassword == params.password) {
						role = "VIEWER"
						schedule = it
					} 						
				}
			}
			
	        if (!schedule) {
	        	def returnString = """
				  	<join>
						<returncode>FAILED</returncode>
						<message>Either you typed the wrong password or you are early. Please
						try 10 minutes before the scheduled conference.
						</message>
					</join> """
	        	render(text:"${returnString}",contentType:"text/xml",encoding:"UTF-8")
	        } else {
	        	def returnString = """
				  	<join>
						<returncode>SUCCESS</returncode>
						<name>${schedule.scheduleName}</name>
						<fullname>${params.fullname}</fullname>
						<role>${role}</role>
						<conference>${params.conference}</conference>
						<room>${schedule.scheduleId}</room>
					</join> """
	        	render(text:"${returnString}",contentType:"text/xml",encoding:"UTF-8")
	        }
		}   
    

    }

    def signOut = {
        // Log the user out of the application.
        SecurityUtils.subject?.logout()

        // For now, redirect back to the home page.
        redirect(uri: '/')
    }

    def unauthorized = {
        render 'You do not have permission to access this page.'
    }
}
