<?php


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


echo json_encode($data);

?>