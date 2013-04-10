<html><head>
<link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" /><title>EvalCOMIX 3.0 Main page</title>
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
<td style="font-style: italic; width: 662px;"><big style="font-weight: bold;"><span><span style="color: rgb(0, 93, 127);"><span style="color: rgb(213, 115, 6);"><span style="color: rgb(0, 93, 127);">WEB SERVICE FOR CREATION AND MANAGEMENT OF</span> ASSESSMENTS TOOLS</span></span></span></big></td>
<td style="text-align: right; vertical-align: bottom; width: 133px;"><small><a href=".">Spanish version</a></small> <a href="."><img style="border: 0px solid ; width: 20px; height: 14px;" alt="Spanish" src="${resource(dir:'img',file:'Spanish.gif')}"></a></td>
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
<li><a href="help/en_US/ApiEvalComix3.0.pdf">Integration manual</a></li>
<li><a href="help/en_US">User's manual</a></li>
<li><a href="AssessmentServiceWSDL.wsdl">WSDL</a></li>
<li>EvalCOMIX 3 Demo</li>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=instrument&call=create&identifier=1DU3wOtIs7ngcJsyneZ9LARffqsy3M_ida5sd87fa5sd8765fa87d65cz87xv587n5hs&demo=1&lang=en_US')">Editor</a></li>
</ul>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=assessment&call=view&identifier=public1DfSfxB9kVXICrPKnkb45sdjXAIKG&lang=en_US')">Assessment example</a></li>
</ul>
<ul>
<li>Co-assessment example</li>
</ul>
<ul>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=assessment&call=review&identifier=1DU3wOtIs7ngcJsyneZ9LARffqsy3M_poihgufpoijhf7gh098jf98ghjhfgh&identifierReviewed=public1DcqSSYyzVpUHGmXGtmP5FeC2IFVnM&demo=1&lang=en_US')">Examiner1</a></li>
</ul>
</ul>
<ul>
<ul>
<li><a href="javascript:abrir_ventana2('AssessmentService2Interface.swf?controller=assessment&call=review&identifier=1DU3wOtIs7ngcJsyneZ9LARffqsy3M_9a87d698fa7sdpoiausdjka8576fasdafds&identifierReviewed=public1DrvQzoRN1RksgQTREcdNojEJRzi&demo=1&lang=en_US')"><span style="font-weight: bold;">Examiner2</span></a></li>
</ul>
</ul>
<li><a href="http://avanza.uca.es/flexoldtool">FlexoLDTool</a></li>
<li>Estadistics</li>
<li><a href="javascript:abrir_ventana('about.gsp')">About</a></li>
</ul>
<ul>
</ul>
</td>
<td style="vertical-align: top; background-color: rgb(237, 237, 237);">
EvalCOMIX 3 is a web service that offers visual creation and edition of assessment tools, considering assessment tools as <br>
different kinds of forms that allow to analyze, evaluate and collect information from different activities associated to them.<br>The service allows to use the tools created in order to make assessments, co-assessments, etc.<br>In
the menu on the left, there is a demo of the service visual interface,
showing the edition and examples of assessment and co-assessment.<br><br>Examples
of assessment tools are checklists, rating scales, rubrics, etc. More
information about the differents assessment tools, their
characteristics and use, can be found in the <a href="help/en_US">user's manual</a>.<br><br>Web
service EvalCOMIX 3 can be integrated in any application
following&nbsp;a few simple steps, at present the service is being
integrated in e-learning platforms like <a href="avanza.uca.es/moodle18">Moodle</a> or Lams. Detailed information about the integration of the service can be found in the <a href="help/en_US/ApiEvalComix3.0.pdf">integration manual</a>.<br><br>EvalCOMIX 3 has been developed by <a href="http://www.uca.es/evalfor">EVALFor Research Group</a> at <a href="http://www.uca.es">Cadiz University</a> and involves some of research projects:<br>
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