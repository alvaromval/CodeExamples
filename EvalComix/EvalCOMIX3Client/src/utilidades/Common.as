package utilidades
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	
	import mixta.HerramientaMixta;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
		
	public class Common
	{

		public function Common()
		{
		}
		
		public static function parse_int(num:String):int
		{
			if(num)
			{
				return parseInt(num);
			}	
			else
			{
				return -1;
			}
		}
		
		public static function tabs(nivel:int):String
		{
			var cadena:String = "";
			for(var i:int = 0; i < nivel; i++)
			{
				cadena += "\t";
			}
			return cadena;
		}
		
		public static function redondear(numero:Number):int
		{
			var aux:int = numero;
			if((numero - aux) >= 0.5)
			{
				return aux + 1;
			}
			else
			{
				return aux;
			}
		}
		
		// Función que elimina los espacios al principio y al final de una cadena
		public static function trim(cadena:String):String
		{
			if(cadena != null && cadena != "")
			{
				// Eliminamos los espacios al principio
				while(cadena.search(" ") == 0)
				{
					cadena = cadena.substring(1, cadena.length);
				}
				while(cadena.search("\t") == 0)
				{
					cadena = cadena.substring(1, cadena.length);
				}
				if(cadena != null && cadena != "")
				{
					// Eliminamos los espacios al final
					while(cadena.search(" ") == (cadena.length - 1))
					{
						cadena = cadena.substring(0, cadena.length - 1);
					}
					while(cadena.search("\t") == (cadena.length - 1))
					{
						cadena = cadena.substring(0, cadena.length - 1);
					}
				}
			}
			return cadena;
		}
		
		/**
		 * Función que elimina los &gt, &lt y &quot obtenidos desde html y los sustituye por >, < y "
		 */
		public static function transformHtmlText(texto:String):String
		{
			if(texto == null)
			{
				return texto;
			}
			/*
			// Primero &gt por >
			while(texto.search(";567;") != -1)
			{
				texto = texto.replace(";567;", ">");
			}
			// Segundo &lt por <
			while(texto.search(";321;") != -1)
			{
				texto = texto.replace(";321;", "<");
			}
			while(texto.search(";876;") != -1)
			{
				texto = texto.replace(";876;", "/");
			}
			// Segundo &quot por "
			while(texto.search(";456;") != -1)
			{
				texto = texto.replace(";456;", '"');
			}
			while(texto.search(";789;") != -1)
			{
				texto = texto.replace(";789;", '=');
			}
			*/
			// Primero &gt por >
			while(texto.search("&#62;") != -1)
			{
				texto = texto.replace("&#62;", ">");
			}
			// Segundo &lt por <
			while(texto.search("&#60;") != -1)
			{
				texto = texto.replace("&#60;", "<");
			}
			/*while(texto.search(";876;") != -1)
			{
				texto = texto.replace(";876;", "/");
			}*/
			// Segundo &quot por "
			while(texto.search("&#34;") != -1)
			{
				texto = texto.replace("&#34;", '"');
			}
			/*while(texto.search(";789;") != -1)
			{
				texto = texto.replace(";789;", '=');
			}*/
			while(texto.search("&#38;") != -1)
			{
				texto = texto.replace("&#38;", '&');
			}
			return texto;
		}
		
		/*public static function comprobarTipoInstrumento(tipo:String):Boolean
		{
			tipo = tipo.toLowerCase();
			return (tipo == Constants.ESCALA_VALORACION || tipo == Constants.LISTA_CONTROL ||
			tipo == Constants.LISTA_CONTROL_ESCALA_VALORACION || tipo == Constants.MATRIZ_DECISION ||
			tipo == Constants.MIXTA || tipo == Constants.RUBRICA);	
		}*/
		
		public static function crearInstrumentoPorNombre(nombre:String):InstrumentoEvaluacion
		{
			for(var i:int = 0; i < Constants.instrumentos.length; i++)
			{
				if(nombre == Constants.instrumentos[i][1] 
				|| nombre == ResourceManager.getInstance().getString("myBundle", Constants.instrumentos[i][1]))
				{
					var miClase:Class = Class(getDefinitionByName(Constants.instrumentos[i][0]));
					return new miClase() as InstrumentoEvaluacion;
				}
			}
			return null;
		}
		
		public static function comprobarTipoInstrumento(tipo:String):Boolean
		{
			for(var i:int = 0; i < Constants.instrumentos.length; i++)
			{
				if(Constants.instrumentos[i][0] == tipo)
				{
					return true;
				}
			}
			return false;
		}
		
		public static function crearInstrumento(tipo:String, padre:DisplayObjectContainer):void
		{
			/*if(tipo == Constants.MIXTA)
			{
				if(padre is VentanaGenerica)
				{
					var vcm:VentanaCreacionHMixta = VentanaCreacionHMixta(PopUpManager.createPopUp(Application.application.container, VentanaCreacionHMixta, true));
					vcm.inicializar(padre as VentanaGenerica);
					PopUpManager.centerPopUp(vcm);
				}
			}
			else*/ 
			if(comprobarTipoInstrumento(tipo))
			{
				if(padre is VentanaGenerica)
				{
					var miClase:Class = Class(getDefinitionByName(tipo));
					(padre as VentanaGenerica).anyadirInstrumento(new miClase() as InstrumentoEvaluacion);
				}
				else if(padre is HerramientaMixta)
				{
					(padre as HerramientaMixta).setInstrumento(getDefinitionByName(tipo) as InstrumentoEvaluacion);
				}
			}
		}
	}
}