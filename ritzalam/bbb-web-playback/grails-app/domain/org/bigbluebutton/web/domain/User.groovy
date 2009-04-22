package org.bigbluebutton.web.domain

class User {
    String username
    String passwordHash
	String email
	String fullName
	SortedSet conferences
	Date dateCreated
	Date lastUpdated

	static hasMany = [conferences:Conference]
	static hasMany = [accounts:Account]
    
    static constraints = {
        username(nullable: false, blank: false)
		email(email:true,unique:true)
		fullName(blank:false)	
    }

	String toString() {"${this.fullName}"}
}


