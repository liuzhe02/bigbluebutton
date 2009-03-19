package org.bigbluebutton.conference.service.presentation
import org.slf4j.Loggerimport org.slf4j.LoggerFactoryimport org.red5.server.api.Red5
import org.red5.server.api.IScopeimport org.bigbluebutton.conference.service.participants.ParticipantsApplication

public class PresentationService {
	
	protected static Logger log = LoggerFactory.getLogger( PresentationService.class );
	
	private ParticipantsApplication participantsApplication
	private PresentationApplication presentationApplication

	public void assignPresenter(String userid, String name, String assignedBy) {
		log.debug("assignPresenter $userid $name $assignedBy")
		IScope scope = Red5.connectionLocal.scope
		def presenter = [userid, name, assignedBy]
		def curPresenter = presentationApplication.getCurrentPresenter(scope.name)
		participantsApplication.setParticipantStatus(scope.name, userid.toLong(), "presenter", true)
		presentationApplication.assignPresenter(scope.name, presenter)
	}
	
	public void gotoSlide(def slideNum) {
		log.debug("Request to go to slide $slideNum")
		IScope scope = Red5.connectionLocal.scope
		presentationApplication.gotoSlide(scope.name, slideNum)
	}
	
	public void sharePresentation(def presentationName, def share) {
		log.debug("Request to go to sharePresentation $presentationName $share")
		IScope scope = Red5.connectionLocal.scope
		presentationApplication.sharePresentation(scope.name, presentationName, share)
	}
	
	public void setParticipantsApplication(ParticipantsApplication a) {
		log.debug("Setting participants application")
		participantsApplication = a
	}
	
	public void setPresentationApplication(PresentationApplication a) {
		log.debug("Setting Presentation Applications")
		presentationApplication = a
	}
}
