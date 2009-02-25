package org.bigbluebutton.conference
public class Participant  {

	public String userid
	public String name
	public String role = "VIEWER"
	public Map status
	
	public Participant(String userid, String name, String role, Map status) {
		this.userid = userid
		this.name = name
		this.role = role 
		this.status = status
	}
	
	public void setStatus(String status, Object value) {
		status.put(status, value)
	}
	
	public Map toMap() {
		Map m = new HashMap()
		m.put("userid", userid)
		m.put("name", name)
		m.put("role", role)
		m.put("status", status)
		return m
	}
}
