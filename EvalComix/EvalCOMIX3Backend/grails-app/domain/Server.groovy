class Server {

    String identifier // An identifier for each server using the service

    static constraints = {
        identifier(unique:true)
    }
}
