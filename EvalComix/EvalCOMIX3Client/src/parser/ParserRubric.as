package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.xml.XMLNode;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import rubrica.*;
	
	/**
	 * Parser correspondiente al instrumento Rúbrica
	 */
	public class ParserRubric extends Parser
	{
		public function ParserRubric()
		{
			super();
		}

		/**
		 * Lee una rúbrica desde código XML y la instancia en el editor principal
		 */
		public override function parse(xmlRubric:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento rúbrica y lo añadimos a la herramienta
 			var rubric:Rubrica = new Rubrica();
			super.instrumento = rubric;
			super.parse(xmlRubric, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlRubric.nodeName.search(/\w*:Rubric/) != -1 || xmlRubric.nodeName == "Rubric")
				{
					rubric.setName(xmlRubric.attributes.name);
					rubric.setNumDim(parseInt(xmlRubric.attributes.dimensions));
					if(xmlRubric.attributes.percentage)
					{
						rubric.setPorcentaje(xmlRubric.attributes.percentage);	
					}
					// Ahora recorremos las dimensiones de la rúbrica
					var dimensiones:Array = xmlRubric.childNodes;
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
								rubric.setDescripcion(xmlDimension.firstChild.toString());	
							}
							if(xmlDimension.nodeName == "Dimension")
							{
								// Creamos el objeto dimensión, establecemos sus atributos y lo añadimos a la rúbrica
								var dimension:Dimension = new Dimension();
								rubric.addDimension(dimension);
								dimension.setName(xmlDimension.attributes.name);
								dimension.setNumSubDim(xmlDimension.attributes.subdimensions);
								dimension.setPorcentaje(xmlDimension.attributes.percentage);
								porcentajeElementos += parseInt(xmlDimension.attributes.percentage);
								dimension.setNumValues(xmlDimension.attributes.values);
								
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
											// Recorremos los valores
											for(var k:int = 0; k < values.length; k++)
											{
												if(values[k] is XMLNode)
												{
													var xmlValue:XMLNode = values[k] as XMLNode;
													if(xmlValue.nodeName == "Value")
													{
														// Creamos el objeto ValorDimension, establecemos sus atributos y lo añadimos a la dimensión actual
														var value:ValorDimension = new ValorDimension();
														dimension.addValorDimension(value);
														value.setName(xmlValue.attributes.name);
														value.setNumVals(xmlValue.attributes.instances);
														// Añadimos las instancias del valor
														var instanciasArr:Array = xmlValue.childNodes;
														var instancias:ArrayCollection = new ArrayCollection()
														for(var e:int = 0; e < instanciasArr.length; e++)
														{
															if(instanciasArr[e] is XMLNode)
															{
																var aux:XMLNode = instanciasArr[e] as XMLNode;
																if(aux.nodeName == "instance")
																{
																	instancias.addItem(aux.firstChild.toString());
																}
															} 
														}
														value.insertarValores(instancias);
													}
												}
											}
										}
										else if(elemento.nodeName == "Subdimension")
										{
											// Creamos el objeto subdimension, establecemos sus atributos y lo añadimos a la dimensión actual
											var subdimension:Subdimension = new Subdimension();
											dimension.addSubDimension(subdimension, dimension.getValores());
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
														
														// Ahora añadimos las descripciones y establecemos la selección
														var elementosAtrArr:Array = xmlAtributo.childNodes;
														for(var e:int = 0; e < elementosAtrArr.length; e++)
														{
															if(elementosAtrArr[e] is XMLNode)
															{
																var aux:XMLNode = elementosAtrArr[e] as XMLNode;
																if(aux.nodeName == "descriptions")
																{
																	var descriptions:ArrayCollection = new ArrayCollection();
																	var descrArray:Array = aux.childNodes;
																	// Almacenamos las descripciones en un array
																	for(var f:int = 0; f < descrArray.length; f++)
																	{
																		if(descrArray[f] is XMLNode)
																		{
																			var xmlDescription:XMLNode = descrArray[f] as XMLNode;
																			if(xmlDescription.nodeName == "description")
																			{
																				if(xmlDescription.firstChild != null)
																				{
																					descriptions.addItem(xmlDescription.firstChild.toString());
																				}
																				else
																				{
																					descriptions.addItem("");
																				}
																			}
																		}
																	}
																	// Añadimos las descripciones al atributo
																	atributo.setDescripciones(descriptions);
																}
																else if(aux.nodeName == "selection")
																{
																	// Recorremos los hijos del elemento selection
																	var selectionArr:Array = aux.childNodes;
																	var val:int = 0;
																	var instance:int = 0;
																	for(var f:int = 0; f < selectionArr.length; f++)
																	{
																		if(selectionArr[f] is XMLNode)
																		{
																			var aux2:XMLNode = selectionArr[f] as XMLNode;
																			if(aux2.nodeName == "val")
																			{
																				val = parseInt(aux2.firstChild.toString());	
																			}
																			else if(aux2.nodeName == "instance")
																			{
																				instance = parseInt(aux2.firstChild.toString());
																			}
																		}
																	}
																	// Establecemos el valor seleccionado de la subdimensión y el número, dentro del valor
																	atributo.selectValue(val, instance);
																}
															}
														}
													}
												}
											}
											// Comprobamos si el porcentaje en las dimensiones ha sido bien asignado, si no lo ha sido establecemos
											// porcentajes por defecto
											subdimension.setPorcentajesPorDefecto(porcentajeAtributos);
										}
										else if(elemento.nodeName == "DimensionAssessment")
										{
											// Creamos el objeto subdimension, establecemos sus atributos y lo añadimos a la dimensión actual
											dimension.addValoracionGlobal(dimension.getValores());
											var vd:ValoracionDimension = dimension.getValoracionGlobal();
											vd.setPorcentaje(parseInt(elemento.attributes.percentage));
											porcentajeSubdimensiones += parseInt(elemento.attributes.percentage);
											
											// Ahora recorremos los atributos de la valoración de la dimensión
											var atributos:Array = elemento.childNodes;
											for(var k:int = 0; k < atributos.length; k++)
											{
												if(atributos[k] is XMLNode)
												{
													var xmlAtributo:XMLNode = atributos[k] as XMLNode;
													if(xmlAtributo.nodeName == "Attribute")
													{
														// Creamos el objeto atributo, establecemos sus atributos y lo añadimos a la subdimensión
														vd.getAtributo().setName(xmlAtributo.attributes.name);
														vd.getAtributo().setPorcentaje(100);
														
														// Ahora añadimos las descripciones y establecemos la selección
														var elementosAtrArr:Array = xmlAtributo.childNodes;
														for(var e:int = 0; e < elementosAtrArr.length; e++)
														{
															if(elementosAtrArr[e] is XMLNode)
															{
																var aux:XMLNode = elementosAtrArr[e] as XMLNode;
																if(aux.nodeName == "descriptions")
																{
																	var descriptions:ArrayCollection = new ArrayCollection();
																	var descrArray:Array = aux.childNodes;
																	// Almacenamos las descripciones en un array
																	for(var f:int = 0; f < descrArray.length; f++)
																	{
																		if(descrArray[f] is XMLNode)
																		{
																			var xmlDescription:XMLNode = descrArray[f] as XMLNode;
																			if(xmlDescription.nodeName == "description")
																			{
																				if(xmlDescription.firstChild != null)
																				{
																					descriptions.addItem(xmlDescription.firstChild.toString());
																				}
																				else
																				{
																					descriptions.addItem("");
																				}
																			}
																		}
																	}
																	// Añadimos las descripciones al atributo
																	vd.getAtributo().setDescripciones(descriptions);
																}
																else if(aux.nodeName == "selection")
																{
																	// Recorremos los hijos del elemento selection
																	var selectionArr:Array = aux.childNodes;
																	var val:int = 0;
																	var instance:int = 0;
																	for(var f:int = 0; f < selectionArr.length; f++)
																	{
																		if(selectionArr[f] is XMLNode)
																		{
																			var aux2:XMLNode = selectionArr[f] as XMLNode;
																			if(aux2.nodeName == "val")
																			{
																				val = parseInt(aux2.firstChild.toString());	
																			}
																			else if(aux2.nodeName == "instance")
																			{
																				instance = parseInt(aux2.firstChild.toString());
																			}
																		}
																	}
																	// Establecemos el valor seleccionado de la subdimensión y el número, dentro del valor
																	vd.getAtributo().selectValue(val, instance);
																}
															}
														}
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
								// Creamos el objeto dimensión, establecemos sus atributos y lo añadimos a la rúbrica
								rubric.addValoracionGlobal(parseInt(xmlDimension.attributes.values));
								var vg:ValoracionGlobal = rubric.getValoracionGlobal();
								vg.setPorcentaje(parseInt(xmlDimension.attributes.percentage));
								porcentajeElementos += parseInt(xmlDimension.attributes.percentage);
								rubric.setNumValGlobal(xmlDimension.attributes.values);
								
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
						// Comprobamos si el porcentaje en las dimensiones ha sido bien asignado, si no lo ha sido establecemos
						// porcentajes por defecto
						rubric.setPorcentajesPorDefecto(porcentajeElementos);
					}
					rubric.actualizarNota();
					// Establecemos la vista de evaluación del instrumento si es el caso
					if(padre is VentanaEvaluacion || padre is VentanaConsulta)
					{
						rubric.setVistaEvaluacion();
					}
					// Al terminar de cargar, cargamos los fallos y advertencias del instrumento
					if(padre is VentanaGenerica)
					{
						(padre as VentanaGenerica).setEstadoInstrumento();
					}
				}
	     	}
	      	catch(error:Error)
	    	{
	    		//padre.removeChild(rubric.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
	}
}