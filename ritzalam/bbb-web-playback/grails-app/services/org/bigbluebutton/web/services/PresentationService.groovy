package org.bigbluebutton.web.services

import javax.jms.Message
import javax.jms.Session
import javax.jms.JMSException
import javax.jms.MapMessage
import org.springframework.jms.core.JmsTemplate
import java.util.*;
import java.util.concurrent.*;

class PresentationService {

    boolean transactional = false
	def jmsTemplate	
	def imageMagick
	def ghostScript
	def swfTools
	def presentationDir
	
	private static String JMS_UPDATES_Q = 'UpdatesQueue'
	    
    def deletePresentation = {conf, room, filename ->
    	def directory = new File(roomDirectory(conf, room).absolutePath + File.separatorChar + filename)
    	deleteDirectory(directory) 
	}
	
	def deleteDirectory = {directory ->
		log.debug "delete = ${directory}"
		/**
		 * Go through each directory and check if it's not empty.
		 * We need to delete files inside a directory before a
		 * directory can be deleted.
		**/
		File[] files = directory.listFiles();				
		for (int i = 0; i < files.length; i++) {
			if (files[i].isDirectory()) {
				deleteDirectory(files[i])
			} else {
				files[i].delete()
			}
		}
		// Now that the directory is empty. Delete it.
		directory.delete()	
	}
	
	def listPresentations = {conf, room ->
		def presentationsList = []
		def directory = roomDirectory(conf, room)
		log.debug "directory ${directory.absolutePath}"
		if( directory.exists() ){
			directory.eachFile(){ file->
				System.out.println(file.name)
				if( file.isDirectory() )
					presentationsList.add( file.name )
			}
		}	
		return presentationsList
	}
	
    public File uploadedPresentationDirectory(String conf, String room, String presentation_name) {
	    println "Uploaded presentation ${presentation_name}"
		File dir = new File(roomDirectory(conf, room).absolutePath + File.separatorChar + presentation_name)
		println "upload to directory ${dir.absolutePath}"
			
		/* If the presentation name already exist, delete it. We should provide a check later on to notify user
			that there is already a presentation with that name. */
		if (dir.exists()) deleteDirectory(dir)		
		dir.mkdirs()
		
		assert dir.exists()
		return dir
    }

	def processUploadedPresentation = {conf, room, presentation_name, presentationFile ->	
		// Run conversion on another thread.
		Thread.start 
		{
			new Timer().runAfter(1000) 
			{
				//first we need to know how many pages in this pdf
				def numPages = determineNumberOfPages(presentationFile)
				assert((new Integer(numPages).intValue()) != -1)
						
			}
		}
	}
	
    public int determineNumberOfPages(File presentationFile) {
		def numPages = -1 //total numbers of this pdf, also used as errorcode(-1)	

		try 
		{
			def command = swfTools + "/pdf2swf -I " + presentationFile.getAbsolutePath()        
			def p = Runtime.getRuntime().exec(command);            

			def stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			def stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
			def info
			def str //output information to console for stdInput and stdError
			while ((info = stdInput.readLine()) != null) {
				//The output would be something like this 'page=21 width=718.00 height=538.00'.
	    		//We need to extract the page number (i.e. 21) from it.
	    		def infoRegExp = /page=([0-9]+)(?: .+)/
	    		def matcher = (info =~ infoRegExp)
	    		if (matcher.matches()) {
	    			//if ((matcher[0][1]) > numPages) {
	    				numPages = matcher[0][1]
	    				//	println "Number of pages = ${numPages}"
	    				// } else {
					   // 	println "Number of pages = ${numPages} match=" + matcher[0][1]
					   // }
	    		} else {
	    			println "no match info: ${info}"
	    		}
			}
			while ((info = stdError.readLine()) != null) {
				System.out.println("Got error getting info from file):\n");
				System.out.println(str);
			}
			stdInput.close();
			stdError.close();

			//assert(p.exitValue() == 0)
			if(p.exitValue() != 0) return -1;
		}
		catch (IOException e) {
			System.out.println("exception happened - here's what I know: ");
			e.printStackTrace();
		}		

		return new Integer(numPages).intValue()
    }
 	
	def showSlide(String conf, String room, String presentationName, String id) {
		new File(roomDirectory(conf, room).absolutePath + File.separatorChar + presentationName + File.separatorChar + "slide-${id}.swf")
	}
	
	def showPresentation = {conf, room, filename ->
		new File(roomDirectory(conf, room).absolutePath + File.separatorChar + filename + File.separatorChar + "slides.swf")
	}
	
	def showThumbnail = {conf, room, presentationName, thumb ->
		new File(roomDirectory(conf, room).absolutePath + File.separatorChar + presentationName + File.separatorChar + 
			"thumbnails" + File.separatorChar + "thumb-${thumb}.png")
	}
	
	def numberOfThumbnails = {conf, room, name ->
		def thumbDir = new File(roomDirectory(conf, room).absolutePath + File.separatorChar + name + File.separatorChar + "thumbnails")
		System.out.println(thumbDir.absolutePath + " " + thumbDir.listFiles().length)
		thumbDir.listFiles().length
	}   
	
