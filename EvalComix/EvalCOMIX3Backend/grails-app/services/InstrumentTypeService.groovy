class InstrumentTypeService {

    boolean transactional = true

    boolean check(String type)
    {
        type = type.toLowerCase()
        return type.equals("value_list") || type.equals("control_list") || type.equals("rubric") ||
        type.equals("control_list_value_list") ||
        type.equals("decision_matrix") || type.equals("mix") || type.equals("semantic_differential")
    }
}
