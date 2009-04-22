package org.bigbluebutton.web.services

class PresentationServiceTests extends GroovyTestCase {
	
	def presService
	Object waitingSignal = new Object();
	
	void setUp() 
	{
		presService = new PresentationService()
		
		//override method		
		presService.class.metaClass.sendJMSMessage = sendJMSMessageTests
		presService.class.metaClass.tearDown = teanDownTests

		//set values which are supposed to be loaded from bigbluebutton.properties
		presService.imageMagick = "E:/ImageMagick-6.5.1-Q16"
		presService.ghostScript = "E:/ghostscript8.64/gs8.64/bin/gswin32c"
		presService.swfTools = "E:/swftools"
		presService.presentationDir = "E:/temp/bigbluebutton"
	}

	//override sendJMSMessage method of PresentationService.groovy
    def sendJMSMessageTests = {msg ->
		presService.log.debug "PresentationServiceTests::sendJMSMessageTests()... do nothing(for Tests)"
	}
	
	//override teanDown method for PresentationServiceTests.groovy
    def teanDownTests = { ->
		//this is for PresentationService.groovy to notify PresentationServiceTests.groovy to exit the main-testing-thread becuse now all sub-threads-tasks are finished
		synchronized(presService)
		{
			presService.notifyAll();
		}
		presService.log.debug "PresentationServiceTests::teanDownTests()....."
	}

    void testGetNumberOfPages(){
    	def file = new PresentationFile('test/resources/GoodPresentation.pdf')
    	presService.println "PresentationServiceTests::testProcessGoodPresentation()...  File path =${file.absolutePath}"
    	def errCode = presService.getPresentationNumPages("1", "1", "GoodPresentation", file)
		assert(errCode!=0)
    }
	
    void testProcessGoodPresentation() 
    {
    	/*
    	def file = new PresentationFile('test/resources/GoodPresentation.pdf')
    	presService.println "PresentationServiceTests::testProcessGoodPresentation()...  File path =${file.absolutePath}"
    	def errCode = presService.processUploadedPresentation("1", "1", "GoodPresentation", file)
		assert(errCode==0)

		//this is for wait for the notifying-signal from PresentationService.groovy, then to exit the main-testing-thread becuse now all sub-threads-tasks are finished
		synchronized(presService){
			try{
				presService.wait();
			}
			catch(Exception e){
				e.printStackTrace()
			}
		}
		*/
    }
    
    void testProcessOneSlideWithTooManyObjectsPresentation() {
    	/*
    	def file = new PresentationFile('test/resources/big.pdf')
    	presService.println "PresentationServiceTests::testProcessGoodPresentation()...  File path =${file.absolutePath}"
    	def errCode = presService.processUploadedPresentation("1", "1", "OneBigPagePresentation", file)
		assert(errCode==0)

		//this is for wait for the notifying-signal from PresentationService.groovy, then to exit the main-testing-thread becuse now all sub-threads-tasks are finished
		synchronized(presService){
			try{
				presService.wait();
			}
			catch(Exception e){
				e.printStackTrace()
			}
		}
		*/
    }
    
    void testProcessSeveralSlidesWithTooManyObjectsPresentation() {
    	/*
    	def file = new PresentationFile('test/resources/SeveralBigPagesPresentation.pdf')
    	presService.println "PresentationServiceTests::testProcessGoodPresentation()...  FIle path =${file.absolutePath}"
    	def errCode = presService.processUploadedPresentation("1", "1", "SeveralBigPagesPresentation", file)
		assert(errCode==0)

		//this is for wait for the notifying-signal from PresentationService.groovy, then to exit the main-testing-thread becuse now all sub-threads-tasks are finished
		synchronized(presService){
			try{
				presService.wait();
			}
			catch(Exception e){
				e.printStackTrace()
			}
		}
		*/
    }
    
    
}

class PresentationFile extends java.io.File {
	
	public PresentationFile(String name){
		super(name)
	}
	
    def transferTo = {dest ->
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
		return super.getName()
	}
    
}
