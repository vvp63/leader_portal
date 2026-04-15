<?
include("incl/s_header.php");

if (!is_admin(8)) die();

$curr_pid = $_REQUEST["id"];
$pers = $people[$curr_pid];

$query = "SELECT v.[ВидОтпускаНаименование] AS [name], v.[ДатаНачала] AS [beg], v.[КоличествоДней] AS [qty], v.[ДатаОкончания] AS [end], v.[Type] FROM 
			(
				SELECT [ФизическоеЛицоСсылка], 
					CASE WHEN [ВидОтпускаНаименование] = '' 
							THEN 'Основной (За период с ' + CONVERT(varchar, [НачалоПериодаЗаКоторыйПредоставляетсяОтпуск]) + ' по ' + CONVERT(varchar, [КонецПериодаЗаКоторыйПредоставляетсяОтпуск]) + ')' 
							ELSE [ВидОтпускаНаименование]  END AS [ВидОтпускаНаименование]
						,[ДатаНачала], [КоличествоДней], [ДатаОкончания], CASE WHEN [ВидОтпускаНаименование] = '' THEN 'v' ELSE 'a' END AS [Type]
				FROM [Обмен1С_Отпуска]     
				UNION
				SELECT [ФизическоеЛицоСсылка], 'Командировка' AS [ВидОтпускаНаименование]
						,[ДатаНачала], [КоличествоДней], [ДатаОкончания], 'k' AS [Type]
				FROM [Обмен1С_Командировки]
				UNION
				SELECT [ФизическоеЛицоСсылка], 'Больничный' AS [ВидОтпускаНаименование]
						,[ДатаНачала], [КоличествоДней], [ДатаОкончания], 'b' AS [Type]
				FROM [Обмен1С_БольничныеЛисты]
			) AS v
			WHERE v.[ФизическоеЛицоСсылка] = '".$curr_pid."' ORDER BY v.ДатаНачала desc";

$vac = array(); $i = 0;
foreach($dbh->query($query) as $row) $vac[$i++] = $row;

$smarty->assign("curr_pid", $curr_pid);
$smarty->assign("is_adm_8", is_admin(8));
$smarty->assign("pers", $pers);
$smarty->assign("vac", $vac);

$smarty->display("vac_pers.tpl");

?>