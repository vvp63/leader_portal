<?php

include('incl.php');

/*
$contr = array();

if ($_POST["CORG"] == "G") {
	$query = "SELECT [Rid] AS [rid], [GroupName] AS [name] FROM [dbo].[CL_Groups] WHERE [GroupName] LIKE '%".$_POST["search_txt"]."%'";
}
else {
	$query = "SELECT [rid], [name] FROM [dbo].[_CL_Contragents] WHERE [name] LIKE '%".$_POST["search_txt"]."%'";
}

foreach($dbh->query($query) as $row) {
	$contr[$row["rid"]] = $row;
}

$smarty->assign("contr", $contr);
$smarty->assign("query", $query);
$smarty->assign("request_arr", $_REQUEST);
*/

$smarty->display("../lc/templates/s_check_rl.tpl");



?>