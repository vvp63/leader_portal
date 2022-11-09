<?php

include("incl/s_header.php");

const FILES_DIR = "./files/";

$subdir = $_GET["subdir"];

$files = scandir(FILES_DIR.$subdir);

$files_ord = array();
$i=0;

foreach ($files as $key => $value) {
    if (!in_array($value, array(".",".."))) {
        $fullpath = FILES_DIR.$subdir."/".$value;
        if (is_dir($fullpath)) $files_ord[$i++] = array("type" => "D", "value" => $value);   
    }   
} 

foreach ($files as $key => $value) {
    if (!in_array($value, array(".",".."))) {
        $fullpath = FILES_DIR.$subdir."/".$value;
        if (is_file($fullpath)) $files_ord[$i++] = array("type" => "F", "value" => $value);   
    }   
} 

$smarty->assign("rootdir", FILES_DIR);
$smarty->assign("subdir", $subdir);
$smarty->assign("files_ord", $files_ord);

$smarty->display('blanks.tpl');



?>