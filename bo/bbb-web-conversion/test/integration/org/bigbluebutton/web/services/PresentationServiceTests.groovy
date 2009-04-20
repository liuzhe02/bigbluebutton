package org.bigbluebutton.web.services

class PresentationServiceTests extends GroovyTestCase {
	
	def presService
	
	void setUp() {
		presService = new PresentationService()
	}
	
    void testProcessGoodPresentation() {
    	def file = new File('test/resources/sample-presentation.pdf')
    	println "FIle path =${file.absolutePath}"
    	presService.processUploadedPresentation("test-conf", "test-room", "test-presentation", file)
    }
    
    void testProcessOneSlideWithTooManyObjectsPresentation() {
    	
    }
    
    void testProcessSeveralSlidesWithTooManyObjectsPresentation() {
    	
    }
}
