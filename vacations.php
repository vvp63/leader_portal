<?php

include("incl/s_header.php");

const DAY_WIDTH = 25;
const DAY_HEIGHT = 25;

$ts = ($_GET["ts"] > 0) ? $_GET["ts"] : time();

$today = mktime(0, 0, 0, date("m", $ts), date("d", $ts), date("Y", $ts));
$today2 = mktime(0, 0, 0, date("m", time()), date("d", time()), date("Y", time()));
$lastmonth = mktime(0, 0, 0, date("m", $ts), 1, date("Y", $ts));
$nextmonth = mktime(0, 0, 0, date("m", $ts) + 1, 1, date("Y", $ts));
$prevmonth = mktime(0, 0, 0, date("m", $ts) - 1, 1, date("Y", $ts));
$monthsec = $nextmonth - $lastmonth;
$days_n = $monthsec / 86400;


$vacantions = array();

$query = "  SELECT [ФизическоеЛицоСсылка], [ВидОтпускаНаименование]
                    ,[ДатаНачала], [КоличествоДней], [ДатаОкончания]
            FROM [Обмен1С_Отпуска]
                WHERE (([ДатаНачала] < '".date("Ymd", $nextmonth)."') AND ([ДатаОкончания] >= '".date("Ymd", $lastmonth)."')) AND [КоличествоДней] > 0 AND [Проведен] = 1            
            UNION
            SELECT [ФизическоеЛицоСсылка], 'Командировка' AS [ВидОтпускаНаименование]
                    ,[ДатаНачала], [КоличествоДней], [ДатаОкончания]
            FROM [Обмен1С_Командировки]
                WHERE (([ДатаНачала] < '".date("Ymd", $nextmonth)."') AND ([ДатаОкончания] >= '".date("Ymd", $lastmonth)."')) AND [КоличествоДней] > 0 AND [Проведен] = 1
            UNION
            SELECT [ФизическоеЛицоСсылка], 'Больничный' AS [ВидОтпускаНаименование]
                    ,[ДатаНачала], [КоличествоДней], [ДатаОкончания]
            FROM [Обмен1С_БольничныеЛисты]
                WHERE (([ДатаНачала] < '".date("Ymd", $nextmonth)."') AND ([ДатаОкончания] >= '".date("Ymd", $lastmonth)."')) AND [КоличествоДней] > 0 AND [Проведен] = 1
            ORDER BY [ДатаНачала]";

                               

$vac = array();
foreach($dbh->query($query) as $row) {
	$id = strtolower($row["ФизическоеЛицоСсылка"]);
	$vac[$id] = $id;
}

foreach($dbh->query($query) as $row) {
    $id = strtolower($row["ФизическоеЛицоСсылка"]);
	
    $beg = explode("-", $row["ДатаНачала"]);
    $end = explode("-", $row["ДатаОкончания"]);
    $beg_ts = mktime(0, 0, 0, $beg[1], $beg[2], $beg[0]);
    $end_ts = mktime(0, 0, 0, $end[1], $end[2] + 1, $end[0]);
    $interval = array("beg" => date("Ymd", $beg_ts), "end" => date("Ymd", $end_ts), "beg_ts" => $beg_ts, "end_ts" => $end_ts, "type" => $row["ВидОтпускаНаименование"]);
    $vacantions[$id]["fio"] = $people[$id]["FAMILY"]." ".$people[$id]["NAME"]." ".$people[$id]["SNAME"]; ;
    $vacantions[$id]["intervals"][] = $interval;   
}


$mdays = array();
$d = $lastmonth;
while ($d < $nextmonth) {
    $mdays[] = $d;
    $d += 86400;
}

// Проверяем на предмет пересечений интервалов

foreach ($vacantions as $k=>$v) {
    $last_end = null; $last_end_ts = null;
    foreach ($v["intervals"] as $j=>$ci) {
        if ($ci["beg_ts"] < $last_end_ts) {
            $vacantions[$k]["intervals"][$j]["beg"] = $last_end; $vacantions[$k]["intervals"][$j]["beg_ts"] = $last_end_ts;   
        }          
        $last_end = $ci["end"]; $last_end_ts = $ci["end_ts"];
    }    
}

// Расписываем месяц по дням
foreach ($vacantions as $k=>$v) {
    $vacantions[$k]["hide"] = is_hp($k);
    if (!is_hp($k)) {
        $vacantions[$k]["days"] = array();    
        foreach ($mdays as $i=>$d) {
            $newday = array("db" => $d, "type" => ((date("N", $d) < 6) ? "u" : "s"), "idb" => $d, "N" => 1, "title" => "");
            if ($d == $today2) $newday["type"] = "t";
            foreach ($v["intervals"] as $j=>$ci) {
                if (($d >= $ci["beg_ts"]) && ($d < $ci["end_ts"])) {
                    $newday["type"] = ($ci["type"] == "") ? "v" : ( ($ci["type"] == "Командировка") ? "k" : ( ($ci["type"] == "Больничный") ? "b" : "a") );
                    $newday["idb"] = $ci["beg_ts"];
                    $newday["N"] = (min($ci["end_ts"], $nextmonth) - max($ci["beg_ts"], $lastmonth)) / 86400;
                    $title = ($ci["type"] == "") ? "Основной отпуск" : ( ($ci["type"] == "Командировка") ? "Командировка" : ( ($ci["type"] == "Больничный") ? "Больничный" : "Дополнительный отпуск")); 
                    $title .= " (".date("d.m.Y", $ci["beg_ts"])." - ".date("d.m.Y", $ci["end_ts"] - 86400).")";      
                    $newday["title"] = $title;         
                }    
            }       
            $vacantions[$k]["days"][] = $newday;
        }
    }
}


$smarty->assign("prevmonth", $prevmonth);
$smarty->assign("lastmonth", $lastmonth);
$smarty->assign("nextmonth", $nextmonth);
$smarty->assign("lastmonth_dt", date("Ymd", $nextmonth));
$smarty->assign("nextmonth_dt", date("Ymd", $lastmonth));


$smarty->assign("prevmonth_rus", $month_rus[date('n', $prevmonth)-1]);
$smarty->assign("lastmonth_rus", $month_rus[date('n', $lastmonth)-1]);
$smarty->assign("nextmonth_rus", $month_rus[date('n', $nextmonth)-1]);
$smarty->assign("mdays", $mdays);
$smarty->assign("vacantions", $vacantions);



$smarty->display("vacations.tpl");



?>