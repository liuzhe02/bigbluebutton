
package org.bigbluebutton.conference


public class Participant{

	/** The userid. */
	public Integer userid;
	
	/** The name. */
	public String name;
	
	/** The status. */
	public String status = "";
	
	public String role = "VIEWER";
	
	/** The has stream. */
	public Boolean hasStream = new Boolean(false);
	
	public Boolean presenter = new Boolean(false);
	
	/** The stream name. */
	public String streamName = "";
	

	public Participant(Integer userid, String name, String role) {
		this.userid = userid;
		this.name = name;
		this.role = role;
	}
	
	
}
