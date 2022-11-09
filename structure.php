<?php

include("incl/s_header.php");
include("incl/s_struct_func.php");

function HideStruct($id) {
    global  $struct, $dbh_my; 
    $dbh_my->query("INSERT INTO hide_struct([id]) VALUES('".$id."')");
    foreach ($struct as $k=>$v) if ($v["PARENT"] == $id) HideStruct($k);
}

$curr_depid = $_REQUEST["depid"];

if ( (is_admin(4)) && (strlen($_REQUEST["hs_btn"]) > 0) ) {
    $dbh_my->query("delete from hide_struct"); 
    foreach ($_REQUEST["hs"] as $k=>$v) if ($v == "on") HideStruct($k); 
    $hidden_struct = array();
    foreach ($dbh_my->query("select id from hide_struct") as $row) $hidden_struct[mb_strtolower($row["id"])] = 1;   
}

if ($curr_depid == '') {
    $smarty->assign("tree", s_ReturnTreeHTML());     
    $smarty->display("treestruct.tpl"); 
} else {
    $smarty->assign("currdep", s_ReturnStructHTML($curr_depid, ''));
    $smarty->display("currdep.tpl");      
}



?>