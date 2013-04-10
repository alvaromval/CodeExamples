class Assessment {

    String identifier // Secure ID for the assessment
    String instrumentIdentifier // ID of an instrument
    String structure // XML structure of the assessment
    int grade = 0 // Grade of the assessment
    String publicIdentifier // Public identifier of the assessment

    static mapping = {
        columns {
            structure(type:'text')
        }
    }

    static constraints = {
        identifier(unique:true,
            validator: { val ->
                // Ensure that the date of birth is before the enrollment date
                return common.Utils.checkIdentifier(val)
        })
        structure(nullable:true, maxsize:10000)
        publicIdentifier(unique:true)
    }
}