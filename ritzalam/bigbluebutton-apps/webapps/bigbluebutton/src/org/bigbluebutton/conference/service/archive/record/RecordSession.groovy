
package org.bigbluebutton.conference.service.archive.record


public class RecordSession{

	private String name
	private String conference
	
//	private List<IRecordWriter> recordWriters
	
	public RecordSession(String conference, String room) {
		name = room
		this.conference = conference
	}
	
	public String getName() {
		return name
	}
	
}
