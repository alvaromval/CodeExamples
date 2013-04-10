package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.xml.XMLNode;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import listaControl.*;
	
	/**
	 * Parser correspondiente al instrumento Lista de Control
	 */
	public class ParserControlList extends Parser
	{	
		public function ParserControlList()
		{
			super();
		}

		/**
		 * Lee una lista de control desde código XML y la instancia en el editor principal
		 */
		public override function parse(xmlLC:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento lista de control y lo añadimos a la herramienta
 			var lc:ListaControl = new ListaControl();
			super.instrumento = lc;
			super.parse(xmlLC, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlLC.nodeName.search(/\w*:ControlList/) != -1 || xmlLC.nodeName == "ControlList")
				{
					lc.setName(xmlLC.attributes.name);
					lc.setNumDim(parseInt(xmlLC.attributes.dimensions));
					if(xmlLC.attributes.percentage)
					{
						lc.setPorcentaje(xmlLC.attributes.percentage);
					}
					// Ahora recorremos las dimensiones de la lista de control
					var dimensiones:Array = xmlLC.childNodes;
					// Variable auxiliar de porcentaje para las dimensiones (comprueba si ha sido bien asignado)
					var porcentajeDimensiones:int = 0;
					for(var i:int = 0; i < dimensiones.length; i++)
					{
						if(dimensiones[i] is XMLNode)
						{
							var xmlDimension:XMLNode = dimensiones[i] as XMLNode;
							// Comprobamos si el nodo es la descripción del instrumento
							if(xmlDimension.nodeName == "Description")
							{
								lc.setDescripcion(xmlDimension.firstChild.toString());	
							}
							if(xmlDimension.nodeName == "Dimension")
							{
								// Creamos el objeto dimensión, establecemos sus atributos y lo añadimos al instrumento
								var dimension:Dimension = new Dimension();
								lc.addDimension(dimension);
								dimension.setName(xmlDimension.attributes.name);
								dimension.setNumSubDim(xmlDimension.attributes.subdimensions);
								dimension.setPorcentaje(xmlDimension.attributes.percentage);
								porcentajeDimensiones += parseInt(xmlDimension.attributes.percentage);
								// Ahora recorremos los valores y las subdimensiones de la dimensión
								var elementosArr:Array = xmlDimension.childNodes;
								// Variable auxiliar de porcentaje para las subdimensiones (comprueba si ha sido bien asignado)
								var porcentajeSubDimensiones:int = 0;
								for(var j:int = 0; j < elementosArr.length; j++)
								{
									if(elementosArr[j] is XMLNode)
									{
										var elemento:XMLNode = elementosArr[j] as XMLNode;
										if(elemento.nodeName == "Values")
										{
											var values:Array = elemento.childNodes;
											var nombres:ArrayCollection = new ArrayCollection(); // Array con los nombres de los valores
											// Recorremos los valores
											for(var k:int = 0; k < values.length; k++)
											{
												if(values[k] is XMLNode)
												{
													var xmlValue:XMLNode = values[k] as XMLNode;
													if(xmlValue.nodeName == "Value")
													{
														nombres.addItem(xmlValue.firstChild.toString());
													}
												}
											}
											// Creamos los valores para la dimensión actual si sólo tenemos dos, sino se lanza un error
											if(nombres.length != 2)
											{
												// Lanzamos un error
												this.dispatchEvent(new Event(ErrorEvent.ERROR));
											}
										}
										else if(elemento.nodeName == "Subdimension")
										{
											// Creamos el objeto subdimension, establecemos sus atributos y lo añadimos a la dimensión actual
											var subdimension:Subdimension = new Subdimension();
											dimension.addSubDimension(subdimension, dimension.crearValoresConNombre(nombres));
											subdimension.setName(elemento.attributes.name);
											subdimension.setPorcentaje(parseInt(elemento.attributes.percentage));
											porcentajeSubDimensiones += parseInt(xmlDimension.attributes.percentage);
											subdimension.setNumAtrs(parseInt(elemento.attributes.attributes));
											
											// Ahora recorremos los atributos de la subdimensión
											var atributos:Array = elemento.childNodes;
											// Variable auxiliar de porcentaje para las dimensiones (comprueba si ha sido bien asignado)
											var porcentajeAtributos:int = 0;
											for(var k:int = 0; k < atributos.length; k++)
											{
												if(atributos[k] is XMLNode)
												{
													var xmlAtributo:XMLNode = atributos[k] as XMLNode;
													if(xmlAtributo.nodeName == "Attribute")
													{
														// Creamos el objeto atributo, establecemos sus atributos y lo añadimos a la subdimensión
														var atributo:Atributo = new Atributo();
														subdimension.addAtributo(atributo);
														atributo.setName(xmlAtributo.attributes.name);
														atributo.setPorcentaje(parseInt(xmlAtributo.attributes.percentage));
														// Si hay un comentario en el atributo, lo añadimos
														if(xmlAtributo.attributes.comment)
														{
															atributo.setComentario(xmlAtributo.attributes.comment);
														}
														// Ahora añadimos las descripciones y establecemos la selección
														atributo.selectValue(parseInt(xmlAtributo.firstChild.toString()));
													}
												}
											}
											// Comprobamos si el porcentaje en las subdimensiones ha sido bien asignado, si no lo ha sido establecemos
											// porcentajes por defecto
											subdimension.setPorcentajesPorDefecto(porcentajeAtributos);
										}
									}
								}
								// Comprobamos si el porcentaje en las subdimensiones ha sido bien asignado, si no lo ha sido establecemos
								// porcentajes por defecto
								dimension.setPorcentajesPorDefecto(porcentajeSubDimensiones);
							}
						}
					}
					// Comprobamos si el porcentaje en las dimensiones ha sido bien asignado, si no lo ha sido establecemos
					// porcentajes por defecto
					lc.setPorcentajesPorDefecto(porcentajeDimensiones);
				}
				lc.actualizarNota();
				// Establecemos la vista de evaluación del instrumento si es el caso
				if(padre is VentanaEvaluacion || padre is VentanaConsulta)
				{
					lc.setVistaEvaluacion();
				}
				// Al terminar de cargar, cargamos los fallos y advertencias del instrumento
				if(padre is VentanaGenerica)
				{
					(padre as VentanaGenerica).setEstadoInstrumento();
				}
	     	}
	      	catch(error:Error)
	    	{
	    		padre.removeChild(lc.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
		
		/**
		 * Devuelve en un array de 3 niveles los atributos seleccionados para cada subdimensión
		 * lv1 (Dimensiones + Valoración global)
		 * -> lv2 (Subdimeniones + Valoraciones dimensiones)
		 * ->-> lv3 (Atributos: indice + comentarios)
		 */
		public override function getArrayDefinition(xmlLC:XMLNode):ArrayCollection
		{
			try
			{
				// Procesamos el XML
				if(xmlLC.nodeName.search(/\w*:ControlList/) != -1 || xmlLC.nodeName == "ControlList")
				{
					// Ahora recorremos las dimensiones de la lista de control
					var dimensiones:Array = xmlLC.childNodes;
					var arraySelecciones:ArrayCollection = new ArrayCollection();
					for(var i:int = 0; i < dimensiones.length; i++)
					{
						if(dimensiones[i] is XMLNode)
						{
							var xmlDimension:XMLNode = dimensiones[i] as XMLNode;
							if(xmlDimension.nodeName == "Dimension")
							{
								// Ahora recorremos los valores y las subdimensiones de la dimensión
								var elementosArr:Array = xmlDimension.childNodes;
								var subdimensionesDimension:ArrayCollection = new ArrayCollection();
								for(var j:int = 0; j < elementosArr.length; j++)
								{
									if(elementosArr[j] is XMLNode)
									{
										var elemento:XMLNode = elementosArr[j] as XMLNode;
										if(elemento.nodeName == "Subdimension")
										{
											// Ahora recorremos los atributos de la subdimensión
											var atributos:Array = elemento.childNodes;
											var atributosSubdimension:ArrayCollection = new ArrayCollection();
											for(var k:int = 0; k < atributos.length; k++)
											{
												if(atributos[k] is XMLNode)
												{
													var xmlAtributo:XMLNode = atributos[k] as XMLNode;
													if(xmlAtributo.nodeName == "Attribute")
													{
														// Creamos un contenedor atributo genérico
														var atr:AtributoGenerico = new AtributoGenerico();
														// Capturamos la selección en el atributo
														atr.setIndex(parseInt(xmlAtributo.firstChild.toString()));
														// Capturamos el comentario (en caso de revisión)
														atr.setComentario(xmlAtributo.attributes.comment);
														// Añadimos al array
														atributosSubdimension.addItem(atr);
													}
												}
											}
											subdimensionesDimension.addItem(atributosSubdimension);
										}
									}
								}
								arraySelecciones.addItem(subdimensionesDimension);
							}
						}
					}
					return arraySelecciones;
				}
	     	}
	      	catch(error:Error)
	    	{
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
			return null;
		}
	}
}