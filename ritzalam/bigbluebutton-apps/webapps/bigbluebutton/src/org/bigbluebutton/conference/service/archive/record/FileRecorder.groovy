
package org.bigbluebutton.conference.service.archive.record

import org.ho.yaml.YamlEncoder
public class FileRecorder implements IRecorder{

	private final String conference
	private final String room
	private final String recordingsDirectory
	private final File recordingFile

	public FileRecorder(String conference, String room) {
		this.conference = conference
		this.room = room
	}
	
	public void initialize() {
		File roomDir = new File("$recordingsDirectory/$conference/$room")
		if (! roomDir.exists())
			roomDir.mkdirs()
		recordingFile = new File(roomDir.canonicalPath + File.separator + "recordings.yaml" )
		if (recordingFile.exists()) {
			// delete the file so we start fresh
			recordingFile.delete()
			recordingFile = new File(roomDir.canonicalPath + File.separator + "recordings.yaml" )
		}
	}
	
	public void recordEvent(Map event) {
		FileOutputStream fout = new FileOutputStream(recordingFile, true /*append*/)
		YamlEncoder enc = new YamlEncoder(fout)
        enc.writeObject(event)
        enc.close()       
	}
	
	public void setRecordingsDirectory(String directory) {
		recordingsDirectory = directory
	}
}
