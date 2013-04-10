package parser
{
	import pruebaInstrumento.PruebaInstrumento;
	
	public class ParserPruebaInstrumento
	{
		public function ParserPruebaInstrumento()
		{
			super();
		}
		
		public override function parse(xmlPI:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento lista de control y lo añadimos a la 	//herramienta
			var pi:PruebaInstrumento = new PruebaInstrumento();
			super.instrumento = pi;
			super.parse(xmlLC, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlPI.nodeName.search(/\w*:TestInstrument/) != -1 || xmlPI.nodeName == "TestInstrument")
				{
					// Leemos los atributos name y percentage
					pi.setName(xmlPI.attributes.name);
					if(xmlPI.attributes.percentage)
					{
						pi.setPorcentaje(xmlPI.attributes.percentage);
					}
					// Obtenemos el valor seleccionado
					pi.setSeleccion(xmlPI.firstChild.toString());
					// Actualizamos la nota del instrumento
					pi.actualizarNota();
				}
			}
			catch(error:Error)
	    	{
	    		padre.removeChild(pi.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
}