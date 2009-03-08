
package org.bigbluebutton.conference.service.archive.record


public class RecordSession{

	private String name
//	private List<IRecordWriter> recordWriters
	
	public RecordSession(String room) {
		name = room
	}
	
	public String getName() {
		return name
	}
	
}
