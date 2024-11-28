<?

include("./incl/header.php");


if (!isset($_SESSION["client"])) $_SESSION["client"] = 1;
if ($_POST["client"]) $_SESSION["client"] = $_POST["client"];

$clients = array();
foreach($dbh->query("SELECT [КодКлиента] AS clientid, [НаименованиеКлиента] AS name, [ПолноеНаименование] AS fullname FROM [dbo].[_CL_Clients]") as $row) {
	$clients[$row["clientid"]] = $row;
}

$cbtypes = array();
foreach($dbh->query("SELECT [Id], [Value], [Name] FROM [dbo].[CLlst_Types] ORDER BY [Id]") as $row) {
	$cbtypes[$row["Value"]] = $row["Name"];
}

$message = "";

$aa["CORG"] = $_POST["CORG"]; $aa["rtype"] = $_POST["rtype"];
$aa["cbtypes"] = $_POST["cbtypes"]; $aa["ltype"] = $_POST["ltype"]; 
$aa["minval"] = $_POST["minval"]; $aa["maxval"] = $_POST["maxval"];
$aa["cgrid"] = $_POST["corg_list"]; $aa["issueid"] = $_POST["issues_list"];
$aa["fl_cgrt"] = $_POST["fl_cgrt"]; $aa["fl_cgid"] = $_POST["fl_cgid"];  $aa["fl_tliss"] = $_POST["fl_tliss"];


if ( ($_POST["fl"] == "del") && (isset($_POST["ed_rid"])) ) {
	$aa["fl"] = 1;
	$query = "DELETE FROM RL_Universal WHERE id = '".$_POST["ed_rid"]."'";
	$dbh->query($query);
	$message .= "Ограничение удалено";
}

//	Вход в редактирование записи
if ($_POST["fl"] == "edit") {
	if (isset($_SESSION["client"]) && ($_SESSION["client"] > 0)) {
		$aa["fl"] = 1; $aa["mode"] = "edit"; $aa["ed_rid"] = $_POST["ed_rid"];
	
		$query = "SELECT CORG, CORGid, RestrictType, IssueRid, TypesList, LimitType, Min, Max 
						FROM RL_Universal WHERE id = '".$aa["ed_rid"]."' AND ClientId = '".$_SESSION["client"]."'";
		foreach($dbh->query($query) as $row) {
			$aa["CORG"] = $row["CORG"]; $aa["rtype"] = $row["RestrictType"];
			$aa["cbtypes"] = explode(";", $row["TypesList"]); $aa["ltype"] = $row["LimitType"]; 
			$aa["minval"] = $row["Min"]; $aa["maxval"] = $row["Max"];
			$aa["cgrid"] = $row["CORGid"]; $aa["issueid"] = $row["IssueRid"];
		}
	} else {
		$message = "Клиент не выбран.";
	}	
}

//	Добавление или редактирование записи
if ($_POST["fl"] == "add") {
	if (isset($_SESSION["client"]) && ($_SESSION["client"] > 0)) {	
		$cbt = ""; foreach ($aa["cbtypes"] as $t) $cbt .= $t.";";
		$aa["fl"] = 1;
		if (!isset($_POST["corg_list"]) || (($_POST["rtype"] == 'I') && !isset($_POST["issues_list"])) ||
			(($_POST["rtype"] != 'I') && ($cbt == "")) || !isset($_POST["minval"]) || !isset($_POST["minval"])) {
				$message .= "Не заданы все обязательные параметры (эмитент или группа, список типов бумаг или выпуск, размер ограничений)";
			} else {			
				$query = "EXEC [RL_U_AddUpdate] @ClientId = ".$_SESSION["client"].", @CORG = '".$_POST["CORG"]. "', @CORGid = '".$_POST["corg_list"]."'".
						", @RestrictType = '".$_POST["rtype"]."', @IssueRid = ".($_POST["rtype"] == 'I' ? "'".$_POST["issues_list"]."'" : 'NULL').
						", @TypesList = ".($_POST["rtype"] == 'I' ? "NULL" : "'".$cbt."'").", @LimitType = '".$_POST["ltype"]."'".
						", @Min = ".$_POST["minval"].", @Max = ".$_POST["maxval"].
						( (isset($_POST["ed_rid"]) && ($_POST["ed_rid"] != "")) ? ", @Ridtodel = '".$_POST["ed_rid"]."'" : "");
				$dbh->query($query);
				$message .= "Ограничение сохранено";					
			}
	} else {
		$message = "Клиент не выбран.";
	}
}

//	Массовое копирование
if ($_POST["fl"] == "copyall") {
	$aa["fl"] = 1;
	$aa["cb"] = $_POST["cb"];
	foreach ($aa["cb"] as $k => $v) {
		$query = "EXEC [RL_U_CopyToClient] @Rid = '".$_POST["rid"][$k]."', @ClientTo = ".$_POST["copytocl"];
		$dbh->query($query);
	}
	$message .= "Ограничения скопированы(".count($aa["cb"]).")";
}

//	Получаем названия для контрагентов или групп и выпусков
if ($aa["fl"] == 1) {
	if ($aa["CORG"] == "G") { 
		$query = "SELECT [Rid] AS [rid], [GroupName] AS [name] FROM [dbo].[CL_Groups] WHERE [Rid] = '".$aa["cgrid"]."'";
	} else {  
		$query = "SELECT [rid], [name] FROM [dbo].[_CL_Contragents] WHERE [rid] = '".$aa["cgrid"]."'";
	}
	foreach($dbh->query($query) as $row) $aa["cgname"] = $row["name"];		
	if ($aa["rtype"] == 'I') {
		$query = "SELECT [rid], [FullName] FROM [dbo].[_CL_URL_issues] WHERE [emitents_id]='".$aa["cgrid"]."' ORDER BY [FullName]";
		foreach($dbh->query($query) as $row) $aa["issues"][$row["rid"]] = $row["FullName"];		
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
	$cb_types = explode(";", $row["TypesList"]);
	$row["TLNames"] = "";
	foreach ($cb_types as $k => $v) if ($v != "") $row["TLNames"] .= $cbtypes[$v]."<br>";
	$rlu[$row["id"]] = $row;	
}


$smarty->assign("clients", $clients);
$smarty->assign("cbtypes", $cbtypes);
$smarty->assign("message", $message);
$smarty->assign("aa", $aa);
$smarty->assign("rlu", $rlu);

$smarty->display("../lc/templates/rl_universal.tpl");




?>