package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.xml.XMLNode;
	import mixta.HerramientaMixta;
	import mx.collections.ArrayCollection;
	
	/**
	 * Clase genércia parser, implementa los métodos generales de los parser relativos 
	 * a cada instrumento de la herramienta
	 */
	public class Parser extends EventDispatcher
	{
		public var instrumento:InstrumentoEvaluacion = null;
		
		public function Parser()
		{
			super();
		}
		
		/**
		 * Lee un un instrumento de evaluación desde código XML y la instancia en el objeto padre pasado
		 * como parámetro
		 */
		public function parse(xml:XMLNode, padre:DisplayObjectContainer):void
		{
			if(padre is VentanaGenerica)
			{
				(padre as VentanaGenerica).anyadirInstrumento(instrumento);
			}
			else if(padre is HerramientaMixta)
			{
				(padre as HerramientaMixta).setInstrumento(instrumento, true);
			}
		}
		
		/**
		 * Devuelve en un array de 3 niveles los atributos seleccionados para cada subdimensión
		 * lv1 (Dimensiones + Valoración global)
		 * -> lv2 (Subdimeniones + Valoraciones dimensiones)
		 * ->-> lv3 (Atributos: indice + comentarios)
		 */
		public function getArrayDefinition(xml:XMLNode):ArrayCollection
		{
			return new ArrayCollection();
		}
	}
}