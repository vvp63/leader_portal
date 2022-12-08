<?php

include("incl/s_header.php");
include("incl/s_struct_func.php");


$ts = time();
$today = mktime(0, 0, 0, date("m", $ts), date("d", $ts), date("Y", $ts));

$birthdays = array();
$persons = PersIS($people);

for ($i = 0; $i < 366; $i++) {
    $d = $ts + 86400 * $i;
    $day = date("d", $d);
    $month = date("m", $d);
    $birth_key = $day." ".$monthes[$month];
    $birth_people = array();
    foreach ($persons as $k=>$v) 
        if (!$v["is_hp"]) {
            $birth = explode("-", $v["BIRTHDAY"]);
            if (($day == $birth[2]) && ($month == $birth[1])) $birth_people[$k] = $v;           
        }
    if (count($birth_people) > 0) $birthdays[$birth_key] = $birth_people;    
}

//print_r($birthdays);

$smarty->assign("birthdays", $birthdays);
$smarty->display("birthdays.tpl");




?>