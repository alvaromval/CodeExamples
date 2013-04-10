package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLNode;
	import listaControl.*;
	import mixta.HerramientaMixta;
	import mx.controls.Alert;
	import utilidades.Constants;
	
	/**
	 * Parser correspondiente al instrumento Herramienta Mixta
	 */
	public class ParserMixTool extends Parser
	{
		public function ParserMixTool()
		{
			super();
		}

		/**
		 * Lee una herramienta mixta desde código XML y la instancia en el editor principal
		 */
		public override function parse(xmlHM:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento herramienta mixta y lo añadimos a la herramienta
 			var hm:HerramientaMixta = new HerramientaMixta();
			super.instrumento = hm;
			super.parse(xmlHM, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlHM.nodeName.search(/\w*:MixTool/) != -1 || xmlHM.nodeName == "MixTool")
				{
					hm.setName(xmlHM.attributes.name);
					if(xmlHM.attributes.percentage)
					{
						hm.setPorcentaje(parseInt(xmlHM.attributes.percentage));
					}
					var instrumentos:Array = xmlHM.childNodes;
					// Recorremos los instrumentos de la herramienta mixta y creamos un parser adecuado a cada uno
					for(var i:int = 0; i < instrumentos.length; i++)
					{
						if(instrumentos[i] is XMLNode)
						{
							var xmlInstrumento:XMLNode = instrumentos[i] as XMLNode;
							var ps:Parser;
							// Comprobamos si el nodo es la descripción del instrumento
							if(xmlInstrumento.nodeName == "Description")
							{
								hm.setDescripcion(xmlInstrumento.firstChild.toString());	
							}
							else
							{
								for(var j:int = 0; j < Constants.instrumentos.length; j++)
								{
									if(xmlInstrumento.nodeName == Constants.instrumentos[j][3])
									{
										var miClase:Class = Class(getDefinitionByName(Constants.instrumentos[j][2]));
										ps = new miClase() as Parser;
										// Parseamos el instrumento y lo añadimos a la herramienta mixta
										ps.parse(xmlInstrumento, hm);
									}
								}
							}
							/*
							if(xmlInstrumento.nodeName == "Rubric")
							{
								ps = new ParserRubric();
								ps.parse(xmlInstrumento, hm);
							}
							else if(xmlInstrumento.nodeName == "ControlList")
							{
								ps = new ParserControlList();
								ps.parse(xmlInstrumento, hm);
							}
							else if(xmlInstrumento.nodeName == "EvaluationSet")
							{
								ps = new ParserEvaluationSet();
								ps.parse(xmlInstrumento, hm);
							}
							else if(xmlInstrumento.nodeName == "ControlListEvaluationSet")
							{
								ps = new ParserControlListEvaluationSet();
								ps.parse(xmlInstrumento, hm);
							}
							else if(xmlInstrumento.nodeName == "DecisionMatrix")
							{
								ps = new ParserDecisionMatrix();
								ps.parse(xmlInstrumento, hm);
							}
							else if(xmlInstrumento.nodeName == "SemanticDifferential")
							{
								ps = new ParserSemanticDifferential();
								ps.parse(xmlInstrumento, hm);
							}
							else if(xmlInstrumento.nodeName == "MixTool")
							{
								ps = new ParserMixTool();
								ps.parse(xmlInstrumento, hm);
							}
							*/
						}
					}
				}
				
				// Comprobamos si los porcentajes de los instrumentos contenidos son correctos
				var porcentajeInstrumentos:int = 0;
				for(var i:int = 0; i < hm.getInstrumentos().length; i++)
				{
					porcentajeInstrumentos += (hm.getInstrumentos().getItemAt(i) as InstrumentoEvaluacion).getPorcentaje();		
				}
				// Establecemos los porcentajes por defecto, en el caso de que no sean correctos
				hm.setPorcentajesPorDefecto(porcentajeInstrumentos);
				
				// Actualizamos la nota
				hm.actualizarNota();
				
				// Establecemos la vista de evaluación del instrumento si es el caso
				if(padre is VentanaEvaluacion || padre is VentanaConsulta)
				{
					hm.setVistaEvaluacion();
				}
				
				// Al terminar de cargar, cargamos los fallos y advertencias del instrumento
				if(padre is VentanaGenerica)
				{
					(padre as VentanaGenerica).setEstadoInstrumento();
				}
	     	}
	      	catch(error:Error)
	    	{
	    		padre.removeChild(hm.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
	}
}