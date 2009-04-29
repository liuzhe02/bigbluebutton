package org.bigbluebutton.web.domain

class Conference implements Comparable {
	Date dateCreated
	Date lastUpdated
	String createdBy
	String updatedBy
	String name
	User user
	
	SortedSet sessions
	
	static hasMany = [sessions:ScheduledSession]
			
	static constraints = {
		name(maxLength:50, blank:false)
	}

	String toString() {"${this.id}:${this.name} ${this.user}"}

    int compareTo(obj) {
       obj.id.compareTo(id)
   }

}


