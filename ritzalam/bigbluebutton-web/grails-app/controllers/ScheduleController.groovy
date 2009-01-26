class ScheduleController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ scheduleInstanceList: Schedule.list( params ) ]
    }

    def show = {
        def scheduleInstance = Schedule.get( params.id )

        if(!scheduleInstance) {
            flash.message = "Schedule not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ scheduleInstance : scheduleInstance ] }
    }

    def delete = {
        def scheduleInstance = Schedule.get( params.id )
        if(scheduleInstance) {
            scheduleInstance.delete()
            flash.message = "Schedule ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "Schedule not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def scheduleInstance = Schedule.get( params.id )

        if(!scheduleInstance) {
            flash.message = "Schedule not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ scheduleInstance : scheduleInstance ]
        }
    }

    def update = {
        def scheduleInstance = Schedule.get( params.id )
        if(scheduleInstance) {
            scheduleInstance.properties = params
            if(!scheduleInstance.hasErrors() && scheduleInstance.save()) {
                flash.message = "Schedule ${params.id} updated"
                redirect(action:show,id:scheduleInstance.id)
            }
            else {
                render(view:'edit',model:[scheduleInstance:scheduleInstance])
            }
        }
        else {
            flash.message = "Schedule not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def scheduleInstance = new Schedule()
        scheduleInstance.properties = params
        return ['scheduleInstance':scheduleInstance]
    }

    def save = {
        def scheduleInstance = new Schedule(params)
        if(!scheduleInstance.hasErrors() && scheduleInstance.save()) {
            flash.message = "Schedule ${scheduleInstance.id} created"
            redirect(action:show,id:scheduleInstance.id)
        }
        else {
            render(view:'create',model:[scheduleInstance:scheduleInstance])
        }
    }
}
