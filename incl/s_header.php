<?php

include("incl/sql_connect.php");

include('smarty/libs/Smarty.class.php');

const PH_PATH = "./photo_1c/";
const PH_ALT_PATH = "./photo_alt/";
const IMG_S_SIZE = 150;
const IMG_B_SIZE = 450;

$monthes = array("01"=>"Января", "02"=>"Февраля", "03"=>"Марта", "04"=>"Апреля", "05"=>"Мая", "06"=>"Июня",
                 "07"=>"Июля", "08"=>"Августа", "09"=>"Сентября", "10"=>"Октября", "11"=>"Ноября", "12"=>"Декабря");

// Уровни админа. 1 - бронирование переговорных, 2 - загрузка документов, 4 - структура компании и карточки сотрудников, 8 - карточки пользователей
unset($_SESSION["admin"]);
foreach($dbh_my->query("select * from admins where level > 0 and login = '".$_SERVER['LOGON_USER']."'") as $row) $_SESSION["admin"] = $row;

if (isset($_POST["ch_adm"])) {
    if (isset($_SESSION["hide_adm"])) {
        $_SESSION["hide_adm"] = 1 - $_SESSION["hide_adm"];        
    } else {
        $_SESSION["hide_adm"] = 1;
    }   
}

if (!isset($_SESSION["hide_adm"])) $_SESSION["hide_adm"] = 1;


function is_admin($level) {
    return (($level & $_SESSION["admin"]["level"]) > 0) && ($_SESSION["hide_adm"] != 1);
}

function is_hs($id) {
    global $hidden_struct;
    return ($hidden_struct[$id] > 0);
}

function is_hp($id) {
    global $people, $hidden_people;
    return ($hidden_people[$id]['hide'] > 0); //  || (is_hs($people['STRUCTURE']));
}

function is_alt($id) {
    global $hidden_people;
    return ($hidden_people[$id]['use_alt'] > 0);
}

function main_photo($id) {
    return substr(md5($id."A"), 2, 8)."_".$id.".jpg";
}

function alt_photo($id) {
    return substr(md5($id."X"), 2, 8)."_".$id.".jpg";
}


$smarty = new Smarty;
$smarty->debugging = false;
$smarty->caching = false;

$links = array( "struct"=>"/structure.php", 
                "persons" => "/persons.php",
                "docs" => "/docs.php",
                "blanks" => "/blanks.php", 
                "vac" => "/vacations.php",
                "meet" => "/meeting.php",
                "pers" => "/person.php",
                "idx" => "/index.php",
                "birth" => "/birthdays.php"
            );

$menu = array(  $links["struct"]=>"Структура компании", 
                $links["persons"]=>"Сотрудники",
                $links["docs"]=>"Распорядительные документы",
                $links["blanks"]=>"Бланки документов", 
                $links["vac"]=>"График отсутствий",
                $links["meet"]=>"Бронирование переговорных"
            );
            
$month_rus = array("Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь");

$smarty->assign("links", $links);
$smarty->assign("menu", $menu);
$smarty->assign("class_idx", ($_SERVER['SCRIPT_NAME'] == $links["idx"]) ? "_idx" : "");
$smarty->assign("is_admin", is_admin(255));


?>




