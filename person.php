<?php

include("incl/s_header.php");

include("incl/s_struct_func.php");

$ts = time();
$today = mktime(0, 0, 0, date("m", $ts), date("d", $ts), date("Y", $ts));


$curr_pid = $_REQUEST["id"];
$pers = $people[$curr_pid];

if ( (is_admin(8)) && (strlen($_REQUEST["save_btn"]) > 0) ) {
    $hide = ($_REQUEST["hide"] > 0 ? 1 : 0);
    $alt = ($_REQUEST["alt_photo"] > 0 ? 1 : 0);
    $dbh_my->query("EXEC AddUpdate_hp @id = '".$curr_pid."', @hide = ".$hide.", @alt = ".$alt); 
    $altfile = $_SERVER['DOCUMENT_ROOT']."\photo_alt\\".alt_photo($curr_pid);
    $hidden_people[$curr_pid]['hide'] = $hide;
    $hidden_people[$curr_pid]['use_alt'] = $alt;
    if ($_REQUEST['del_alt'] > 0) {
        unlink($altfile);    
    } else {
        $upl_file = $_FILES['photo_file']; 
        if ($upl_file['type'] == 'image/jpeg') move_uploaded_file($upl_file['tmp_name'], $altfile);
    }
}


$condition = "WHERE [ФизическоеЛицоСсылка] = '".$curr_pid."' AND [КоличествоДней] > 0 AND [Проведен] = 1
                    AND (([ДатаНачала] <= '".date("Ymd", $today)."') AND ([ДатаОкончания] >= '".date("Ymd", $today)."'))";

$query = "  SELECT [ВидОтпускаНаименование], [ДатаНачала], [ДатаОкончания] FROM [Обмен1С_Отпуска] ".$condition."          
            UNION
            SELECT 'Командировка' AS [ВидОтпускаНаименование], [ДатаНачала], [ДатаОкончания] FROM [Обмен1С_Командировки] ".$condition."
            UNION
            SELECT 'Больничный' AS [ВидОтпускаНаименование], [ДатаНачала], [ДатаОкончания] FROM [Обмен1С_БольничныеЛисты] ".$condition."
            ORDER BY [ДатаНачала]";
                        
unset($cv);
foreach($dbh->query($query) as $row) $cv = $row;

$im_fn = PH_PATH.main_photo($curr_pid);
$im_sz = @getimagesize($im_fn);
$w = $im_sz[0]; $h = $im_sz[1];
$s_max = max($w, $h);
if ($s_max > IMG_B_SIZE ) {
    $w = round(IMG_B_SIZE * $w / $s_max); $h = round(IMG_B_SIZE * $h / $s_max);
}
if ($w <= 0) $w = IMG_B_SIZE; if ($h <= 0) $h = IMG_B_SIZE;

$im_fn_alt = PH_ALT_PATH.alt_photo($curr_pid);
$im_sz = @getimagesize($im_fn_alt);
$w_alt = $im_sz[0]; $h_alt = $im_sz[1];
$s_max_alt = max($w_alt, $h_alt);
if ($s_max_alt > IMG_B_SIZE ) {
    $w_alt = round(IMG_B_SIZE * $w_alt / $s_max_alt); $h_alt = round(IMG_B_SIZE * $h_alt / $s_max_alt);
}
if ($w_alt <= 0) $w_alt = IMG_B_SIZE; if ($h_alt <= 0) $h_alt = IMG_B_SIZE;


$smarty->assign("curr_pid", $curr_pid);
$smarty->assign("is_adm_8", is_admin(8));
$smarty->assign("is_hp", is_hp($curr_pid));
$smarty->assign("is_alt", is_alt($curr_pid));
$smarty->assign("pers", $pers);
$birth = explode("-", $pers["BIRTHDAY"]);
$smarty->assign("birth", $birth[2]." ".$monthes[$birth[1]]);

$smarty->assign("w", $w);
$smarty->assign("h", $h);
$smarty->assign("im_fn", $im_fn);

$smarty->assign("w_alt", $w_alt);
$smarty->assign("h_alt", $h_alt);
$smarty->assign("im_fn_alt", $im_fn_alt);

if (isset($cv)) { 
    $vactxt = ($cv['ВидОтпускаНаименование'] == '' ? "Основной отпуск" : $cv['ВидОтпускаНаименование'])." с ".$cv['ДатаНачала']." по ".$cv['ДатаОкончания'];     
} else {
    $vactxt = "";
}

$smarty->assign("vactxt", $vactxt);
$smarty->assign("currdep", s_ReturnStructHTML($pers["STRUCTURE"], $curr_pid));
$smarty->display("person.tpl");




?>