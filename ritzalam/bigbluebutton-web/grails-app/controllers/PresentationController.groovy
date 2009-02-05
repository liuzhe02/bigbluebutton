import org.jsecurity.authc.AuthenticationException
import org.jsecurity.authc.UsernamePasswordToken
import org.jsecurity.SecurityUtils
import org.jsecurity.session.Session
import org.jsecurity.subject.Subject
import org.springframework.util.FileCopyUtils

class PresentationController {
    PresentationService presentationService
    
    def index = { redirect(action:list,params:params) }
	static transactional = true
    
    def allowedMethods = []

    def list = {						      				
		def presentationsList = []
		flash.message = grailsApplication.config.images.location.toString()
		def f = new File( confDir() )
        [ presentationsList: presentationService.listPresentations(f)]
    }

    def delete = {		
		def filename = params.id.replace('###', '.')	
		def file = new File( confDir() + File.separatorChar + filename )
		presentationService.deletePresentation(file)
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
		def filename = params.id.replace('###', '.')
		InputStream is = null;
		System.out.println("showing ${filename}")
		try {
			def pres = presentationService.showPresentation(confDir() + File.separatorChar + filename)
			if (pres.exists()) {
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
	
	def confDir = {
    	Subject currentUser = SecurityUtils.getSubject() 
		Session session = currentUser.getSession()

	    def fname = session.getAttribute("fullname")
	    def rl = session.getAttribute("role")
	    def cnf = session.getAttribute("conference")
	    def rm = session.getAttribute("room")
		grailsApplication.config.images.location.toString() + File.separatorChar +
	      				cnf + File.separatorChar + rm
	}
}
