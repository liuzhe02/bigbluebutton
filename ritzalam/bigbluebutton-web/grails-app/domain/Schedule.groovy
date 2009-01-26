class Schedule implements Comparable {
	Date dateCreated
	Date lastUpdated
	String scheduledBy
	String scheduleName
	String scheduleId
	Integer numberOfAttendees = new Integer(3)
	Date startDateTime = new Date()
	Integer lengthOfConference
	Boolean record = false
	
	static belongsTo = [conference : Conference]
			
	static constraints = {		
		scheduleName(maxLength:50, blank:false)
		scheduleId(blank:false)
		lengthOfConference(inList:[1, 2, 3, 4])
		numberOfAttendees()
		scheduledBy(blank:false)
	}

	String toString() {"${this.scheduleName}"}

    int compareTo(obj) {
        obj.id.compareTo(id)
    }
}
