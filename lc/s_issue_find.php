<?php

include('incl.php');

$issues = array();

$query = "SELECT [rid], [emitents_id], [FullName] FROM [dbo].[_CL_URL_issues] WHERE [emitents_id]='".$_REQUEST["contrid"]."' ORDER BY [FullName]";

foreach($dbh->query($query) as $row) {
	$issues[$row[rid]] = $row;
}

$smarty->assign("issues", $issues);
$smarty->assign("query", $query);
$smarty->display("../lc/templates/s_issue_find.tpl");


?>