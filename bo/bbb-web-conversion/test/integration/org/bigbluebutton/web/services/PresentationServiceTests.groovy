package org.bigbluebutton.web.services

class PresentationServiceTests extends GroovyTestCase {
	
	def presService
	
	void setUp() {
		presService = new PresentationService()
		
		//override method		
		presService.class.metaClass.sendJMSMessage = sendJMSMessageTests

		//set values which are supposed to be loaded from bigbluebutton.properties
		presService.imageMagick = "C:/ImageMagick_6.4.9_Q16"
		presService.ghostScript = "C:/gs863/gs8.63/bin/gswin32c"
		presService.swfTools = "C:/swftools"
		presService.presentationDir = "C:/temp/bigbluebutton"
	}
	//override sendJMSMessage method of PresentationService.groovy
    def sendJMSMessageTests = {msg ->
		presService.log.debug "PresentationService::sendJMSMessageTests()... do nothing(for Tests)"
	}
	
    void testProcessGoodPresentation() 
    {
    	//def file = new PresentationFile('test/resources/GoodPresentation.pdf')
    	//println "PresentationServiceTests::testProcessGoodPresentation()...  FIle path =${file.absolutePath}"
    	//presService.processUploadedPresentation("test-conf", "test-room", "GoodPresentation", file)
    }
    
    void testProcessOneSlideWithTooManyObjectsPresentation() {
    	def file = new PresentationFile('test/resources/big.pdf')
    	println "PresentationServiceTests::testProcessGoodPresentation()...  File path =${file.absolutePath}"
    	presService.processUploadedPresentation("test-conf", "test-room", "OneBigPagePresentation", file)
    }
    
    void testProcessSeveralSlidesWithTooManyObjectsPresentation() {
    	//def file = new PresentationFile('test/resources/SeveralBigPagesPresentation.pdf')
    	//println "PresentationServiceTests::testProcessGoodPresentation()...  FIle path =${file.absolutePath}"
    	//presService.processUploadedPresentation("test-conf", "test-room", "SeveralBigPagesPresentation", file)
    }
    
    void testGetNumberOfPages(){
    }
    
    void testCreateThumbnails(){
    }
    
}

class PresentationFile extends java.io.File {
	
	public PresentationFile(String name){
		super(name)
	}
	
    def transferTo = {dest ->
		println "PresentationFile::transferTo()... "

		FileInputStream from = null;
	    FileOutputStream to = null;
	    try {
    		from = new FileInputStream(super);
		    to = new FileOutputStream(dest);
		    byte[] buffer = new byte[4096];
		    int bytesRead;

		    while ((bytesRead = from.read(buffer)) != -1)
        		to.write(buffer, 0, bytesRead); // write
	    } finally 
	    {
    		if (from != null)
	        	try {
    		    	from.close();
		        } catch (IOException e) {
    	        	;
	        	}
			
			if (to != null)
        		try {
			        to.close();
		       	} catch (IOException e) {
        			;
			    }
		}
	}
	
    def getOriginalFilename = { 
		println "PresentationFile::getOriginalFilename()()... "
		
		return super.getName()
	}
    
}
