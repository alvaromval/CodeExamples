package parser
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.xml.XMLNode;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import matrizDecision.*;
	
	public class ParserDecisionMatrix extends Parser
	{
		public function ParserDecisionMatrix()
		{
			super();
		}
		
		/**
		 * Lee una matriz de decisión desde código XML y la instancia en el editor principal
		 */
		public override function parse(xmlMD:XMLNode, padre:DisplayObjectContainer):void
		{
			// Creamos un instrumento matriz de decisión y lo añadimos a la herramienta
 			var md:MatrizDecision = new MatrizDecision();
			super.instrumento = md;
			super.parse(xmlMD, padre);
			try
			{
				// Procesamos el XML para ir añadiendo sus atributos y elementos al instrumento
				if(xmlMD.nodeName.search(/\w*:DecisionMatrix/) != -1 || xmlMD.nodeName == "DecisionMatrix")
				{
					// Creamos el objeto matriz de decisión, establecemos sus atributos y lo añadimos a la herramienta
					md.setName(xmlMD.attributes.name);
					md.setNumCriterios(parseInt(xmlMD.attributes.criterions));
					md.setNumCompetencias(parseInt(xmlMD.attributes.competences));
					md.insertar();
					// Recorremos los elementos de la matriz de decisión
					var elementos:Array = xmlMD.childNodes;
					for(var i:int = 0; i < elementos.length; i++)
					{
						if(elementos[i] is XMLNode)
						{
							var xmlElemento:XMLNode = elementos[i] as XMLNode;
							// Comprobamos si el nodo es la descripción del instrumento
							if(xmlElemento.nodeName == "Description")
							{
								md.setDescripcion(xmlElemento.firstChild.toString());	
							}
							if(xmlElemento.nodeName == "Competences")
							{
								var competencias:Array = xmlElemento.childNodes;
								var nombresCompetencias:ArrayCollection = new ArrayCollection();
								for(var j:int = 0; j < competencias.length; j++)
								{
									if(competencias[j] is XMLNode)
									{
										var xmlCompetencia:XMLNode = competencias[j] as XMLNode;
										if(xmlCompetencia.nodeName == "CompetenceDescription")
										{
											// Añadimos el nombre de la competencia al array, después lo asignaremos a la competencia
											nombresCompetencias.addItem(xmlCompetencia.attributes.name);
										}
									}
								}
								// Una vez que tenemos los nombres, los asignamos a las competencias	
								// Comprobamos si el número de competencias es el mismo que el indicado arriba
								if(md.getNumCompetencias() == nombresCompetencias.length)
								{
									for(var j:int = 0; j < nombresCompetencias.length; j++)
									{
										md.getMatriz().getCompetenciaAt(j).setName(nombresCompetencias.getItemAt(j).toString());
									}
								}
								else
								{
									this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,'Number of competences in DecisionMatrix "competences" is different to the number of CompetenceDescription childs'));
								}
							}
							else if(xmlElemento.nodeName == "Criterions")
							{
								var criterios:Array = xmlElemento.childNodes;
								var nombresCriterios:ArrayCollection = new ArrayCollection();
								var instanciasCriterios:ArrayCollection = new ArrayCollection();
								for(var j:int = 0; j < criterios.length; j++)
								{
									if(criterios[j] is XMLNode)
									{
										var xmlDescripcion:XMLNode = criterios[j] as XMLNode;
										if(xmlDescripcion.nodeName == "CriterionDescription")
										{
											// Añadimos el nombre de la competencia al array, después lo asignaremos a la competencia
											nombresCriterios.addItem(xmlDescripcion.attributes.name);
											var competenciasCriterio:Array = xmlDescripcion.childNodes;
											var instanciasCriterio:ArrayCollection = new ArrayCollection();
											for(var k:int = 0; k < competenciasCriterio.length; k++)
											{
												if(competenciasCriterio[k] is XMLNode)
												{
													var xmlCompetenciaCriterio:XMLNode = competenciasCriterio[k] as XMLNode;
													if(xmlCompetenciaCriterio.nodeName == "CriterionCompetence")
													{
														var instanciaCriterioCompetencia:ArrayCollection = new ArrayCollection();
														var competenciaCriterio:Array = xmlCompetenciaCriterio.childNodes;
														for(var f:int = 0; f < competenciaCriterio.length; f++)
														{
															if(competenciaCriterio[f] is XMLNode)
															{
																var xmlInstacia:XMLNode = competenciaCriterio[f] as XMLNode;
																if(xmlInstacia.nodeName == "competence")
																{
																	instanciaCriterioCompetencia.addItem(xmlInstacia.firstChild.toString());
																}
															}
														}
														instanciasCriterio.addItem(instanciaCriterioCompetencia);
													}
												}
											}
											instanciasCriterios.addItem(instanciasCriterio);
										}
									}
								}
								// Una vez que tenemos los nombres y las instancias, los asignamos a los criterios	
								// Comprobamos si el número de criterios es el mismo que el indicado arriba
								if(md.getNumCriterios() == nombresCriterios.length)
								{
									// Establecemos los nombres
									for(var j:int = 0; j < nombresCriterios.length; j++)
									{
										md.getMatriz().getCriterioAt(j).setName(nombresCriterios.getItemAt(j).toString());
										// Establecemos las instacias
										for(var k:int = 0; k < md.getMatriz().getNumCompetencias(); k++)
										{
											//md.getMatriz().getCriterioAt(j).getInstaciaCriterio(k).setValores(instanciasCriterios(
											var instanciaCriterioCompetencia:ArrayCollection = (instanciasCriterios.getItemAt(j) as ArrayCollection).getItemAt(k) as ArrayCollection;
											md.getMatriz().getCriterioAt(j).setInstanciasCriterio(k, instanciaCriterioCompetencia);
										}
									}
								}
								else
								{
									this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, 'Number of criterions in DecisionMatrix "criterions" is different to the number of CriterionDescription childs'));
								}
							}
						}
					}
				}
				if(padre is VentanaEvaluacion || padre is VentanaConsulta)
				{
					md.setVistaEvaluacion();
				}
	     	}
	      	catch(error:Error)
	    	{
	    		padre.removeChild(md.getPadre());
	    		Alert.show("ERROR:\nError while parsing the file:\n" + error.getStackTrace(), "ERROR, incompatible file");
			}
		}
	}
}