class UrlMappings {
    static mappings = {
      "/presentation/$presentation_name"(controller:"presentation") {
      	action = [GET:'show', POST:'upload', DELETE:'delete']
      }
      
      "/thumbnail/$presentation_name"(controller:"presentation") {
      	action = [GET:'show']
      }
      
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
	  "500"(view:'/error')
	  
	  "/" (controller: 'conference', action: 'list')
	}
}
