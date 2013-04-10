class IdentifierService {

    boolean transactional = true

    boolean check(String identifier)
    {
        int serverIDlength = identifier.indexOf("_")+1
        if(serverIDlength != -1 && serverIDlength < identifier.length())
        {
            String serverID = identifier.substring(0, serverIDlength)
            println serverID
            if(Server.findByIdentifier(serverID))
            {
                String objectID = identifier.substring(serverIDlength)
                boolean letters = false
                boolean digits = false
                for(int i = 0; i < objectID.length(); i++)
                {
                    if(Character.isDigit(objectID.charAt(i)))
                    {
                        digits = true
                    }
                    else if(Character.isLetter(objectID.charAt(i)))
                    {
                        letters = true
                    }
                }
                return letters && digits && objectID.length() >= 15
            }
        }
        return false
    }
}
