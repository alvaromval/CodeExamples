class Instrument {

    String identifier // Secure ID for the instrument
    String title
    String description
    String type // Rubric, value list, control list, value list + control list, decision matrix
    String structure // XML structure of the instrument
    String publicIdentifier // Public identifier for the instrument

    static mapping = {
        columns {
            structure(type:'text')
        }
    }

    static constraints = {
        //identifier(unique:true)
        identifier(unique:true,
            validator: { val ->
                return common.Utils.checkIdentifier(val)
        })
        title(nullable:true)
        description(nullable:true)
        structure(nullable:true, maxsize:10000)
        type(nullable:true, inList:['rubric', 'value_list', 'control_list', 'control_list_value_list', 'semantic_differential', 'decision_matrix', 'mix'])
        publicIdentifier(unique:true)
    }
}
