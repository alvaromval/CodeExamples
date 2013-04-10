package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import utilidades.Constants;
	
	/**
	 * Clase controladora de los parser, lee el XML y redirige la petición al parser adecuado
	 */
	public class ControladorParser
	{
		public function ControladorParser()
		{
		}

		/**
		 * Método que crea un parser adecuado en función del XML recibido, leyendo su nodo padre
		 * El parser creado parsea el XML transformándolo en el instrumento adecuado e instanciándolo en la 
		 * herramienta
		 */
		public function parse(text:String, padre:DisplayObjectContainer):void
		{
			// Comprobamos que tipo de objeto vamos a abrir
			try
			{
				var xml:XMLDocument = new XMLDocument();
				xml.parseXML(text);
				xml.ignoreWhite = false;
				var xmlNode:XMLNode = xml.firstChild;
				var i:int = 1;
				while(xmlNode.nodeName == null && xmlNode.childNodes.length < i)
				{
					if((xml.childNodes[i] as XMLNode).nodeName != null)
					{
						xmlNode = xml.childNodes[i];
					}
					i++;
				}
				var tipoInstrumento:String = xmlNode.nodeName;
				// Creamos el objeto parser adecuado a partir de la definición de clase
				var ps:Parser;
				for(var i:int = 0; i < Constants.instrumentos.length; i++)
				{
					if(xmlNode.nodeName == Constants.instrumentos[i][3] || xmlNode.nodeName.search("\w*:"+Constants.instrumentos[i][3]) != -1)
					{
						var miClase:Class = Class(getDefinitionByName(Constants.instrumentos[i][2]));
						ps = new miClase() as Parser;
						ps.parse(xmlNode, padre);
						return;
					}
				}
				if(ps == null)
				{
				 	Alert.show("Incompatible file", "Error");
				}
				/*if(xmlNode.nodeName == "Rubric" || xmlNode.nodeName.search(/\w*:Rubric/) != -1)
				{
					ps = new ParserRubric();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else if(xmlNode.nodeName == "ControlListEvaluationSet" || xmlNode.nodeName.search(/\w*:ControlListEvaluationSet/) != -1)
				{
					ps = new ParserControlListEvaluationSet();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else if(xmlNode.nodeName == "ControlList" || xmlNode.nodeName.search(/\w*:ControlList/) != -1)
				{
					ps = new ParserControlList();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else if(xmlNode.nodeName == "EvaluationSet" || xmlNode.nodeName.search(/\w*:EvaluationSet/) != -1)
				{
					ps = new ParserEvaluationSet();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else if(xmlNode.nodeName == "DecisionMatrix" || xmlNode.nodeName.search(/\w*:DecisionMatrix/) != -1)
				{
					ps = new ParserDecisionMatrix();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else if(xmlNode.nodeName == "SemanticDifferential" || xmlNode.nodeName.search(/\w*:SemanticDifferential/) != -1)
				{
					ps = new ParserSemanticDifferential();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else if(xmlNode.nodeName == "MixTool" || xmlNode.nodeName.search(/\w*:MixTool/) != -1)
				{
					ps = new ParserMixTool();
					//ps.parse(xmlNode, padre, fg);
					ps.parse(xmlNode, padre);
				}
				else
				{
					Alert.show("Incompatible file", "Error");
				}*/
			}
	      	catch(error:Error)
	    	{
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
		
		/**
		 * Crea el parser adecuado según el instrumento recibido como XML
		 * El parser devuelve en un array de 3 niveles los atributos seleccionados para cada subdimensión
		 * lv1 (Dimensiones + Valoración global)
		 * -> lv2 (Subdimeniones + Valoraciones dimensiones)
		 * ->-> lv3 (Atributos: indice + comentarios)
		 */
		public function getArrayDefinition(text:String):ArrayCollection
		{
			// Comprobamos que tipo de objeto vamos a abrir
			try
			{
				var xml:XMLDocument = new XMLDocument();
				xml.parseXML(text);
				xml.ignoreWhite = false;
				var xmlNode:XMLNode = xml.firstChild;
				var i:int = 1;
				while(xmlNode.nodeName == null && xmlNode.childNodes.length < i)
				{
					if((xml.childNodes[i] as XMLNode).nodeName != null)
					{
						xmlNode = xml.childNodes[i];
					}
					i++;
				}
				var tipoInstrumento:String = xmlNode.nodeName;
				// Creamos el objeto parser adecuado a partir de la definición de clase
				var ps:Parser;
				for(var i:int = 0; i < Constants.instrumentos.length; i++)
				{
					if(xmlNode.nodeName == Constants.instrumentos[i][3] || xmlNode.nodeName.search("\w*:"+Constants.instrumentos[i][3]) != -1)
					{
						var miClase:Class = Class(getDefinitionByName(Constants.instrumentos[i][2]));
						ps = new miClase() as Parser;
						return ps.getArrayDefinition(xmlNode);
					}
				}
				if(ps == null)
				{
				 	Alert.show("Incompatible file", "Error");
				}
				/*if(xmlNode.nodeName == "Rubric" || xmlNode.nodeName.search(/\w*:Rubric/) != -1)
				{
					ps = new ParserRubric();
					return ps.getArrayDefinition(xmlNode);
				}
				else if(xmlNode.nodeName == "ControlListEvaluationSet" || xmlNode.nodeName.search(/\w*:ControlListEvaluationSet/) != -1)
				{
					ps = new ParserControlListEvaluationSet();
					return ps.getArrayDefinition(xmlNode);
				}
				else if(xmlNode.nodeName == "ControlList" || xmlNode.nodeName.search(/\w*:ControlList/) != -1)
				{
					ps = new ParserControlList();
					return ps.getArrayDefinition(xmlNode);
				}
				else if(xmlNode.nodeName == "EvaluationSet" || xmlNode.nodeName.search(/\w*:EvaluationSet/) != -1)
				{
					ps = new ParserEvaluationSet();
					return ps.getArrayDefinition(xmlNode);
				}
				else if(xmlNode.nodeName == "DecisionMatrix" || xmlNode.nodeName.search(/\w*:DecisionMatrix/) != -1)
				{
					ps = new ParserDecisionMatrix();
					return ps.getArrayDefinition(xmlNode);
				}
				else if(xmlNode.nodeName == "SemanticDifferential" || xmlNode.nodeName.search(/\w*:SemanticDifferential/) != -1)
				{
					ps = new ParserSemanticDifferential();
					return ps.getArrayDefinition(xmlNode);
				}
				else if(xmlNode.nodeName == "MixTool" || xmlNode.nodeName.search(/\w*:MixTool/) != -1)
				{
					ps = new ParserMixTool();
					return ps.getArrayDefinition(xmlNode);
				}
				else
				{
					Alert.show("Incompatible file", "Error");
				}*/
			}
	      	catch(error:Error)
	    	{
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
			return null;
		}
	}
}