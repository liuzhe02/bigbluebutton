package org.bigbluebutton.web.domain

class ScheduledSession implements Comparable {
	Date dateCreated
	Date lastUpdated
	String createdBy
	String modifiedBy
	
	String name
	/* The id for this session. This can be used as the conference room in Red5, for example. */
	String sessionId
	/* An id that we can use in the URL to join this conference session */
	String tokenId
	Integer numberOfAttendees = new Integer(3)
	Date startDateTime = new Date()
	/* Is there a time limit for this session? */
	Boolean timeLimited = true
	/* If there is a time limit, for how long (minutes)? */
	Integer duration
	/* Is this session going to be recorded? */
	Boolean record = false
	/* Do we require a password to join this session? */
	Boolean passwordProtect = true
	String hostPassword = 'change-me-please'
	String moderatorPassword = 'change-me-please'
	String attendeePassword = 'change-me-please'
	
	static belongsTo = [conference:Conference]
			
	static constraints = {		
		name(maxLength:50, blank:false)
		tokenId(blank:false)
		sessionId(blank:false)
		duration(range:30-300)
		numberOfAttendees()
	}
	
	String toString() {"${this.name}"}

    int compareTo(obj) {
        obj.id.compareTo(id)
    }
}
