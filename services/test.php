<?php


function GetXML($innerXML) {
	$version = '1.0';
	$encoding = 'UTF-8';
	$rootName = 'root';
	return "<?xml version='".$version."' encoding='".$encoding."'?>\n<".$rootName.">\n".$innerXML."</".$rootName.">";
}


function ArrayXML($varr, $vlev) {
	$res = "";
	if (is_array($varr)) foreach ($varr as $key=>$value) {
		$vkey = (is_numeric($key)) ? "key".$key : $key;
		$vtab = str_repeat("\t", $vlev);
		if (is_array($value)) {
			$res .= $vtab."<".$vkey.">\n".ArrayXML($value, $vlev + 1).$vtab."</".$vkey.">\n";
		}
		else {
			$res .= $vtab."<".$vkey.">".$value."</".$vkey.">\n";
		}
	}
	return $res;
}



$message = $_GET["message"];

$data = array(
	'message' => $message,
	'time' => date('d.m.Y H:i:s', $_SERVER['REQUEST_TIME']),
	'clientinfo' => array (
		'ip' => $_SERVER['REMOTE_ADDR'],
		'user' => $_SERVER['REMOTE_USER']
	),	
	'get_vars' => $_GET,
	'post_vars' => $_POST,
	'hash' => md5($message.$_SERVER['REQUEST_TIME'])

);



header('Content-type: application/xml');

$xmlStr .= ArrayXML($data, 1);
$resXML = GetXML($xmlStr);

echo $resXML;

?>