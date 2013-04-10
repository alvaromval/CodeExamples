<html><head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" /><title>P&aacute;gina de inicio de EvalCOMIX 3.0</title>
<link rel="shortcut icon" href="${resource(dir:'',file:'favicon.ico')}">
<script language="JavaScript">
function abrir_ventana (pagina) {
var opciones="toolbar=no, Location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=yes, width=500, height=550, top=85, left=140";
window.open(pagina,"",opciones);
} function abrir_ventana2 (pagina) {
var opciones="toolbar=no, Location=no, directories=no, status=no, menubar=no, scrollbars=auto, resizable=yes, fullscreen=yes";
window.open(pagina,"",opciones);
}
</script></head>
<body style="background: white none repeat scroll 0% 50%; -moz-background-clip: initial; -moz-background-origin: initial; -moz-background-inline-policy: initial;"><table style="width: 100%; height: 100%; text-align: left; margin-left: auto; margin-right: auto;" border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td style="text-align: center; vertical-align: top; height: 20%;"><big style="font-weight: bold;"><span><span style="color: rgb(0, 93, 127);"></span>
</span></big>
<table style="text-align: left; width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td style="width: 20%; text-align: right;"><big style="font-weight: bold;"><span><img style="width: 257px; height: 83px;" alt="EvalCOMIX 3" src="${resource(dir:'img',file:'cabecera.jpg')}"></span></big></td>
<td style="font-style: italic; width: 662px;"><big style="font-weight: bold;"><span><span style="color: rgb(0, 93, 127);">SERVICIO WEB DE CREACIÓN Y
GESTIÓN DE <span style="color: rgb(213, 115, 6);">INSTRUMENTOS
DE EVALUACIÓN</span></span></span></big></td>
<td style="text-align: right; vertical-align: bottom; width: 133px;"><small><a href="main_en.gsp">English version</a></small> <a href="main_en.gsp"><img style="border: 0px solid ; width: 20px; height: 14px;" alt="English" src="${resource(dir:'img',file:'English.gif')}"></a></td>
</tr>
</tbody>
</table>
<big style="font-weight: bold;"><span>
</span></big></td>
</tr>
<tr>
<td style="vertical-align: top; height: 70%;">
<table style="text-align: left; width: 100%; height: 100%;" border="0" cellpadding="10" cellspacing="0">
<tbody>
<tr>
<td style="height: 100%; text-align: left; vertical-align: top; width: 20%;">
<ul>
<li><a href="help/es_ES/ApiEvalComix3.0.pdf">Manual
de integración</a></li>
<li><a href="help/es_ES">Manual de
usuario</a></li>
<li><a href="AssessmentServiceWSDL.wsdl">WSDL</a></li>
<li>Demo EvalCOMIX 3</li>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=instrument&call=create&identifier=1DU3wOtIs7ngcJsyneZ9LARffqsy3M_ida5sd87fa5sd8765fa87d65cz87xv587n5hs&demo=1')">Editor</a></li>
</ul>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=assessment&call=view&identifier=public1DfSfxB9kVXICrPKnkb45sdjXAIKG')">Evaluación</a></li>
</ul>
<ul>
<li>Coevaluación</li>
</ul>
<ul>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=assessment&call=review&identifier=1DU3wOtIs7ngcJsyneZ9LARffqsy3M_poihgufpoijhf7gh098jf98ghjhfgh&identifierReviewed=public1DcqSSYyzVpUHGmXGtmP5FeC2IFVnM&demo=1')">Evaluador1</a></li>
</ul>
</ul>
<ul>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=assessment&call=review&identifier=1DU3wOtIs7ngcJsyneZ9LARffqsy3M_9a87d698fa7sdpoiausdjka8576fasdafds&identifierReviewed=public1DrvQzoRN1RksgQTREcdNojEJRzi&demo=1')"><span style="font-weight: bold;">Evaluador2</span></a></li>
</ul>
</ul>
<li><a href="http://avanza.uca.es/flexoldtool">FlexoLDTool</a></li>
<li>Estadísticas
de uso</li>
<li><a href="javascript:abrir_ventana('acercade.gsp')">Acerca de</a></li>
</ul>
<ul>
</ul>
</td>
<td style="vertical-align: top; background-color: rgb(237, 237, 237);">
<br>
EvalCOMIX
3 es un servicio web que permite la creación, edición visual
de instrumentos de evaluación, entendiendo por instrumentos de
evaluación a diferentes tipos de formularios que nos permiten recoger
información, analizar, y evaluar desempeños, aspectos o características
en diferentes tipos de actividades.
<br>
El servicio nos permite utilizar los instrumentos creados para realizar evaluaciones, co-evaluaciones, etc.
<br>
En el menú izquierdo, podemos acceder a una pequeña demo de la interfaz visual del servicio.
<br>
<br>
Ejemplos de instrumenos web
pueden ser Listas de Control, Escalas de Valoración, Rúbricas, etc. La
información detallada sobre los diferentes instrumentos de evaluación,
sus características y su uso, se puede encontrar en el <a href="help/es_ES/">manual del usuario</a><br>
<br>
El
servicio web EvalCOMIX 3 puede ser integrable en cualquier aplicación
mediante el uso de su API y siguiendo unos sencillos pasos, actualmente
se está integrando en plataformas e-learning como <a href="http://avanza.uca.es/moodle18">Moodle</a> o
Lams. La información detallada para su integración se encuentra en el <a href="help/es_ES/ApiEvalComix3.0.pdf">manual de integración</a>.<br>
<br>
EvalCOMIX 3 ha sido desarrollado por el <a href="http://www.uca.es/evalfor"/>Grupo de investigación EVALFor</a> de la <a href="http://www.uca.es/">Universidad
de Cádiz</a> y abarca varios proyectos de investigación:<br>
<ul style="list-style-type: circle;">
<ul>
<li><a href="http://evalcomix.uca.es">EvalCOMIX (EA2007-0099)</a></li>
<li><a href="http://flexo.atosorigin.es">Flexo (TSI-020301-2008-19 y TSI-020301-2009-9)</a></li>
<li>EvalHIDA (EA2008-0237)</li>
<li><a href="http://avanza.uca.es/moodle18">Re-Evalúa (P08-SEJ-03502)</a></li>
</ul>
</ul>
</td>
</tr>
</tbody>
</table>
<br>
</td>
</tr>
<tr>
<td style="height: 10%; background-color: white; text-align: center;"><a href="http://www.uca.es"><img style="border: 0px solid ; width: 172px; height: 40px;" alt="UCA" src="${resource(dir:'img',file:'uca40.gif')}"></a> <a href="http://evalcomix.uca.es"><img style="border: 0px solid ; width: 75px; height: 40px;" alt="EvalCOMIX" src="${resource(dir:'img',file:'evalcomix40.jpg')}"></a> <a href="http://flexo.atosorigin.es"><img style="border: 0px solid ; width: 62px; height: 40px;" alt="Flexo" src="${resource(dir:'img',file:'flexo40.gif')}"></a> <img style="border: 0px solid ; width: 103px; height: 40px;" alt="EvalHIDA" src="${resource(dir:'img',file:'evalhida40.png')}"> <a href="http://avanza.uca.es/moodle18"><img style="border: 0px solid ; width: 127px; height: 40px;" alt="Re-Evalúa" src="${resource(dir:'img',file:'re-Evalua40.png')}"></a>&nbsp;</td>
</tr>
</tbody>
</table>
</body></html>