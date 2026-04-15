<?php

include("incl/s_header.php");
include("incl/s_struct_func.php");

const PERS_PER_PAGE = 10;
const PAGES_AROUND = 3;

$curr_page = 1;
if (!is_null($_REQUEST['page'])) $curr_page = $_REQUEST['page'];

if (strlen($_POST['find_btn']) >= 2) {
	$_SESSION['find_pers'] = $_POST['ft'];
} else {
	if (is_null($_REQUEST['page'])) $_SESSION['find_pers'] = "";
}

$pers_show = array();
$i = 0;
foreach ($people as $k=>$v) {
    if ((is_admin(8)) || (!is_hp($k))) {
        $str_find = mb_strtolower(" ".$v["FAMILY"]." ".$v["NAME"]." ".$v["SNAME"]);
        if ((strlen($_SESSION['find_pers']) < 1) || (strpos($str_find, mb_strtolower($_SESSION['find_pers'])))) {
            if (($i >= ($curr_page - 1) * PERS_PER_PAGE) && ($i < $curr_page * PERS_PER_PAGE)) $pers_show[$k] = $v;     
            $i++;
        }
    }
}

$pers_show = PersIS($pers_show);
    
$max_page = ceil($i / PERS_PER_PAGE);


$smarty->assign("perstable", s_PersTable($pers_show, ''));
$smarty->assign("gid", $general_id);
$smarty->assign("max_page", $max_page);
$smarty->assign("curr_page", $curr_page);
$smarty->assign("pages_around", PAGES_AROUND);
$smarty->assign("p", max($curr_page - PAGES_AROUND, 1));
$smarty->assign("p_end", min($curr_page + PAGES_AROUND, $max_page));

$smarty->display("persons.tpl");




?>