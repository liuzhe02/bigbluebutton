package org.bigbluebutton.web.domain

class Account implements Comparable {
	Date created
	Date lastUpdated
	String type
	String name
	String description
	String createdBy
	String modifiedBy
	
	static belongsTo = [owner:User]
	static hasMany = [users:User, conferences:Conference]
	
	static constraints = {
		name(maxLength:50, blank:false)
		type(inList:['BASIC', 'ESSENTIAL', 'PREMIUM'])
	}
	
	String toString() {"${this.name}"}

    int compareTo(obj) {
        obj.id.compareTo(id)
    }
}
