/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package common;

import org.hsqldb.Server;

/**
 *
 * @author Alvar
 */
public class Utils {

    public static boolean checkIdentifier(String identifier)
    {
        boolean letters = false;
        boolean digits = false;
        for(int i = 0; i < identifier.length(); i++)
        {
            if(Character.isDigit(identifier.charAt(i)))
            {
                digits = true;
            }
            else if(Character.isLetter(identifier.charAt(i)))
            {
                letters = true;
            }
        }
        return letters && digits && identifier.length() >= 15;
    }

    public static String generateServerID()
    {
        char[] characters = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h',
        'i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E',
        'F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        String serverID = "1D";
        int idlength = (int)(Math.random()*20) + 15;
        for(int i = 0; i < idlength; i++)
        {
            serverID += characters[(int)(Math.random()*5000)%(characters.length)];
        }
        serverID += "_";
        return serverID;
    }

    public static String generatePublicIdentifier()
    {
        char[] characters = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h',
        'i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E',
        'F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        String publicID = "public1D";
        int idlength = (int)(Math.random()*20) + 15;
        for(int i = 0; i < idlength; i++)
        {
            publicID += characters[(int)(Math.random()*5000)%(characters.length)];
        }
        return publicID;
    }

    public static String toXmlChild(String xml)
    {
        xml = xml.replaceAll("\\w*:ControlList", "ControlList");
        xml = xml.replaceAll("\\w*:EvaluationSet", "EvaluationSet");
        xml = xml.replaceAll("\\w*:ControlListEvaluationSet", "ControlListEvaluationSet");
        xml = xml.replaceAll("\\w*:Rubric", "Rubric");
        xml = xml.replaceAll("\\w*:SemanticDifferential", "SemanticDifferential");
        xml = xml.replaceAll("\\w*:DecisionMatrix", "DecisionMatrix");
        xml = xml.replaceAll("\\w*:MixTool", "MixTool");
        xml = xml.replaceAll("xmlns:.*[\"|\'].*[\"|\']", "");
        xml = xml.replaceAll("xsi:.*[\"|\'].*[\"|\']", "");
        xml = xml.replaceAll("<\\?.*\\?>", "");
        return xml;
    }

    public static String codifyURL(String url)
    {
        url = url.replace("/","%2F");
        url = url.replace(":","%3A");
        url = url.replace("?","%3F");
        url = url.replace("=","%3D");
        url = url.replace("&","%26");
        System.out.print(url);
        return url;
    }
}