    def roomDirectory = {conf, room ->
		return new File(presentationDir + File.separatorChar + conf + File.separatorChar + room)
    }

	public boolean convertUploadedPresentation(File presentationFile, int numPages) {
		
		for (page = 1; page <= numPages; page++) 
	    {
	        convertPage(presentationFile, page)
	    }
	}

	public void convertPage(File presentationFile, int page) {
	    def result = convertUsingPdf2Swf(presentationFile, page)

	    if (!result) {
	    	
	    }
	
	}
	
	public boolean extractPageUsingGhostScript(File presentationFile, int page) {	
		def tempDir = new File(presentationFile.getParent() + File.separatorChar + "temp")
		tempDir.mkdir()
		
    	//extract that specific page and create a temp-pdf(only one page) with GhostScript
		def command = ghostScript + " -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dFirstPage=" + page + " -dLastPage=" + page + " -sOutputFile=" + (tempDir.getAbsolutePath() + "/temp-${page}.pdf") + " " + presentationFile          
        def p = Runtime.getRuntime().exec(command);            

	    def stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
		def stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
		def str
        while ((str = stdInput.readLine()) != null) {
	        System.out.println(str);
    	}
	    // read any errors from the attempted command
        System.out.println("Here is the standard error of the command (if any):\n");
	    while ((str = stdError.readLine()) != null) {
    		System.out.println(str);
	    }
    	stdInput.close();
	    stdError.close();		
	    
	    if (p.exitValue() != 0) {
	    	return true
	    } else {
	    	return false
	    }
	}
	
	
	public boolean convertUsingJpeg2Swf(File presentationFile, int page) {
		//assert(p.exitValue() == 0)
		if(p.exitValue() != 0) return new Integer(-1);
	
		//now convert that jpeg to swf with swftools(jpeg2swf)
        command = caller.swfTools + "/jpeg2swf -o " + presentation.parent + File.separatorChar + "slide-" + (page-1) + ".swf" + " " + presentation.parent + File.separatorChar + "temp/temp-" + (page-1) + ".jpeg"
		println("PresentationService.groory::convertUploadedPresentation()... convert that jpeg to swf with swftools(jpeg2swf):  command=" + command);
	        p = Runtime.getRuntime().exec(command);            

		    stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
    	while ((str = stdInput.readLine()) != null) {
	        	System.out.println(str);
    	}
	    // read any errors from the attempted command
        System.out.println("Here is the standard error of the command (if any):\n");
		    while ((str = stdError.readLine()) != null) {
   			System.out.println(str);
    	}
    	stdInput.close();
	    stdError.close();		
	}
	
	public boolean convertUsingImageMagick(File presentationFile, int page) {
		def tempDir = new File(presentationFile.getParent() + File.separatorChar + "temp")
		tempDir.mkdir()
		
        def command = imageMagick + "/convert " + (tempDir.getAbsolutePath() + "/temp-${page}.pdf") + " " + (tempDir.getAbsolutePath() + "/temp-${page}.jpeg")         
		
		def p = Runtime.getRuntime().exec(command);            

//		if (p.exitValue() != 0) {
//	    	return true
//	    } else {
//	    	return false
//	    }
	}
		
	public boolean convertUsingPdf2Swf(File presentationFile, int page) {
		def command        
	   	def Process p            
	    def BufferedReader stdInput
	    def BufferedReader stdError
		def info
		def str //output information to console for stdInput and stdError
		def convertSuccess = false
		
	    try 
	    {
	       /* Now we convert the pdf file to swf 
	        * We start the output with a page number starting at zero (0) so it's consistent
	        * with the naming convention when we create the thumbnails. Looks like ImageMagick
	        * uses zero-base when creating the thumbnails.	
	       */                         
	       command = swfTools + "/pdf2swf -p " + page + " " + presentationFile.getAbsolutePath() + " -o " + presentationFile.parent + File.separatorChar + "slide-" + (page-1) + ".swf"         
		   p = Runtime.getRuntime().exec(command)

		   stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
	       stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

           while ((str = stdInput.readLine()) != null) {

        	   /* The convert output is something like ''NOTICE  processing PDF page 2 (718x538:0:0) (move:-37:-37)'.
				* We extract the page number from it taking it as a successful conversion.
				*/
				def convertRegExp = /NOTICE (?: .+) page ([0-9]+)(?: .+)/
				def matcher = (str =~ convertRegExp)
				
				if (matcher.matches()) {
					convertSuccess = true
				} else {
				    println "no match convert: ${str}"
				}
	       }
           
	       while ((str = stdError.readLine()) != null) {
	          	System.out.println("Got error converting file):\n");
	           	System.out.println(str);
	       }
		   stdInput.close();
	       stdError.close();	
	    }
	    catch (IOException e) {
	        System.out.println("exception happened - here's what I know: ");
	        e.printStackTrace();
	    }
	    
	    if (p.exitValue() != 0) {
	    	return true
	    } else {
	    	return false
	    }
	}
}	

