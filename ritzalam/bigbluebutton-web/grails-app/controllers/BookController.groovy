class BookController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ bookInstanceList: Book.list( params ) ]
    }

    def show = {
        def bookInstance = Book.get( params.id )

        if(!bookInstance) {
            flash.message = "Book not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ bookInstance : bookInstance ] }
    }

    def delete = {
        def bookInstance = Book.get( params.id )
        if(bookInstance) {
            bookInstance.delete()
            flash.message = "Book ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "Book not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def bookInstance = Book.get( params.id )

        if(!bookInstance) {
            flash.message = "Book not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ bookInstance : bookInstance ]
        }
    }

    def update = {
        def bookInstance = Book.get( params.id )
        if(bookInstance) {
            bookInstance.properties = params
            if(!bookInstance.hasErrors() && bookInstance.save()) {
                flash.message = "Book ${params.id} updated"
                redirect(action:show,id:bookInstance.id)
            }
            else {
                render(view:'edit',model:[bookInstance:bookInstance])
            }
        }
        else {
            flash.message = "Book not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def bookInstance = new Book()
        bookInstance.properties = params
        return ['bookInstance':bookInstance]
    }

    def save = {
        def bookInstance = new Book(params)
        if(!bookInstance.hasErrors() && bookInstance.save()) {
            flash.message = "Book ${bookInstance.id} created"
            redirect(action:show,id:bookInstance.id)
        }
        else {
            render(view:'create',model:[bookInstance:bookInstance])
        }
    }
}
