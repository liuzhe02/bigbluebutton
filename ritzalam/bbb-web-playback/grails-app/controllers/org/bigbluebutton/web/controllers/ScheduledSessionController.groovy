package org.bigbluebutton.web.controllers

import org.bigbluebutton.web.domain.ScheduledSession
import java.util.UUID
import org.bigbluebutton.web.domain.User
import org.bigbluebutton.web.domain.Conference

class ScheduledSessionController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ scheduledSessionInstanceList: ScheduledSession.list( params ) ]
    }

    def show = {
        def scheduledSessionInstance = ScheduledSession.get( params.id )

        if(!scheduledSessionInstance) {
            flash.message = "ScheduledSession not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ scheduledSessionInstance : scheduledSessionInstance ] }
    }

    def delete = {
        def scheduledSessionInstance = ScheduledSession.get( params.id )
        if(scheduledSessionInstance) {
            scheduledSessionInstance.delete()
            flash.message = "ScheduledSession ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "ScheduledSession not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def scheduledSessionInstance = ScheduledSession.get( params.id )

        if(!scheduledSessionInstance) {
            flash.message = "ScheduledSession not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ scheduledSessionInstance : scheduledSessionInstance ]
        }
    }

    def update = {
        def scheduledSessionInstance = ScheduledSession.get( params.id )
        if(scheduledSessionInstance) {
            scheduledSessionInstance.properties = params
            if(!scheduledSessionInstance.hasErrors() && scheduledSessionInstance.save()) {
                flash.message = "ScheduledSession ${params.id} updated"
                redirect(action:show,id:scheduledSessionInstance.id)
            }
            else {
                render(view:'edit',model:[scheduledSessionInstance:scheduledSessionInstance])
            }
        }
        else {
            flash.message = "ScheduledSession not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def scheduledSessionInstance = new ScheduledSession()
        scheduledSessionInstance.properties = params
        return ['scheduledSessionInstance':scheduledSessionInstance]
    }

    def save = {
    	def userid =  session["userid"]
       	def user = User.get(userid)
    	
       	params.createdBy = user.fullName
    	params.modifiedBy = user.fullName
    	   	
    	def conf = Conference.get(params.conferenceId)
    	
        def scheduledSessionInstance = new ScheduledSession(params)
    	scheduledSessionInstance.sessionId = UUID.randomUUID()
    	scheduledSessionInstance.tokenId = UUID.randomUUID()
    	conf.addToSessions(scheduledSessionInstance)
        if(!scheduledSessionInstance.hasErrors() && conf*.save(flush:true)) {
            flash.message = "ScheduledSession ${scheduledSessionInstance.id} created"
            redirect(action:show,id:scheduledSessionInstance.id)
        }
        else {
            render(view:'create',model:[scheduledSessionInstance:scheduledSessionInstance])
        }
    }
}
