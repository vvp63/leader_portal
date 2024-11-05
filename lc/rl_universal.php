<?

include("./incl/header.php");

if ($_POST["client"]) $_SESSION["client"] = $_POST["client"];

$clients = array();
foreach($dbh->query("SELECT [КодКлиента] AS clientid, [НаименованиеКлиента] AS name, [ПолноеНаименование] AS fullname FROM [dbo].[_CL_Clients]") as $row) {
	$clients[$row["clientid"]] = $row;
}

$cbtypes = array();
foreach($dbh->query("SELECT [Id], [Value], [Name] FROM [dbo].[CLlst_Types]") as $row) {
	$cbtypes[$row["Id"]] = $row;
}

$smarty->assign("clients", $clients);
$smarty->assign("cbtypes", $cbtypes);

$smarty->display("../lc/templates/rl_universal.tpl");




?>