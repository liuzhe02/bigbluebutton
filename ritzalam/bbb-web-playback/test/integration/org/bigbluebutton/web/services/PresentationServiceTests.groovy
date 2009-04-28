package org.bigbluebutton.web.services

import org.springframework.util.FileCopyUtils

class PresentationServiceTests extends GroovyTestCase {
	
	def SWFTOOLS = "C:/swftools-0.9"
	def IMAGEMAGICK = "C:/ImageMagick-6.4.8-Q16/"
	def GHOSTSCRIPT = "C:/gs/gs8.63/bin/gswin32c.exe"
	def PRESENTATIONDIR = "d:/temp/bigbluebutton"
	
	def presService
		
	void setUp() {
		presService = new PresentationService()
		presService.swfTools = SWFTOOLS
		presService.imageMagick = IMAGEMAGICK
		presService.ghostScript = GHOSTSCRIPT
		presService.presentationDir = PRESENTATIONDIR
	}
	
	void testGetUploadDirectory() {
		def uploadedFilename = 'sample-presentation.pdf'		
		def uploadedFile = new File("test/resources/$uploadedFilename")
    	def conf = "test-conf"
    	def rm = "test-room"
    	def presName = "test-presentation"
    	    	
		File uploadDir = presService.uploadedPresentationDirectory(conf, rm, presName)
		def uploadedPresentation = new File(uploadDir.absolutePath + File.separator + uploadedFilename)
    	uploadedPresentation = new File("$PRESENTATIONDIR/$conf/$rm/$presName/$uploadedFilename")
    	int copied = FileCopyUtils.copy(uploadedFile, uploadedPresentation) 
    	assertTrue(uploadedPresentation.exists())
	}
	
	void testGetNumberOfPagesForPresentation() {
		def uploadedFilename = 'sample-presentation.pdf'		
		def uploadedFile = new File("test/resources/$uploadedFilename")
	    def conf = "test-conf"
	    def rm = "test-room"
	    def presName = "test-presentation"
	    	    	
		File uploadDir = presService.uploadedPresentationDirectory(conf, rm, presName)
		def uploadedPresentation = new File(uploadDir.absolutePath + File.separator + uploadedFilename)
	    uploadedPresentation = new File("$PRESENTATIONDIR/$conf/$rm/$presName/$uploadedFilename")
	    int copied = FileCopyUtils.copy(uploadedFile, uploadedPresentation) 
	    assertTrue(uploadedPresentation.exists())
		int numPages = presService.determineNumberOfPages(uploadedPresentation)
		assertEquals 8, numPages
	}
		
	void testConvertPage() {
		def uploadedFilename = 'sample-presentation.pdf'		
		def uploadedFile = new File("test/resources/$uploadedFilename")
		def conf = "test-conf"
		def rm = "test-room"
		def presName = "test-presentation"
		    	    	
		File uploadDir = presService.uploadedPresentationDirectory(conf, rm, presName)
		def uploadedPresentation = new File(uploadDir.absolutePath + File.separator + uploadedFilename)
		uploadedPresentation = new File("$PRESENTATIONDIR/$conf/$rm/$presName/$uploadedFilename")
		int copied = FileCopyUtils.copy(uploadedFile, uploadedPresentation) 
		assertTrue(uploadedPresentation.exists())
		int numPages = presService.determineNumberOfPages(uploadedPresentation)
		assertEquals 8, numPages
		
		for (int page = 1; page <= numPages; page++) {
			presService.convertUsingPdf2Swf(uploadedPresentation, page)
		}	    
	}

	void testExtractPageUsingGhostscript() {
		def uploadedFilename = 'sample-presentation.pdf'		
		def uploadedFile = new File("test/resources/$uploadedFilename")
		def conf = "test-conf"
		def rm = "test-room"
		def presName = "test-presentation"
			    	    	
		File uploadDir = presService.uploadedPresentationDirectory(conf, rm, presName)
		def uploadedPresentation = new File(uploadDir.absolutePath + File.separator + uploadedFilename)
		uploadedPresentation = new File("$PRESENTATIONDIR/$conf/$rm/$presName/$uploadedFilename")
		int copied = FileCopyUtils.copy(uploadedFile, uploadedPresentation) 
		assertTrue(uploadedPresentation.exists())
		int numPages = presService.determineNumberOfPages(uploadedPresentation)
		assertEquals 8, numPages
			
		for (int page = 1; page <= numPages; page++) {
			presService.extractPageUsingGhostScript(uploadedPresentation, page)
		}
		
		for (int page = 1; page <= numPages; page++) {
			presService.convertUsingImageMagick(uploadedPresentation, page)
		}
	}
	
/*	
    void testProcessGoodPresentation() {
    	def file = new File('test/resources/sample-presentation.pdf')
    	println "FIle path =${file.absolutePath}"
    	def conf = "test-conf"
    	def rm = "test-room"
    	def presName = "test-presentation"
    	File uploadDir = presService.uploadedPresentationDirectory(conf, rm, presName)
    	println uploadDir
    	
//    	presService.processUploadedPresentation(conf, rm, presName, file)
		def numPages = presService.determineNumberOfPages(file)
		println numPages
    }
    
    void testProcessOneSlideWithTooManyObjectsPresentation() {
    	
    }
    
    void testProcessSeveralSlidesWithTooManyObjectsPresentation() {
    	
    }
*/
}
