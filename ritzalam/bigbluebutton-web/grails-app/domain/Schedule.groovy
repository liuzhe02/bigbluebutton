class Schedule implements Comparable {
	Date dateCreated
	Date lastUpdated
	String scheduledBy
	String scheduleName
	Integer scheduleNumber
	Integer numberOfAttendees = new Integer(3)
	Date startDateTime = new Date()
	Integer lengthOfConference
	Boolean record = false
			
	static constraints = {		
		scheduleName(maxLength:50, blank:false)
		scheduleNumber(maxLength:10, unique:true, blank:false)
		lengthOfConference(inList:[1, 2, 3, 4])
		numberOfAttendees()
		scheduledBy(blank:false)
	}

	String toString() {"${this.scheduleName}"}

    int compareTo(obj) {
        obj.id.compareTo(id)
    }
}
