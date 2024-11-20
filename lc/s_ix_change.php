<?php

include('incl.php');

$res = 0;
if (isset($_POST["rid"])) {
	$query = "UPDATE RL_Universal SET ".($_POST["ix"] == "i" ? "Min" : "Max")." = ".$_POST["val"]." WHERE id = '".$_POST["rid"]."'";
	$dbh->query($query);
	$query = "SELECT ".($_POST["ix"] == "i" ? "Min" : "Max")." AS Val FROM RL_Universal WHERE id = '".$_POST["rid"]."'";
	foreach($dbh->query($query) as $row) $res = $row["Val"];
}
$smarty->assign("res", $res);
$smarty->display("../lc/templates/s_ix_change.tpl");



?>