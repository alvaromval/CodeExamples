package utilidades
{
	import flash.errors.IOError;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.xml.XMLDocument;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	public class EntradaSalida
	{
				
		private var buffer:String = null; // Buffer para guardado
		private var frDownloader:FileReference = null;
		private var fileReference:FileReference = null;
		private var ventana:VentanaGenerica = null;
		
		public function EntradaSalida(ventana:VentanaGenerica)
		{
			this.ventana = ventana;
		}
		
		public function exportar():void
        {
        	frDownloader = new FileReference();
        	var downloadURL:URLRequest = new URLRequest();
        	var variables:URLVariables = new URLVariables();
        	variables.identifier = ventana.getIdentificador();
        	//downloadURL.data = variables;
        	downloadURL.url = Constants.getURL_Export() + "/" + ventana.getIdentificador();
        	configureListenersDownloading(frDownloader);
        	frDownloader.download(downloadURL, ventana.getInstrumento().getName() + Constants.EXTENSION);
        }
        
        private function configureListenersDownloading(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.CANCEL, cancelHandler);
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            //dispatcher.addEventListener(Event.OPEN, openHandler);
            //dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    	}

        private function cancelHandler(event:Event):void {
            //Alert.show("Descarga cancelada");
        }

        private function completeHandler(event:Event):void {
            //Alert.show("Descarga completada");
            Alert.show(ResourceManager.getInstance().getString("myBundle", "export_complete"));
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            //Alert.show("Error en la escritura del fichero", "Error");
            Alert.show(ResourceManager.getInstance().getString("myBundle", "error_file_write"), ResourceManager.getInstance().getString("myBundle", "error"));
        }

        private function openHandler(event:Event):void {
            Alert.show("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            var file:FileReference = FileReference(event.target);
            Alert.show("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            Alert.show(ResourceManager.getInstance().getString("myBundle", "error_security"), ResourceManager.getInstance().getString("myBundle", "error"));
        }
        
        public function importar():void
		{
			try
    		{
				fileReference = new FileReference();
				var docFilter:FileFilter = new FileFilter("Assessment instrument files", "*.evx");
				configureListenersImportar(fileReference);
				fileReference.browse([docFilter]);
				
			}
			catch(error:IOError)
			{
				//Alert.show("Error en la escritura del fichero en el servidor", "Error");
				Alert.show(ResourceManager.getInstance().getString("myBundle", "error_file_write_server"), ResourceManager.getInstance().getString("myBundle", "error"))
			}
		}
		
		private function configureListenersImportar(dispatcher:IEventDispatcher) {
			dispatcher.addEventListener(Event.SELECT, seleccionarRecurso);
            dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, subidaCompletadaServidor);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, errorEscritura);
            dispatcher.addEventListener(Event.CANCEL, cancelImport);
		}
		
		private function seleccionarRecurso(event:Event):void
		{
			if(fileReference.size < 524288)
			{
				var uploadUrl:URLRequest = new URLRequest();
        		var variables:URLVariables = new URLVariables();
        		uploadUrl.url = Constants.getURL_Import();
    			fileReference.upload(uploadUrl);
			}
			else
			{
				//Alert.show("No se pueden subir cursos superiores a 512KB", "Error");
				Alert.show(ResourceManager.getInstance().getString("myBundle", "error_upload_size"), ResourceManager.getInstance().getString("myBundle", "error"));
			}
		}
		
		private function subidaCompletadaServidor(event:DataEvent):void
		{
        	// El resultado es un XML
			var response:String = event.data;
      		var xmlDoc:XMLDocument;
      		try
        	{
        		// Comprobamos si el resultado es un XML
         		xmlDoc = new XMLDocument(response);
         		// Procesamos el XML
                var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
                var resultObj:Object = decoder.decodeXML(xmlDoc);
            	// Si la operación se ha realizado correctamente
               	if(resultObj.error != null)
               	{
                	// El xml devuelve un mensaje de error
                	Alert.show(resultObj.error, ResourceManager.getInstance().getString("myBundle", "error"));
                }
                else
                {	
                	// Importamos en la ventana actual
                	ventana.setEstructura(response);
                	//Alert.show("Importación completada");
                }	
         	}
          	catch(error:Error)
        	{
        		//Alert.show("ERROR: the response data was not in valid XML format", "Error");
        		Alert.show(ResourceManager.getInstance().getString("myBundle", "error_response_format"), ResourceManager.getInstance().getString("myBundle", "error"));
       		}
		}
		
		private function manejadorImportar(event:ResultEvent):void
		{
			// El resultado es un XML
			var response:String = event.result.toString();
      		var xmlDoc:XMLDocument;
      		try
        	{
        		// Comprobamos si el resultado es un XML
         		xmlDoc = new XMLDocument(response);
         		// Procesamos el XML
                var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
                var resultObj:Object = decoder.decodeXML(xmlDoc);
            	// Rellenamos un array con los cursos
            	// Si la operación se ha realizado correctamente
                if(resultObj.structure != null)
                {	
                	// Importamos en la ventana actual
                	ventana.setEstructura(resultObj.structure);
                }	
               	else if(resultObj.error != null)
               	{
                	// El xml devuelve un mensaje de error
                	Alert.show(resultObj.error, ResourceManager.getInstance().getString("myBundle", "error"));
                }
         	}
          	catch(error:TypeError)
        	{
        		Alert.show(ResourceManager.getInstance().getString("myBundle", "error_response_format"), ResourceManager.getInstance().getString("myBundle", "error"));
       		}
		}
		
		private function errorEscritura(event:IOErrorEvent):void
		{
			Alert.show(ResourceManager.getInstance().getString("myBundle", "error_file_write_server"), ResourceManager.getInstance().getString("myBundle", "error"));
		}
		
		private function cancelImport(event:Event):void
		{
			if(this.ventana is VentanaImportacion)
			{
				// Debemos eliminar la ventana de la aplicación		
				Application.application.eliminarVentana();
				// Debemos volver a mostrar la ventana de selección
				var vs:VentanaSeleccion = VentanaSeleccion(PopUpManager.createPopUp(Application.application.container, VentanaSeleccion, true));
				vs.inicializar(Application.application.parameters.identifier);
				PopUpManager.centerPopUp(vs);
			}
		}
	}
}