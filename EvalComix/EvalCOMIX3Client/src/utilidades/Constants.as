package utilidades
{	
	import diferencialSemantico.DiferencialSemantico;
	import escalaValoracion.EscalaValoracion;
	import listaControl.ListaControl;
	import listaControlEscalaValoracion.ListaControlEscalaValoracion;
	import matrizDecision.MatrizDecision;
	import mixta.HerramientaMixta;
	import parser.*;
	
	import mx.core.Application;
	import mx.resources.ResourceManager;
	
	import rubrica.Rubrica;
	
	public class Constants
	{
		public function Constants()
		{
		}
		
		// Parsers, los añadimos aquí para que se añadan en la compilación
		parser.ParserControlList;
		parser.ParserControlListEvaluationSet;
		parser.ParserDecisionMatrix;
		parser.ParserEvaluationSet;
		parser.ParserMixTool;
		parser.ParserRubric;
		parser.ParserSemanticDifferential;
		
		// Instrumentos, los añadimos aquí para que se añadan en la compilación
		diferencialSemantico.DiferencialSemantico;
		escalaValoracion.EscalaValoracion;
		listaControl.ListaControl;
		listaControlEscalaValoracion.ListaControlEscalaValoracion;
		matrizDecision.MatrizDecision;
		mixta.HerramientaMixta;
		rubrica.Rubrica;
		
		// CONSTANTES PARA LOS INSTRUMENTOS DE EVALUACIÓN:
		
		// Valores para cada tipo de instrumento en el servidor
		public static var ESCALA_VALORACION:String = "value_list";
		public static var LISTA_CONTROL:String = "control_list";
		public static var LISTA_CONTROL_ESCALA_VALORACION:String = "control_list_value_list";
		public static var MATRIZ_DECISION:String = "decision_matrix";
		public static var RUBRICA:String = "rubric";
		public static var SEMANTIC_DIFFERENTIAL:String = "semantic_differential";
		public static var MIXTA:String = "mix";
		
		// Array con las constantes para cada instrumento
		// Estructura:
		// [ nombre de la clase del instrumento , el valor de la key del fichero de propiedades y valor en servidor,  clase del parser , nombre del nodo padre del XML del instrumento]
		// Para añadir un nuevo instrumento, añadir una nueva fila
		public static var instrumentos:Array = 
		[["escalaValoracion.EscalaValoracion", "value_list", "parser.ParserEvaluationSet", "EvaluationSet"],
		["listaControlEscalaValoracion.ListaControlEscalaValoracion", "control_list_value_list", "parser.ParserControlListEvaluationSet","ControlListEvaluationSet"],
		["listaControl.ListaControl", "control_list", "parser.ParserControlList", "ControlList"],
		["matrizDecision.MatrizDecision", "decision_matrix", "parser.ParserDecisionMatrix", "DecisionMatrix"], 
		["rubrica.Rubrica", "rubric", "parser.ParserRubric", "Rubric"], 
		["diferencialSemantico.DiferencialSemantico", "semantic_differential", "parser.ParserSemanticDifferential", "SemanticDifferential"],
		["mixta.HerramientaMixta", "mix", "parser.ParserMixTool", "MixTool"]];
		
		// Definición de instrumentos
		// XSDs
		public static var CONTROL_LIST_XSD:String = "http://avanza.uca.es/assessmentservice/ControlList.xsd";
		public static var EVALUATION_SET_XSD:String = "http://avanza.uca.es/assessmentservice/EvaluationSet.xsd";
		public static var CONTROL_LIST_EVALUATION_SET_XSD:String = "http://avanza.uca.es/assessmentservice/ControlListEvaluationSet.xsd";
		public static var RUBRIC_XSD:String = "http://avanza.uca.es/assessmentservice/Rubric.xsd";
		public static var SEMANTIC_DIFFERENTIAL_XSD:String = "http://avanza.uca.es/assessmentservice/SemanticDifferential.xsd";
		public static var DECISION_MATRIX_XSD:String = "http://avanza.uca.es/assessmentservice/DecisionMatrix.xsd";
		public static var MIX_TOOL_XSD:String = "http://avanza.uca.es/assessmentservice/MixTool.xsd";
		// Namespaces
		public static var CONTROL_LIST_NS:String = "http://avanza.uca.es/assessmentservice/controllist";
		public static var EVALUATION_SET_NS:String = "http://avanza.uca.es/assessmentservice/evaluationset";
		public static var CONTROL_LIST_EVALUATION_SET_NS:String = "http://avanza.uca.es/assessmentservice/controllistevaluationset";
		public static var RUBRIC_NS:String = "http://avanza.uca.es/assessmentservice/rubric";
		public static var SEMANTIC_DIFFERENTIAL_NS:String = "http://avanza.uca.es/assessmentservice/semanticdifferential";
		public static var DECISION_MATRIX_NS:String = "http://avanza.uca.es/assessmentservice/decisionmatrix";
		public static var MIX_TOOL_NS:String = "http://avanza.uca.es/assessmentservice/mixtool";

		// URLs DE SERVICIOS
		public static var URL_ObtenerInstrumento:String = "/assessmentservice/instrument/get";
		public static var URL_GuardarInstrumento:String = "/assessmentservice/instrument/save";		
		public static var URL_ObtenerEvaluacion:String = "/assessmentservice/assessment/get";
		public static var URL_GuardarEvaluacion:String = "/assessmentservice/assessment/save";
		public static function getURL_Export():String
		{
			return "/assessmentservice/" + Application.application.parameters.controller + "/export";
		}
		public static function getURL_Import():String
		{
			return "/assessmentservice/" + Application.application.parameters.controller + "/read";
		}
		public static function getURL_Ayuda():String
		{
			return "/assessmentservice/help/" + ResourceManager.getInstance().localeChain[0];
		}
		
		// OTRAS CONSTANTES
		
		// Porcentaje mínimo por el que se considera que el porcentaje total de un instrumento 
		//está bien establecido (se redondea hasta el 100%)
		public static var PORCENTAJE_MINIMO:int = 90; 
		
		// Extensión de ficheros
		public static var EXTENSION:String = ".evx";
	}
}