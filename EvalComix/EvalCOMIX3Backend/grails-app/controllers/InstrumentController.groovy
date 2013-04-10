import grails.converters.XML

class InstrumentController {

    def index = {
    }

    def identifierService
    def instrumentTypeService


    // REST INTERFACE
    def rest =
    {
        //def key = "org.springframework.web.servlet.DispatcherServlet.LOCALE_RESOLVER"
        //def localeResolver = request.getAttribute(key)
        //def locale = localeResolver.resolveLocale(request)
        //println locale
        switch(request.method)
        {
            case 'GET':
                open(params)
                break;
            case 'POST':
                create(params.instrument)
                break;
            case 'PUT':
                update(params)
                break;
            case 'DELETE':
                delete(params)
                break;
        }
    }

    // WEB SERVICES INTERFACE
    def create =
    {
        create(params)
    }

    def open =
    {
        open(params)
    }

    def get =
    {
        get(params)
    }

    def save =
    {
        save(params)
    }

    def delete =
    {
        delete(params)
    }

    def view =
    {
        view(params)
    }

    def export =
    {
        export(params)
    }

    def read =
    {
        read(request)
    }

    // INTERFACE IMPLEMENTATION
    private create(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To create a new instrument you have to provide the next params in the http petition:\n" +
            "->identifier (a identifier for the new instrument)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            if(identifierService.check(params.identifier))
            {
                if(params.structure)
                {
                    if(params.structure.startsWith("@"))
                    {
                        def instrumentRef = Instrument.findByIdentifier(params.structure.substring(1))
                        if(!instrumentRef)
                        {
                            instrumentRef = Instrument.findByPublicIdentifier(params.structure.substring(1))
                        }
                        if(instrumentRef)
                        {
                            def instrument = new Instrument()
                            instrument.identifier = params.identifier
                            instrument.type = instrumentRef.type
                            instrument.title = params.title
                            instrument.description = params.description
                            instrument.structure = instrumentRef.structure
                            // Finally we generate a public identifier for the instrument
                            String publicID = common.Utils.generatePublicIdentifier()
                            while(Instrument.findByPublicIdentifier(publicID))
                            {
                                publicID = common.Utils.generatePublicIdentifier()
                            }
                            instrument.publicIdentifier = publicID
                            instrument.save()
                            if(instrument.hasErrors())
                            {
                                instrument.delete()
                                response.status = 500
                                render(text:"<error>"  + instrument.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                            }
                            else
                            {
                                //render instrument as XML
                                render instrument as XML
                            }
                        }
                        else
                        {
                            response.status = 500
                            def errorMsg = "Instrument " + params.structure.substring(1) + " does not exist"
                            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                        }
                    }
                }
                else
                {
                    if(params.type == null)
                    {
                        def instrument = new Instrument()
                        instrument.identifier = params.identifier
                        instrument.title = params.title
                        instrument.description = params.description
                        // Finally we generate a public identifier for the instrument
                        String publicID = common.Utils.generatePublicIdentifier()
                        while(Instrument.findByPublicIdentifier(publicID))
                        {
                            publicID = common.Utils.generatePublicIdentifier()
                        }
                        instrument.publicIdentifier = publicID
                        instrument.save()
                        if(instrument.hasErrors())
                        {
                            instrument.delete()
                            response.status = 500
                            render(text:"<error>"  + instrument.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                        }
                        else
                        {
                            render instrument as XML
                        }
                    }
                    else
                    {
                        if(params.type.equalsIgnoreCase("mix"))
                        {
                            if(params.instruments)
                            {
                                def instruments = params.instruments.split("###")
                                String structure = '<mt:MixTool xmlns:mt="http://avanza.uca.es/assessmentservice/mix"' +
                                                    '\nxmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                                    '\nxsi:schemaLocation="http://avanza.uca.es/assessmentservice/mix http://avanza.uca.es/assessmentservice/MixTool.xsd"' +
                                                    '\nname="MixTool0" instruments="' + instruments.length + '">\n';
                                for(int i = 0; i < instruments.length; i++)
                                {
                                    def aux = Instrument.findByIdentifier(instruments[i].trim())
                                    if(!aux)
                                    {
                                        aux = Instrument.findByPublicIdentifier(instruments[i].trim())
                                    }
                                    if(aux.structure)
                                    {
                                        structure += common.Utils.toXmlChild(aux.structure) + "\n"
                                    }
                                }
                                structure += "</mt:MixTool>"
                                def instrument = new Instrument()
                                instrument.identifier = params.identifier
                                instrument.type = params.type
                                instrument.title = params.title
                                instrument.description = params.description
                                instrument.structure = structure
                                // Finally we generate a public identifier for the instrument
                                String publicID = common.Utils.generatePublicIdentifier()
                                while(Instrument.findByPublicIdentifier(publicID))
                                {
                                    publicID = common.Utils.generatePublicIdentifier()
                                }
                                instrument.publicIdentifier = publicID
                                instrument.save()
                                if(instrument.hasErrors())
                                {
                                    instrument.delete()
                                    response.status = 500
                                    //render instrument.errors as XML
                                    render(text:"<error>"  + instrument.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                                }
                                else
                                {
                                    //render instrument as XML
                                    render instrument as XML
                                }
                            }
                            else
                            {
                                def errorMsg = "To create a mix instrument you have to provide a list of instruments in the http pettition like:\n" +
                                "<instruments><instrument>abc6987698769876976</instrument><instrument>9870987asdfa</instrument>"
                                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                            }
                        }
                        else
                        {
                            def instrument = new Instrument()
                            instrument.identifier = params.identifier
                            instrument.type = params.type
                            instrument.title = params.title
                            instrument.description = params.description
                            instrument.structure = params.structure
                            // Finally we generate a public identifier for the instrument
                            String publicID = common.Utils.generatePublicIdentifier()
                            while(Instrument.findByPublicIdentifier(publicID))
                            {
                                publicID = common.Utils.generatePublicIdentifier()
                            }
                            instrument.publicIdentifier = publicID
                            instrument.save()
                            if(instrument.hasErrors())
                            {
                                println "ERRORES en el instrumento"
                                instrument.delete()
                                response.status = 500
                                //render instrument.errors as XML
                                render(text:"<error>" + instrument.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                            }
                            else
                            {
                                // proceed to show the instruments editor page
                                render instrument as XML
                            }
                        }
                    }
                }
            }
            else
            {
                def errorMsg = "The identifier " + params.identifier + " is not valid\n" +
                "An identifier has to be formed by a server id and the instrument id\n" +
                "The server id is provided by the service and the instrument id has to be\n" +
                "alphanumeric and equal or greater than 15"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private open(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To open an existing instrument you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            if(instrument)
            {
                // If the instrument has been already edited
                def call
                def type
                if(instrument.structure)
                {
                    call = "open"
                }
                // If the structure of the instrument is blank
                else
                {
                    call = "create"
                    type = instrument.type // If the instrument is blank but has a type we have to pass it
                }
                def aparams = "controller=instrument&call=" + call + "&identifier=" + params.identifier
                if(type)
                {
                    aparams += "&type=" + type
                }
                if(params.url)
                {
                    aparams += "&url=" + URLEncoder.encode(params.url)//common.Utils.codifyURL(params.url)
                }
                if(params.lang)
                {
                    aparams += "&lang=" + params.lang
                }
                // Establecemos los atributos
                request.setAttribute("aparams", aparams)
                render(view:"Instrument")
            }
            else
            {
                response.status = 500
                def errorMsg = "The instrument " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private get(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To get an existing instrument you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)" +
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            boolean isPublic = false // Indicates if the instrument has been obtained through the public identifier
            if(!instrument)
            {
                isPublic = true
                instrument = Instrument.findByPublicIdentifier(params.identifier)
            }
            if(instrument && !isPublic)
            {
                render instrument as XML
            }
            else if(instrument && isPublic)
            {
                // We create an auxiliar instrument definition without the private identifier
                def publicInstrument = new Instrument()
                publicInstrument.title = instrument.title
                publicInstrument.description = instrument.description
                publicInstrument.type = instrument.type
                publicInstrument.structure = instrument.structure
                render publicInstrument as XML
            }
            else
            {
                response.status = 500
                def errorMsg = "The instrument " + params.identifier + " does not exist"
                render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private delete(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To delete an existing instrument you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)" +
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            if(instrument)
            {
                instrument.delete()
                render(text:"<success>Instrument deleted</success>", contentType:"text/xml", encoding:"UTF-8")
            }
            else
            {
                response.status = 500
                def errorMsg = "The instrument " + params.identifier + " does not exist"
                render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private update(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To update an instrument you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)\n"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            if(instrument)
            {
                // Save the new attributes of the instrument
                instrument.properties = params.instrument
                if(instrument.save())
                {
                    render instrument as XML
                }
                else
                {
                    response.status = 500
                    render(text:"<error>"  + instrument.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
            }
            else
            {
                response.status = 500
                def errorMsg = "The instrument " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private save(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null ||
        params.structure == null)
        {
            response.status = 500
            def errorMsg = "To save an instrument you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)\n" +
            "->structure (the new XML of the instrument)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            if(instrument)
            {
                // Save the new attributes of the instrument
                instrument.structure = params.structure
                if(params.type)
                {
                    instrument.type = params.type
                }
                if(params.title)
                {
                    instrument.title = params.title
                }
                if(params.descripction)
                {
                    instrument.description = params.description
                }
                instrument.save()
                // Check if the instrument has errors
                if(instrument.hasErrors())
                {
                    instrument.delete()
                    response.status = 500
                    render(text:"<error>"  + instrument.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
                else
                {
                    render instrument as XML
                }
            }
            else
            {
                response.status = 500
                def errorMsg = "The instrument " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private view(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To view an existing instrument you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            if(!instrument)
            {
                instrument = Instrument.findByPublicIdentifier(params.identifier)
            }
            if(instrument)
            {
                if(instrument.structure)
                {
                    //redirect(uri:"/AssessmentService2Interface.swf?controller=instrument&call=view&identifier=" + params.identifier + "&lang=" + params.lang)
                    def aparams = "controller=instrument&call=view&identifier=" + params.identifier
                    if(params.lang)
                    {
                        aparams += "&lang=" + params.lang
                    }
                    // Establecemos los atributos
                    request.setAttribute("aparams", aparams)
                    // Redirigimos a la vista
                    render(view:"Instrument")
                }
                else
                {
                    response.status = 500
                    def errorMsg = "The instrument is empty, open and edit it"
                    render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
            }
            else
            {
                response.status = 500
                def errorMsg = "The instrument " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private export(params)
    {
        if(params.identifier == null)
        {
            String msg =
            'ERROR: To export an instrument you have to provide the next params in the http petition:\n' +
            'identifier (identifier of the instrument previously created)\n'
            render(text:"<error>" + msg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def instrument = Instrument.findByIdentifier(params.identifier)
            if(!instrument)
            {
                instrument = Instrument.findByPublicIdentifier(params.identifier)
            }
            if(instrument)
            {
                println instrument.structure
                render(text:instrument.structure, contentType:"text/xml", encoding:"UTF-8")
            }
            else
            {
                response.status = 500
                def errorMsg = 'ERROR: The instrument ' + params.identifier + ' does not exist\n'
                render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private read(request)
    {
        boolean fileAttached = false
        Iterator itr = request.getFileNames()
        while(itr.hasNext())
        {
            fileAttached = true
            render(text:request.getFile(itr.next()).inputStream.text, contentType:"text/xml", encoding:"UTF-8")
        }
        if(!fileAttached)
        {
            response.status = 500
            def errorMsg = 'ERROR: No file has been attached\n'
            render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
    }
}
