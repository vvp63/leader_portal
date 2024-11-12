<?

include("./incl/header.php");

if (!isset($_SESSION["client"])) $_SESSION["client"] = 1;
if ($_POST["client"]) $_SESSION["client"] = $_POST["client"];

$message = "";
if ($_POST["fl"] == "add") {
	if (isset($_SESSION["client"]) && ($_SESSION["client"] > 0)) {	
		$cbtypes = "";
		foreach ($_POST["cbtypes"] as $t) $cbtypes .= $t.";";
		$aa["fl"] = 1;
		$aa["CORG"] = $_POST["CORG"]; $aa["rtype"] = $_POST["rtype"];
		$aa["cbtypes"] = $_POST["cbtypes"]; $aa["ltype"] = $_POST["ltype"]; 
		$aa["minval"] = $_POST["minval"]; $aa["maxval"] = $_POST["maxval"];
		$aa["cgrid"] = $_POST["corg_list"]; $aa["issueid"] = $_POST["issues_list"];
		if ($_POST["CORG"] == "G") { 
			$query = "SELECT [Rid] AS [rid], [GroupName] AS [name] FROM [dbo].[CL_Groups] WHERE [Rid] = '".$aa["cgrid"]."'";
		} else {  
			$query = "SELECT [rid], [name] FROM [dbo].[_CL_Contragents] WHERE [rid] = '".$aa["cgrid"]."'";
		}
		foreach($dbh->query($query) as $row) { $aa["cgname"] = $row["name"];}	
		
		if ($_POST["rtype"] == 'I') {
			$query = "SELECT [rid], [FullName] FROM [dbo].[_CL_URL_issues] WHERE [emitents_id]='".$aa["cgrid"]."' ORDER BY [FullName]";
			foreach($dbh->query($query) as $row) {
				$aa["issues"][$row["rid"]] = $row["FullName"];
			}
		}
		
		if (!isset($_POST["corg_list"]) || (($_POST["rtype"] == 'I') && !isset($_POST["issues_list"])) ||
			(($_POST["rtype"] != 'I') && ($cbtypes == "")) || !isset($_POST["minval"]) || !isset($_POST["minval"])) {
				$message .= "Не заданы все обязательные параметры (эмитент или группа, список типов бумаг или выпуск, размер ограничений)";
			} else {			
				$query = "EXEC [dbo].[RL_U_AddUpdate] @ClientId = ".$_SESSION["client"].", @CORG = '".$_POST["CORG"]. "', @CORGid = '".$_POST["corg_list"]."'".
						", @RestrictType = '".$_POST["rtype"]."', @IssueRid = ".($_POST["rtype"] == 'I' ? "'".$_POST["issues_list"]."'" : 'NULL').
						", @TypesList = ".($_POST["rtype"] == 'I' ? "NULL" : "'".$cbtypes."'").", @LimitType = '".$_POST["ltype"]."'".
						", @Min = ".$_POST["minval"].", @Max = ".$_POST["maxval"];
				$dbh->query($query);
				$message .= "Ограничение сохранено";					
			}
	} else {
		$message = "Клиент не выбран.";
	}
}

//	Получаем спосок текущих ограничений

$query = "SELECT  rl.[id], rl.[ClientId], rl.[CORG], rl.[CORGid], CASE WHEN rl.[CORG] = 'C' THEN c.name ELSE g.GroupName END AS CORGname
			,rl.[RestrictType], rl.[IssueRid], CASE WHEN rl.RestrictType = 'I' THEN i.FullName ELSE NULL END AS Issue
			,rl.[TypesList], rl.[LimitType], rl.[Min], rl.[Max]
			FROM [RL_Universal] AS rl LEFT JOIN [_CL_Contragents] AS c ON (c.rid = rl.CORGid)
			LEFT JOIN [CL_Groups] AS g ON (g.Rid = rl.CORGid) LEFT JOIN [_CL_URL_issues] AS i ON (i.rid = rl.IssueRid) WHERE rl.[ClientId] = ".$_SESSION["client"].
			" ORDER BY rl.[CORG], rl.[RestrictType], CORGname, rl.[TypesList], Issue";
$rlu = array();
foreach($dbh->query($query) as $row) {
	$rlu[$row["id"]] = $row;
}


$clients = array();
foreach($dbh->query("SELECT [КодКлиента] AS clientid, [НаименованиеКлиента] AS name, [ПолноеНаименование] AS fullname FROM [dbo].[_CL_Clients]") as $row) {
	$clients[$row["clientid"]] = $row;
}

$cbtypes = array();
foreach($dbh->query("SELECT [Id], [Value], [Name] FROM [dbo].[CLlst_Types] ORDER BY [Id]") as $row) {
	$cbtypes[$row["Id"]] = $row;
}

$smarty->assign("clients", $clients);
$smarty->assign("cbtypes", $cbtypes);
$smarty->assign("message", $message);
$smarty->assign("aa", $aa);
$smarty->assign("rlu", $rlu);

$smarty->display("../lc/templates/rl_universal.tpl");




?>