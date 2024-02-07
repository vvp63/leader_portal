<?php

include("incl/s_header.php");

$wd_array = array('Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье');

$ts = (isset($_REQUEST["ts"]) ? $_REQUEST["ts"] : time());
$lastmonth = mktime(0, 0, 0, date("m", $ts), 1, date("Y", $ts));
$nextmonth = mktime(0, 0, 0, date("m", $ts) + 1, 1, date("Y", $ts));
$prevmonth = mktime(0, 0, 0, date("m", $ts) - 1, 1, date("Y", $ts));
$today = mktime(0, 0, 0, date("m", $ts), date("d", $ts), date("Y", $ts));
$w_s = (date('w', $ts) == 1) ? $today : strtotime('last monday', $ts);
$w_e = $w_s + 7 * 86400;

if (isset($_REQUEST["roomid"])) {
    if ($_REQUEST["roomid"] == 0) unset($_SESSION["roomid"]);
    else
        $_SESSION["roomid"] = $_REQUEST["roomid"];
}

$rooms = array();
foreach($dbh_my->query("select * from meeting_rooms") as $row) $rooms[$row["id"]] = $row;

if (is_admin(1)) {
    if (strlen($_POST["del"])) $dbh_my->query("delete from meetings where id = ".$_POST["delid"]); 
}

   
$meetings = array();
if (isset($_SESSION["roomid"])) {
    $curr_room = $rooms[$_SESSION["roomid"]]; 
    foreach($dbh_my->query("select * from meetings where room_id = ".$_SESSION["roomid"]." and time_begin >= ".$w_s." and time_begin < ".$w_e) as $row) 
        $meetings[$row["id"]] = $row;     
} else {
     foreach($dbh_my->query("select * from meetings where time_begin >= ".$lastmonth." and time_begin < ".$nextmonth."order by time_begin" ) as $row) 
        $meetings[$row["id"]] = $row;      
}

$calend = array();
for ($i = 0; $i < 7; $i++) {
    $cts = $w_s + 86400 *$i;
    $calend[$i]["ts"] = $cts; 
    $calend[$i]["w_d"] = $wd_array[date('N', $cts) - 1];
    $calend[$i]["date"] = date('d.m.Y', $cts);
}

$ints = array();
$j=0;
$tts = $curr_room["beg_time"];
while ($tts < $curr_room["end_time"]) {
    $ints[$j++] = $tts;        
    $tts = $tts + $curr_room["time_incr"];
}


function in_meeting($int_ts) {
    global $meetings;
    global $rooms;
    $res = array();
    $res['num'] = 0; $res['curr'] = 0; $res['meet_id'] = 0;
    foreach ($meetings as $k => $v) {
        $tb = $v["time_begin"];
        $ti = $rooms[$v["room_id"]]["time_incr"];
        $te = $v["time_begin"] + $v["intervals_num"] * $ti;
        if (($int_ts >= $tb) && ($int_ts < $te) && ($ti > 0)) {
           $res['num'] = $v["intervals_num"]; 
           $res['curr'] = 1 + ($int_ts - $tb) / $ti; 
           $res['meet_id'] = $v["id"];
           return($res);
        }
    }
    return $res;
}


$add_text = "";
if ((isset($_SESSION["roomid"])) && (strlen($_POST['add_btn']) > 2)) {
    
    $meetdt = strtotime($_POST['calend_dt']); $datetill = strtotime($_POST['date_till']); $everyday = $_POST['everyday'];
    $br_flag = true;
    
    while ($br_flag) {
        
        $nm_tb = $meetdt + strtotime($_POST['tb']) - $today;
        $nm_te = $meetdt + strtotime($_POST['te']) - $today;
        $int_text = date('d.m.Y H:i', $nm_tb)." - ".date('d.m.Y H:i', $nm_te);
        if ($nm_tb >= $nm_te) 
            $add_text .= "<b class=err>Границы интервала вне допустимых значений (".$int_text.")</b><br>\n";
        else {
            $im_b = in_meeting($nm_tb); $im_e = in_meeting($nm_te - 1);
            if (($im_b['num'] != 0) || ($im_e['num'] != 0)) 
                $add_text .= "<b class=err>Интервал ".$int_text." уже занят</b><br>\n";
            else {
                if (strlen($_POST['person']) < 2)
                    $add_text .= "<b class=err>Не задан пользователь, осуществляющий бронирование</b><br>\n";
                else {
                    $int_num = ($curr_room["time_incr"] > 0 ? ($nm_te - $nm_tb) / $curr_room["time_incr"] : 0);
                    $query = "INSERT INTO meetings(room_id, time_begin, intervals_num, person, comment) VALUES
                        (".$_SESSION["roomid"].", ".$nm_tb.", ".$int_num.", '".$_POST['person']."', '".$_POST['comment']."')"; 
                    $dbh_my->query($query);          
                    $add_text .= "Интервал ".$int_text." добавлен<br>\n"; 
                    
                    //  Mailer
                    //	$to      = 'V.Poliektov@leader-invest.ru';
                    //	$subject = 'Бронирование переговорных';
                    //	$message = $add_text;
                    //	$headers = 'From: portal@leader-invest.ru';
                    //	mail($to, $subject, $message, $headers);
                    //  Mailer end
                    
                    
                    foreach($dbh_my->query("select * from meetings where room_id = ".$_SESSION["roomid"]." and time_begin >= ".$w_s." and time_begin < ".$w_e) as $row) 
                        $meetings[$row["id"]] = $row;                                           
                }             
            }             
        }        
        
        $meetdt += 86400;
        if (($everyday != 1) || ($meetdt > $datetill)) $br_flag = false;
    }      
}

$in_meet = array();
foreach ($ints as $k=>$v) {
    foreach ($calend as $kd=>$d) { 
        $i_ts = $d["ts"] + $v;
        $in_meet[$i_ts] = in_meeting($i_ts);
    } 
}

$smarty->assign("curr_room", $curr_room);
$smarty->assign("add_text", $add_text);
$smarty->assign("ti", $rooms[$_SESSION["roomid"]]["time_incr"]);
$smarty->assign("is_adm_1", is_admin(1));
$smarty->assign("ts", $ts);
$smarty->assign("ints", $ints);
$smarty->assign("people", $people);
$smarty->assign("w_s", $w_s);
$smarty->assign("calend", $calend);
$smarty->assign("rooms", $rooms);
$smarty->assign("in_meet", $in_meet);

$smarty->assign("prevmonth", $prevmonth);
$smarty->assign("lastmonth", $lastmonth);
$smarty->assign("nextmonth", $nextmonth);
$smarty->assign("prevmonth_rus", $month_rus[date('n', $prevmonth)-1]);
$smarty->assign("lastmonth_rus", $month_rus[date('n', $lastmonth)-1]);
$smarty->assign("nextmonth_rus", $month_rus[date('n', $nextmonth)-1]);
$smarty->assign("today", $today);
$smarty->assign("meetings", $meetings);

$smarty->display("meeting.tpl");


?>