class PresentationService {

    boolean transactional = false
	def ImageMagick
	
//	public void setImageMagick(String m) {
//		imageMagick = m
//	}
	
    def deletePresentation = {directory ->
		System.out.println("delete = ${directory}")
		/**
		 * Go through each directory and check if it's not empty.
		 * We need to delete files inside a directory before a
		 * directory can be deleted.
		**/
		File[] files = directory.listFiles();				
		for (int i = 0; i < files.length; i++) {
			if (files[i].isDirectory()) {
				deletePresentation(files[i])
			} else {
				files[i].delete()
			}
		}
		// Now that the directory is empty. Delete it.
		directory.delete()
	}
	
	def listPresentations = {directory ->
		System.out.println("Imagemgic ${imageMagick}");
		def presentationsList = []
		if( directory.exists() ){
			directory.eachFile(){ file->
			System.out.println(file.name)
			if( file.isDirectory() )
				presentationsList.add( file.name )
			}
		}	
		return presentationsList
	}
	
	def processUploadedPresentation = {destDir, presentation ->
		  new File( destDir ).mkdirs()
		  def pres = new File( destDir + File.separatorChar + presentation.getOriginalFilename() )
		  presentation.transferTo( pres )
		  convertUploadedPresentation(pres)	
		  createThumbnails(pres)		
	}
	
	def showPresentation = {destDir ->
		System.out.println(destDir);
		def pres = destDir + File.separatorChar + "slides.swf"
		new File( pres )
	}
	
	def showThumbnail = {destDir, thumb ->
		System.out.println(destDir);
		def pres = destDir + File.separatorChar + "thumbnails" + File.separatorChar + "thumb-${thumb}.png"
		new File( pres )
	}
	
	def numberOfThumbnails = {destDir ->
		def thumbDir = new File(destDir + File.separatorChar + "thumbnails")
		System.out.println(thumbDir.absolutePath + " " + thumbDir.listFiles().length)
		thumbDir.listFiles().length
	}
	
	def convertUploadedPresentation = {presentation ->
        try {
            def command = "pdf2swf -tT 9 " + presentation.getAbsolutePath() + " -o " + presentation.parent + File.separatorChar + "slides.swf"         
            Process p = Runtime.getRuntime().exec(command);
            
            BufferedReader stdInput = new BufferedReader(new 
                 InputStreamReader(p.getInputStream()));

            BufferedReader stdError = new BufferedReader(new 
                 InputStreamReader(p.getErrorStream()));
			def s
            while ((s = stdInput.readLine()) != null) {
                System.out.println(s);
            }
            
            // read any errors from the attempted command
            System.out.println("Here is the standard error of the command (if any):\n");
            while ((s = stdError.readLine()) != null) {
            	System.out.println(s);
            }
            stdInput.close();
            stdError.close();
        }
        catch (IOException e) {
            System.out.println("exception happened - here's what I know: ");
            e.printStackTrace();
        }		
	}
	
	def createThumbnails = {presentation -> 
		try {
		 	def thumbsDir = new File(presentation.getParent() + File.separatorChar + "thumbnails")
		 	thumbsDir.mkdir()
            def command = imageMagick + "/convert -thumbnail 150x150 " + presentation.getAbsolutePath() + " " + thumbsDir.getAbsolutePath() + "/thumb.png"         
            System.out.println("thumb command = " + command)
            
            Process p = Runtime.getRuntime().exec(command);
            
            BufferedReader stdInput = new BufferedReader(new 
                 InputStreamReader(p.getInputStream()));

            BufferedReader stdError = new BufferedReader(new 
                 InputStreamReader(p.getErrorStream()));
			def s
            while ((s = stdInput.readLine()) != null) {
                System.out.println(s);
            }
            
            // read any errors from the attempted command
            System.out.println("Here is the standard error of the command (if any):\n");
            while ((s = stdError.readLine()) != null) {
            	System.out.println(s);
            }
            stdInput.close();
            stdError.close();
        }
        catch (IOException e) {
            System.out.println("exception happened - here's what I know: ");
            e.printStackTrace();
        }
	}
}
