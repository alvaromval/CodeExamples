package parser
{
	import escalaValoracion.*;
	import flash.display.DisplayObjectContainer;
	import flash.xml.XMLNode;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	/**
	 * Parser correspondiente al instrumento Escala de valoración
	 */
	public class ParserEvaluationSet extends Parser
	{	
		public function ParserEvaluationSet()
		{
			super();
		}

		/**
		 * Lee una escala de valoración desde código XML y la instancia en el editor principal
		 */
		public override function parse(xmlEV:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento escala de valoración y lo añadimos a la herramienta
			var ev:EscalaValoracion = new EscalaValoracion();
			super.instrumento = ev;
			super.parse(xmlEV, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlEV.nodeName.search(/\w*:EvaluationSet/) != -1 || xmlEV.nodeName == "EvaluationSet")
				{
					ev.setName(xmlEV.attributes.name);
					ev.setNumDim(parseInt(xmlEV.attributes.dimensions));
					if(xmlEV.attributes.percentage)
					{
						ev.setPorcentaje(xmlEV.attributes.percentage);
					}
					// Ahora recorremos las dimensiones de la escala de valoración
					var dimensiones:Array = xmlEV.childNodes;
					// Variable auxiliar con el porcentaje total de los elementos
					var porcentajeElementos:int = 0;
					for(var i:int = 0; i < dimensiones.length; i++)
					{
						if(dimensiones[i] is XMLNode)
						{
							var xmlDimension:XMLNode = dimensiones[i] as XMLNode;
							// Comprobamos si el nodo es la descripción del instrumento
							if(xmlDimension.nodeName == "Description")
							{
								ev.setDescripcion(xmlDimension.firstChild.toString());	
							}
							if(xmlDimension.nodeName == "Dimension")
							{
								// Creamos el objeto dimensión, establecemos sus atributos y lo añadimos al instrumento
								var dimension:Dimension = new Dimension();
								ev.addDimension(dimension);
								dimension.setName(xmlDimension.attributes.name);
								dimension.setNumSubDim(xmlDimension.attributes.subdimensions);
								dimension.setNumValues(xmlDimension.attributes.values);
								dimension.setPorcentaje(xmlDimension.attributes.percentage);
								porcentajeElementos += parseInt(xmlDimension.attributes.percentage);
								
								// Ahora recorremos los valores y las subdimensiones de la dimensión
								var elementosArr:Array = xmlDimension.childNodes;
								// Variable auxiliar con el porcentaje total de las subdimensiones
								var porcentajeSubdimensiones:int = 0;
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
										}
										else if(elemento.nodeName == "Subdimension")
										{
											// Creamos el objeto subdimension, establecemos sus atributos y lo añadimos a la dimensión actual
											var subdimension:Subdimension = new Subdimension();
											dimension.addSubDimension(subdimension, dimension.crearValoresConNombre(nombres));
											subdimension.setName(elemento.attributes.name);
											subdimension.setPorcentaje(parseInt(elemento.attributes.percentage));
											porcentajeSubdimensiones += parseInt(elemento.attributes.percentage);
											subdimension.setNumAtrs(parseInt(elemento.attributes.attributes));
											
											// Ahora recorremos los atributos de la subdimensión
											var atributos:Array = elemento.childNodes;
											// Variable auxiliar con el porcentaje total de los atributos
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
														porcentajeAtributos += parseInt(xmlAtributo.attributes.percentage);
														// Si hay un comentario en el atributo, lo añadimos
														if(xmlAtributo.attributes.comment)
														{
															atributo.setComentario(xmlAtributo.attributes.comment);
														}
														// Ahora establecemos la selección
														atributo.selectValue(parseInt(xmlAtributo.firstChild.toString()));
													}
												}
											}
											// Comprobamos si el porcentaje en las dimensiones ha sido bien asignado, si no lo ha sido establecemos
											// porcentajes por defecto
											subdimension.setPorcentajesPorDefecto(porcentajeAtributos);
										}
										else if(elemento.nodeName == "DimensionAssessment")
										{
											// Creamos el objeto valoración global de la dimensión, establecemos sus atributos y lo añadimos a la dimensión actual
											dimension.addValoracionGlobal(nombres);
											var vd:ValoracionDimension = dimension.getValoracionGlobal();
											vd.setPorcentaje(elemento.attributes.percentage);
											porcentajeSubdimensiones += parseInt(elemento.attributes.percentage);
											// Ahora recorremos el atributo de la valoración global de la dimensión
											var atributos:Array = elemento.childNodes;
											for(var k:int = 0; k < atributos.length; k++)
											{
												if(atributos[k] is XMLNode)
												{
													var xmlAtributo:XMLNode = atributos[k] as XMLNode;
													if(xmlAtributo.nodeName == "Attribute")
													{
														// Creamos el objeto atributo, establecemos sus atributos y lo añadimos a la valoración global de la dimensión
														vd.getAtributo().setName(xmlAtributo.attributes.name);
														vd.getAtributo().setPorcentaje(100);//parseInt(xmlAtributo.attributes.percentage));
														// Si hay un comentario en el atributo, lo añadimos
														if(xmlAtributo.attributes.comment)
														{
															vd.getAtributo().setComentario(xmlAtributo.attributes.comment);
														}
														// Ahora establecemos la selección
														vd.getAtributo().selectValue(parseInt(xmlAtributo.firstChild.toString()));
													}
												}
											}
										}
									}
								}
								// Comprobamos si el porcentaje en las subdimeniones y valoreaciones ha sido bien asignado, si no lo ha sido establecemos
								// porcentajes por defecto
								dimension.setPorcentajesPorDefecto(porcentajeSubdimensiones);
							}
							else if(xmlDimension.nodeName == "GlobalAssessment")
							{
								// Creamos el objeto dimensión, establecemos sus atributos y lo añadimos al instrumento
								ev.addValoracionGlobal(parseInt(xmlDimension.attributes.values));
								var vg:ValoracionGlobal = ev.getValoracionGlobal();
								vg.setPorcentaje(parseInt(xmlDimension.attributes.percentage));
								porcentajeElementos += parseInt(xmlDimension.attributes.percentage);
								ev.setNumValGlobal(xmlDimension.attributes.values);
								
								// Ahora recorremos los valores y las subdimensiones de la dimensión
								var elementosArr:Array = xmlDimension.childNodes;
								var nombres:ArrayCollection = new ArrayCollection();
								for(var j:int = 0; j < elementosArr.length; j++)
								{
									if(elementosArr[j] is XMLNode)
									{
										var elemento:XMLNode = elementosArr[j] as XMLNode;
										if(elemento.nodeName == "Values")
										{
											var values:Array = elemento.childNodes;
											// Establecemos los nombres de los valores
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
										}
										else if(elemento.nodeName == "Attribute")
										{
											// Creamos el objeto atributo, establecemos su selección y lo añadimos a la valoración global
											vg.getAtributo().setPorcentaje(100);
											vg.getAtributo().setName(elemento.attributes.name);
											// Si hay un comentario en el atributo, lo añadimos
											if(xmlAtributo.attributes.comment)
											{
												vg.getAtributo().setComentario(elemento.attributes.comment);
											}
											// Ahora establecemos la selección
											vg.getAtributo().selectValue(parseInt(elemento.firstChild.toString()));
										}
									} 
								}
								// Establecemos los nombres de los valores
								for(var j:int = 0; j < nombres.length; j++)
								{
									vg.setNombreValorAt(nombres.getItemAt(j).toString(), j);
								}
							}
						}
					}
					// Comprobamos si el porcentaje en las dimensiones ha sido bien asignado, si no lo ha sido establecemos
					// porcentajes por defecto
					ev.setPorcentajesPorDefecto(porcentajeElementos);
				}
				ev.actualizarNota();
				// Establecemos la vista de evaluación del instrumento si es el caso
				if(padre is VentanaEvaluacion || padre is VentanaConsulta)
				{
					ev.setVistaEvaluacion();
				}
				// Al terminar de cargar, cargamos los fallos y advertencias del instrumento
				if(padre is VentanaGenerica)
				{
					(padre as VentanaGenerica).setEstadoInstrumento();
				}
	     	}
	      	catch(error:Error)
	    	{
	    		//padre.removeChild(ev.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
		
		/**
		 * Devuelve en un arrary de 3 niveles los atributos seleccionados para cada subdimensión
		 * lv1 (Dimensiones + Valoración global)
		 * -> lv2 (Subdimeniones + Valoraciones dimensiones)
		 * ->-> lv3 (Atributos: indice + comentarios)
		 */
		public override function getArrayDefinition(xmlEV:XMLNode):ArrayCollection
		{
			try
			{
				if(xmlEV.nodeName.search(/\w*:EvaluationSet/) != -1 || xmlEV.nodeName == "EvaluationSet")
				{
					// Ahora recorremos las dimensiones de la escala de valoración
					var dimensiones:Array = xmlEV.childNodes;
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
								// Añadimos un nuevo array para las subdimensiones dentro de la dimensión
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
											// Creamos un nuevo array para los atributos en la subdimensión
											var atributosSubdimension:ArrayCollection = new ArrayCollection();
											for(var k:int = 0; k < atributos.length; k++)
											{
												if(atributos[k] is XMLNode)
												{
													var xmlAtributo:XMLNode = atributos[k] as XMLNode;
													if(xmlAtributo.nodeName == "Attribute")
													{
														// Creamos un objeto atributo genérico
														var atr:AtributoGenerico = new AtributoGenerico();
														// Almacenamos la selección
														atr.setIndex(parseInt(xmlAtributo.firstChild.toString()));
														// Almacenamos los comentarios
														atr.setComentario(xmlAtributo.attributes.comment);
														// Lo añadimos al array
														atributosSubdimension.addItem(atr);
													}
												}
											}
											// Añadimos los atributos al array de subdimensiones
											subdimensionesDimension.addItem(atributosSubdimension);
										}
										else if(elemento.nodeName == "DimensionAssessment")
										{
											// Ahora recorremos el atributo de la valoración global de la dimensión
											var atributos:Array = elemento.childNodes;
											// Creamos un array para el atributo (para conservar la estructura)
											var atributosSubdimension:ArrayCollection = new ArrayCollection();
											for(var k:int = 0; k < atributos.length; k++)
											{
												if(atributos[k] is XMLNode)
												{
													var xmlAtributo:XMLNode = atributos[k] as XMLNode;
													if(xmlAtributo.nodeName == "Attribute")
													{
														// Creamos un objeto atributo genérico
														var atr:AtributoGenerico = new AtributoGenerico();
														// Almacenamos la selección
														atr.setIndex(parseInt(xmlAtributo.firstChild.toString()));
														// Almacenamos los comentarios
														atr.setComentario(xmlAtributo.attributes.comment);
														// Lo añadimos al array
														atributosSubdimension.addItem(atr);
													}
												}
											}
											// Añadimos los atributos al array de subdimensiones
											subdimensionesDimension.addItem(atributosSubdimension);
										}
									}
								}
								// Añadimos las subidmensiones al array de dimensiones
								arraySelecciones.addItem(subdimensionesDimension);
							}
							else if(xmlDimension.nodeName == "GlobalAssessment")
							{
								// Ahora recorremos los valores y las subdimensiones de la dimensión
								var elementosArr:Array = xmlDimension.childNodes;
								// Añadimos un nuevo array para las subdimensiones dentro de la dimensión (en este caso tendremos un atributo en
								// el nivel 2)
								var subdimensionesDimension:ArrayCollection = new ArrayCollection();
								// Creamos un array para los atributos (en este caso solo uno)
								var atributosSubdimension:ArrayCollection = new ArrayCollection();		
								for(var j:int = 0; j < elementosArr.length; j++)
								{
									if(elementosArr[j] is XMLNode)
									{
										var elemento:XMLNode = elementosArr[j] as XMLNode;
										if(elemento.nodeName == "Attribute")
										{
											// Creamos un objeto atributo genérico
											var atr:AtributoGenerico = new AtributoGenerico();
											// Almacenamos la selección
											atr.setIndex(parseInt(elemento.firstChild.toString()));
											// Almacenamos los comentarios
											atr.setComentario(elemento.attributes.comment);
											// Lo añadimos al array
											atributosSubdimension.addItem(atr);
										}
									} 
								}
								subdimensionesDimension.addItem(atributosSubdimension);
								arraySelecciones.addItem(subdimensionesDimension);
							}
						}
					}
					return arraySelecciones;
				}
	     	}
	      	catch(error:Error)
	    	{
	    		//padre.removeChild(ev.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
			return null;
		}
	}
}