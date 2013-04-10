import grails.converters.XML

class AssessmentController {

    def index = {
    }

    def identifierService

    // REST INTERFACE
    def rest =
    {
        switch(request.method)
        {
            case 'GET':
                open(params)
                break;
            case 'POST':
                create(params.assessment)
                break;
            case 'PUT':
                update(params)
                break;
            case 'DELETE':
                delete(params)
                break;
        }
    }

    //WEB SERVICE INTERFACE
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

    def grade =
    {
        grade(params)
    }

    def export =
    {
        export(params)
    }

    def read =
    {
        read(request)
    }

    def coassessment =
    {
        coassessment(params)
    }



    // INTERFACE IMPLEMENTATION
    private create(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null ||
            params.instrumentIdentifier == null)
        {
            response.status = 500
            def errorMsg = "To create a new assessment you have to provide the next params in the http petition:\n" +
            "->identifier (a identifier for the new assessment)\n" +
            "->instrumentIdentifier (the identifier of the instrument to be used to assess)\n"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            // We check if the identifier is correct
            if(identifierService.check(params.identifier))
            {
                //Now we check if the instrument exists
                def instrument = Instrument.findByIdentifier(params.instrumentIdentifier)
                if(!instrument)
                {
                    instrument = Instrument.findByPublicIdentifier(params.instrumentIdentifier)
                }
                if(instrument)
                {
                    if(instrument.structure)
                    {
                        //If all is correct we create a blank assessment
                        def assessment = new Assessment()
                        assessment.identifier = params.identifier
                        assessment.instrumentIdentifier = params.instrumentIdentifier
                        assessment.structure = instrument.structure
                        assessment.grade = 0
                        // Finally we generate the public identifier for the assessment
                        String publicID = common.Utils.generatePublicIdentifier()
                        while(Assessment.findByPublicIdentifier(publicID))
                        {
                            publicID = common.Utils.generatePublicIdentifier()
                        }
                        assessment.publicIdentifier = publicID
                        assessment.save()
                        if(assessment.hasErrors())
                        {
                            response.status = 500
                            assessment.delete()
                            render(text:"<error>"  + assessment.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                        }
                        else
                        {
                            render assessment as XML
                            // proceed to show the assessments editor page
                            //redirect(uri:"/AssessmentService2Interface.swf?controller=assessment&call=create&identifier=" + params.identifier + "&instrumentIdentifier=" + params.instrumentIdentifier)
                        }
                    }
                    else
                    {
                        response.status = 500
                        def errorMsg = "The instrument " + params.instrumentIdentifier + " is not valid"
                        render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                    }
                }
                else
                {
                    response.status = 500
                    def errorMsg = "The instrument " + params.instrumentIdentifier + " does not exist"
                    render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
            }
            else
            {
                def errorMsg = "The identifier " + params.identifier + " is not valid\n" +
                "An identifier has to be formed by a server id and the assessment id\n" +
                "The server id is provided by the service and the assessment id has to be\n" +
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
            def errorMsg = "To open an assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the assessment)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            //Second we check if the assessment exists
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(assessment)
            {
                // procced to show the assessments editor page with the information of the assessment
                def aparams = "controller=assessment&call=open&identifier=" + params.identifier
                if(params.url)
                {
                    aparams += "&url=" + URLEncoder.encode(params.url)//common.Utils.codifyURL(params.url)
                }
                if(params.lang)
                {
                    aparams += "&lang=" + params.lang
                }
                request.setAttribute("aparams", aparams)
                render(view:"Assessment")
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private save(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To save an assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the instrument)\n" +
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(assessment)
            {
                // Save the new attributes of the instrument
                if(params.structure)
                {
                    assessment.structure = params.structure
                }
                if(params.grade)
                {
                    try
                    {
                        assessment.grade = Integer.parseInt(params.grade)
                    }
                    catch(NumberFormatException e)
                    {
                        response.status = 500
                        def errorMsg = "The grade has to be a numeric value"
                        render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                        return
                    }
                }
                assessment.save()
                // Check if the instrument has errors
                if(assessment.hasErrors())
                {
                    response.status = 500
                    render(text:"<error>"  + assessment.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
                else
                {
                    render assessment as XML
                }
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
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
            def errorMsg = "To open an assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the assessment)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            //Second we check if the assessment exists
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(!assessment)
            {
                assessment = Assessment.findByPublicIdentifier(params.identifier)
            }
            if(assessment)
            {
                //redirect(uri:"/AssessmentService2Interface.swf?controller=assessment&call=view&identifier=" + params.identifier + "&lang=" + params.lang)
                def aparams = "controller=assessment&call=view&identifier=" + params.identifier
                if(params.lang)
                {
                    aparams += "&lang=" + params.lang
                }
                request.setAttribute("aparams", aparams)
                render(view:"Assessment")
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private update(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To update an assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the assessment)\n"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(assessment)
            {
                // Save the new attributes of the instrument
                assessment.properties = params.assessment
                if(assessment.save())
                {
                    render assessment as XML
                }
                else
                {
                    response.status = 500
                    render(text:"<error>"  + assessment.errors + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
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
            def errorMsg = "To get an existing assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the assessment)" +
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def assessment = Assessment.findByIdentifier(params.identifier)
            boolean isPublic = false
            if(!assessment)
            {
                isPublic = true // This is because the assessment has been obtained through the public identifier
                assessment = Assessment.findByPublicIdentifier(params.identifier)
            }
            // If the assessment is obtained with the secure identifier
            if(assessment && !isPublic)
            {
                render assessment as XML
            }
            // If the assessment is obtained with the public identifier
            else if(assessment && isPublic)
            {
                // We create an auxiliar assessment without the identifier and we don't save it
                def publicAssessment = new Assessment()
                publicAssessment.structure = assessment.structure
                publicAssessment.grade = assessment.grade
                publicAssessment.publicIdentifier = assessment.publicIdentifier
                render publicAssessment as XML
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
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
            def errorMsg = "To delete an existing assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the assessment)" +
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(assessment)
            {
                assessment.delete()
                render(text:"<success>Assessment deleted</success>", contentType:"text/xml", encoding:"UTF-8")
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
                render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }

    private grade(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null)
        {
            response.status = 500
            def errorMsg = "To get the grade of an existing assessment you have to provide the next params in the http petition:\n" +
            "->identifier (the identifier of the assessment)" +
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(!assessment)
            {
                assessment = Assessment.findByPublicIdentifier(params.identifier)
            }
            if(assessment)
            {
                render(text:assessment.grade, contentType:"text/plain", encoding:"UTF-8")
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
                render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
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
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(assessment)
            {
                render(text:assessment.structure, contentType:"text/xml", encoding:"UTF-8")
            }
            else
            {
                response.status = 500
                def errorMsg = 'ERROR: The assessment ' + params.identifier + ' does not exist\n'
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
            render(text:"<structure>" + request.getFile(itr.next()).inputStream.text + "</strucrure>", contentType:"text/xml", encoding:"UTF-8")
        }
        if(!fileAttached)
        {
            response.status = 500
            def errorMsg = 'ERROR: No file has been attached\n'
            render(text:"<error>" + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
    }

    private coassessment(params)
    {
        // First we check if all the parameters are provided
        if(params.identifier == null || params.identifierReviewed == null)
        {
            response.status = 500
            def errorMsg = "To make a coassessment you have to provide the next params:\n" +
            "->identifier (the private identifier of your assessment)" +
            "->reviewedIdentifier (the public identifier of the assessment reviewed)"
            render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
        }
        else
        {
            //Second we check if the assessment exists
            def assessment = Assessment.findByIdentifier(params.identifier)
            if(assessment)
            {
                // Third, check if the assessment reviewed exists
                def assessmentReviewed = Assessment.findByPublicIdentifier(params.identifierReviewed)
                if(assessmentReviewed)
                {
                    // Finally, we check if both assessments share the same instrument
                    if(assessment.instrumentIdentifier.equals(assessmentReviewed.instrumentIdentifier))
                    {
                        // If all is correct we redirect to the co-assessment visual interface
                        def aparams = "controller=assessment&call=review&identifier=" + params.identifier + "&identifierReviewed=" + params.identifierReviewed
                        if(params.lang)
                        {
                            aparams += "&lang=" + params.lang
                        }
                        request.setAttribute("aparams", aparams)
                        render(view:"Assessment")
                    }
                    else
                    {
                        response.status = 500
                        def errorMsg = "The assessment and the assessment reviewed does not share the same structure"
                        render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                    }
                }
                else
                {
                    response.status = 500
                    def errorMsg = "The assessment " + params.reviewedIdentifier + " to be reviewed does not exist"
                    render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
                }
            }
            else
            {
                response.status = 500
                def errorMsg = "The assessment " + params.identifier + " does not exist"
                render(text:"<error>"  + errorMsg + "</error>", contentType:"text/xml", encoding:"UTF-8")
            }
        }
    }
}
