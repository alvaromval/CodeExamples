package parser
{
	import diferencialSemantico.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.xml.XMLNode;
	
	import mx.controls.Alert;
	
	/**
	 * Parser correspondiente al instrumento Diferencial semántico
	 */
	public class ParserSemanticDifferential extends Parser
	{
		public function ParserSemanticDifferential()
		{
			super();
		}

		/**
		 * Lee un diferencial semántico desde código XML y lo instancia en el editor principal
		 */
		public override function parse(xmlDS:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento diferencial semántico y lo añadimos a la herramienta
 			var ds:DiferencialSemantico = new DiferencialSemantico();
			super.instrumento = ds;
			super.parse(xmlDS, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlDS.nodeName.search(/\w*:SemanticDifferential/) != -1 || xmlDS.nodeName == "SemanticDifferential")
				{
					ds.setName(xmlDS.attributes.name);
					ds.setNumAtributos(parseInt(xmlDS.attributes.attributes));
					ds.setNumValores(parseInt(xmlDS.attributes.values));
					if(xmlDS.attributes.percentage)
					{
						ds.setPorcentaje(xmlDS.attributes.percentage);
					}
					// Ahora recorremos los valores del diferencial semántico
					var elementos:Array = xmlDS.childNodes;
					// Variable auxiliar de porcentaje para los atributos (comprueba si ha sido bien asignado)
					var porcentajeAtributos:int = 0;
					for(var i:int = 0; i < elementos.length; i++)
					{
						var elemento:XMLNode = elementos[i] as XMLNode;
						// Comprobamos si el nodo es la descripción del instrumento
						if(elemento.nodeName == "Description")
						{
							ds.setDescripcion(elemento.firstChild.toString());	
						}
						// Si leemos los valores
						if(elemento.nodeName == "Values")
						{
							// Establecemos los valores
							ds.setValores(ds.getNumValores());
						}
						// Si leemos un atributo
						else if(elemento.nodeName == "Attribute")
						{
							// Creamos el objeto atributo, establecemos sus atributos y lo añadimos
							var atributo:Atributo = new Atributo();
							ds.addAtributo(atributo);
							atributo.setNameN(elemento.attributes.nameN);
							atributo.setNameP(elemento.attributes.nameP);
							atributo.setPorcentaje(elemento.attributes.percentage);
							atributo.selectValue(parseInt(elemento.firstChild.toString()));
							porcentajeAtributos += parseInt(elemento.attributes.percentage);
						}
					}
					// Comprobamos si el porcentaje en los atributos ha sido bien asignado, si no lo ha sido establecemos
					ds.setPorcentajesPorDefecto(porcentajeAtributos);
				}
				ds.actualizarNota();
				// Establecemos la vista de evaluación del instrumento si es el caso
				if(padre is VentanaEvaluacion || padre is VentanaConsulta)
				{
					ds.setVistaEvaluacion();
				}
				// Al terminar de cargar, cargamos los fallos y advertencias del instrumento
				if(padre is VentanaGenerica)
				{
					(padre as VentanaGenerica).setEstadoInstrumento();
				}
	     	}
	      	catch(error:Error)
	    	{
	    		padre.removeChild(ds.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
	}
}