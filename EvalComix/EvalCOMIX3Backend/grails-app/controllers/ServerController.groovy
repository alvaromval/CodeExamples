import grails.converters.XML

class ServerController {

    def index =
    {
    }

    def rest =
    {
        //def key = "org.springframework.web.servlet.DispatcherServlet.LOCALE_RESOLVER"
        //def localeResolver = request.getAttribute(key)
        //def locale = localeResolver.resolveLocale(request)
        //println locale
        switch(request.method)
        {
            case 'GET':
                get(params)
                break;
            case 'POST':
                create(params.server)
                break;
        }
    }

    def create =
    {
        create(params)
    }
    
    private create(params)
    {
        println request.getRemoteHost()
        println request.getRemoteAddr()
        def server = new Server()
        def identifier = common.Utils.generateServerID()
        while(Server.findByIdentifier(identifier))
        {
            identifier = common.Utils.generateServerID()
        }
        server.identifier = identifier
        server.save()
        if(server.hasErrors())
        {
            response.status = 500
            render(text:"<error>"  + server.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            render server as XML
        }
    }

    private get(params)
    {
        if(params.identifier == null)
        {
            def errorMsg = "To get a server definition you have to provide the next params in the http petition:\n" +
            "identifier (identifier of the server)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def server = Server.findByIdentifier(params.identifier)
            if(server)
            {
                render server as XML
                response.status = 500
            }
            else
            {
                def errorMsg = "Server " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }
}
