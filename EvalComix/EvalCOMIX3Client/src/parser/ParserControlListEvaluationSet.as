package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.xml.XMLNode;
	import listaControlEscalaValoracion.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	/**
	 * Parser correspondiente al instrumento Lista de Control + Escala de valoración
	 */
	public class ParserControlListEvaluationSet extends Parser
	{
		public function ParserControlListEvaluationSet()
		{
		}
		
		/**
		 * Lee una lista de control + escala de valoración desde código XML y 
		 * la instancia en el editor principal
		 */
		public override function parse(xmlLCEV:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento lista de control + escala de valoración y lo añadimos a la herramienta
 			var lcev:ListaControlEscalaValoracion = new ListaControlEscalaValoracion();
			super.instrumento = lcev;
			super.parse(xmlLCEV, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlLCEV.nodeName.search(/\w*:ControlListEvaluationSet/) != -1 || xmlLCEV.nodeName == "ControlListEvaluationSet")
				{
					lcev.setName(xmlLCEV.attributes.name);
					lcev.setNumDim(parseInt(xmlLCEV.attributes.dimensions));
					if(xmlLCEV.attributes.percentage)
					{
						lcev.setPorcentaje(xmlLCEV.attributes.percentage);
					}
					// Ahora recorremos las dimensiones de la lista de control + escala de valoración
					var dimensiones:Array = xmlLCEV.childNodes;
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
								lcev.setDescripcion(xmlDimension.firstChild.toString());	
							}
							if(xmlDimension.nodeName == "Dimension")
							{
								// Creamos el objeto dimensión, establecemos sus atributos y lo añadimos al instrumento
								var dimension:Dimension = new Dimension();
								lcev.addDimension(dimension);
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
										if(elemento.nodeName == "ControlListValues")
										{
											var values:Array = elemento.childNodes;
											var nombresListaControl:ArrayCollection = new ArrayCollection(); // Array con los nombres de los valores
											// Recorremos los valores
											for(var k:int = 0; k < values.length; k++)
											{
												if(values[k] is XMLNode)
												{
													var xmlValue:XMLNode = values[k] as XMLNode;
													if(xmlValue.nodeName == "Value")
													{
														nombresListaControl.addItem(xmlValue.firstChild.toString());
													}
												}
											}
											// Creamos los valores de la lista de control para la dimensión actual si sólo tenemos dos, sino se lanza un error
											if(nombresListaControl.length != 2)
											{
												// Lanzamos un error
												this.dispatchEvent(new Event(ErrorEvent.ERROR));
											}
										}
										else if(elemento.nodeName == "Values")
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
											dimension.addSubDimension(subdimension, dimension.crearValoresListaControlConNombre(nombresListaControl), dimension.crearValoresConNombre(nombres));
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
														// Dentro del atributo debemos buscar la selección en la lista de control y en la escala de valoración
														var selecciones:Array = xmlAtributo.childNodes;
														var seleccionControlList:int = 0;
														var seleccionEscalaValoracion:int = 0;
														for(var f:int = 0; f < selecciones.length; f++)
														{
															if(selecciones[f] is XMLNode)
															{
																var seleccion:XMLNode = selecciones[f] as XMLNode;
																if(seleccion.nodeName == "selectionControlList")
																{
																	seleccionControlList = parseInt(seleccion.firstChild.toString());
																}
																else if(seleccion.nodeName == "selection")
																{
																	seleccionEscalaValoracion = parseInt(seleccion.firstChild.toString());	
																}
															}
														}
														// Ahora establecemos la selección
														atributo.selectValue(seleccionControlList, seleccionEscalaValoracion);
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
														vd.getAtributo().setPorcentaje(100);
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
								lcev.addValoracionGlobal(parseInt(xmlDimension.attributes.values));
								var vg:ValoracionGlobal = lcev.getValoracionGlobal();
								vg.setPorcentaje(xmlDimension.attributes.percentage);
								porcentajeElementos += parseInt(xmlDimension.attributes.percentage);
								lcev.setNumValGlobal(xmlDimension.attributes.values);
								
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
					lcev.setPorcentajesPorDefecto(porcentajeElementos);
				}
				lcev.actualizarNota();
				// Establecemos la vista de evaluación del instrumento si es el caso
				if(padre is VentanaEvaluacion || padre is VentanaConsulta)
				{
					lcev.setVistaEvaluacion();
				}
				// Al terminar de cargar, cargamos los fallos y advertencias del instrumento
				if(padre is VentanaGenerica)
				{
					(padre as VentanaGenerica).setEstadoInstrumento();
				}
	     	}
	      	catch(error:Error)
	    	{
	    		padre.removeChild(lcev.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
		
		/**
		 * Devuelve en un arrary de 3 niveles los atributos seleccionados para cada subdimensión
		 * lv1 (Dimensiones + Valoración global)
		 * -> lv2 (Subdimeniones + Valoraciones dimensiones)
		 * ->-> lv3 (Atributos: indice + comentarios)
		 */
		public override function getArrayDefinition(xmlLCEV:XMLNode):ArrayCollection
		{
			try
			{
				if(xmlLCEV.nodeName.search(/\w*:ControlListEvaluationSet/) != -1 || xmlLCEV.nodeName == "ControlListEvaluationSet")
				{
					// Ahora recorremos las dimensiones de la lista de control + escala de valoración
					var dimensiones:Array = xmlLCEV.childNodes;
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
														var selecciones:Array = xmlAtributo.childNodes;
														for(var m:int = 0; m < selecciones.length; m++)
														{
															var seleccion:XMLNode = selecciones[m];
															if(seleccion.nodeName == "selectionControlList")
															{
																atr.setIndex(parseInt(seleccion.firstChild.toString()));
															}
															else if(seleccion.nodeName == "selection")
															{
																if(atr.getIndex() == 1)
																{
																	atr.setIndex(parseInt(seleccion.firstChild.toString()));
																}
															}
														}
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