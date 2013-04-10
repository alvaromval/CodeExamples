class UrlMappings {
    static mappings = {
        "/instrument/read"
        {
            controller = "instrument"
            action = "read"
        }

        "/instrument/create"
        {
            controller = "instrument"
            action = "create"
        }

        "/instrument/create/$identifier/$type"
        {
            controller = "instrument"
            action = "create"
        }

        "/instrument/open/$identifier?"
        {
            controller = "instrument"
            action = "open"
        }

        "/instrument/view/$identifier?"
        {
            controller = "instrument"
            action = "view"
        }

        "/instrument/$identifier?"(controller:"instrument", parseRequest:true)
        {
            action = "rest"
        }

        "/assessment/coassessment"
        {
            controller = "assessment"
            action = "coassessment"
        }

        "/assessment/coassessment/$identifier/$identifierReviewed"
        {
            controller = "assessment"
            action = "coassessment"
        }

        "/assessment/create"
        {
            controller = "assessment"
            action = "create"
        }

        "/assessment/create/$identifier/$instrumentIdentifier"
        {
            controller = "assessment"
            action = "create"
        }

        "/assessment/open/$identifier?"
        {
            controller = "assessment"
            action = "open"
        }

        "/assessment/view/$identifier?"
        {
            controller = "assessment"
            action = "view"
        }

        "/assessment/$identifier?"(controller:"assessment", parseRequest:true)
        {
            action = "rest"
        }

        "/server/$identifier?"(controller:"server", parseRequest:true)
        {
            action = "rest"
        }

        "/server/create"
        {
            controller = "server"
            action = "create"
        }

        "/$controller/$action/$identifier?"
        {
            constraints {
                // apply constraints here
            }
        }
        "/"(view:"/index")
            "500"(view:'/error')
    }
}