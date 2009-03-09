
package org.bigbluebutton.conference.service.archive.record

import java.util.concurrent.CopyOnWriteArrayList
public class RecordSession{

	private final String name
	private final String conference
	private final IRecorder recorder
	
	private List<IEventRecorder> recorders
	
	public RecordSession(String conference, String room) {
		name = room
		this.conference = conference
		recorders = new CopyOnWriteArrayList<IEventRecorder>()
	}
	
	public String getName() {
		return name
	}
	
	public void addEventRecorder(IEventRecorder r) {
		r.acceptRecorder(recorder)
		recorders.add(r)
	}
	
	public void setRecorder(IRecorder recorder) {
		this.recorder = recorder
	}
}
