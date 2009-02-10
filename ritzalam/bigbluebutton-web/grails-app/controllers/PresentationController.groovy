import org.jsecurity.authc.AuthenticationException
import org.jsecurity.authc.UsernamePasswordToken
import org.jsecurity.SecurityUtils
import org.jsecurity.session.Session
import org.jsecurity.subject.Subject
import org.springframework.util.FileCopyUtils

import grails.converters.*

class PresentationController {
    PresentationService presentationService
    
    def index = { redirect(action:list,params:params) }
	static transactional = true
    
    def allowedMethods = []

    def list = {						      				
		def f = confInfo()
		println "conference info ${f.conference} ${f.room}"
		def presentationsList = presentationService.listPresentations(f.conference, f.room)

		if (presentationsList) {
			withFormat {				
				xml {
					render(contentType:"text/xml") {
						conference(id:f.conference, room:f.room) {
							presentations {
								for (s in presentationsList) {
									presentation(name:s)
								}
							}
						}
					}
				}
			}
		} else {
			render(view:'upload')
		}
    }

    def delete = {		
		def filename = params.presentation_name
		def f = confInfo()
		presentationService.deletePresentation(f.conference, f.room, filename)
		flash.message = "file ${filename} removed" 
		redirect( action:list )
    }

	def upload = {		
		def f = request.getFile('fileUpload')
	    if(!f.empty) {
	      flash.message = 'Your file has been uploaded'
	      def dstDir = confDir() + File.separatorChar + params.presentationName
		  presentationService.processUploadedPresentation(dstDir, f)								             			     	
		}    
	    else {
	       flash.message = 'file cannot be empty'
	    }
		redirect( action:list)
	}
	
	def show = {
		//def filename = params.id.replace('###', '.')
		def filename = params.presentation_name
		InputStream is = null;
		System.out.println("showing ${filename}")
		try {
			def pres = presentationService.showPresentation(confDir() + File.separatorChar + filename)
			if (pres.exists()) {
				System.out.println("Found ${filename}")
				def bytes = pres.readBytes()

				response.contentType = 'application/x-shockwave-flash'
				response.outputStream << bytes;
			}	
		} catch (IOException e) {
			System.out.println("Error reading file.\n" + e.getMessage());
		}
		
		return null;
	}
	
	def thumbnail = {
		def filename = params.id.replace('###', '.')
		System.out.println("showing ${filename} ${params.thumb}")
		def presDir = confDir() + File.separatorChar + filename
		try {
			def pres = presentationService.showThumbnail(presDir, params.thumb)
			if (pres.exists()) {
				def bytes = pres.readBytes()

				response.contentType = 'image'
				response.outputStream << bytes;
			}	
		} catch (IOException e) {
			System.out.println("Error reading file.\n" + e.getMessage());
		}
		
		return null;
	}
	
	def thumbnails = {
		def filename = params.id.replace('###', '.')
		return [presSlides:filename, numThumbs:presentationService.numberOfThumbnails(confDir() + File.separatorChar + filename)]
	}
	
	def confInfo = {
    	Subject currentUser = SecurityUtils.getSubject() 
		Session session = currentUser.getSession()

	    def fname = session.getAttribute("fullname")
	    def rl = session.getAttribute("role")
	    def conf = session.getAttribute("conference")
	    def rm = session.getAttribute("room")
		return [conference:conf, room:rm]
	}
}
