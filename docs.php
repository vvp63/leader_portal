<?php

include("incl/s_header.php");

error_reporting(E_ALL);

$docsdir = $_SERVER['DOCUMENT_ROOT']."\docs\\";

const DOCS_PER_PAGE = 10;
const PAGES_AROUND = 2;
const DOCS_PATH = "./docs/";

$ts = time();
$today = mktime(0, 0, 0, date("m", $ts), 1, date("Y", $ts));
$td_date = date("Y", $ts)."-".date("m", $ts)."-".date("d", $ts);


//  ------- DOWNLOAD NEW DOC --------- //
$message = '';
if (is_admin(2)) {
    
    if ($_POST['del'] == 'delete') {
        $dbh_my->query("DELETE FROM upl_docs WHERE id = ".$_POST['doc_id']); 
        unlink($docsdir.$_POST['doc_name']);
    }
    
    if (isset($_FILES['userfile']) && $_FILES['userfile']['error'] === UPLOAD_ERR_OK) {
        $fileTmpPath = $_FILES['userfile']['tmp_name'];
        $filename = $_FILES['userfile']['name']; 
        $dest_path = $docsdir.$filename;
        $fileNameCmps = explode(".", $filename);
        $fileExtension = strtolower(end($fileNameCmps));
        if(move_uploaded_file($fileTmpPath, $dest_path))
        {
            $query = "DELETE FROM upl_docs WHERE filename = '".$filename."'";
            $dbh_my->query($query);
            $query = "INSERT INTO upl_docs(filename, extention, date, size, comment) VALUES 
                    ('".$filename."', '".$fileExtension."', '".$_POST['upl_date']."', ".$_FILES['userfile']['size'].", '".$_POST['comment']."')";
            $dbh_my->query($query);
            $message = 'Загружен файл <i>'.$filename.'</i>';
        }
        else {
            $message = '<b class=err>Ошибка загрузки файла</b>';  
        }
    }
}

//  ----- EXISTING DOCS --------- //


if (strlen($_POST['find_btn']) >= 0) $_SESSION['find_doc'] =  $_POST['ft'];
//if (strlen($_POST['clr_btn']) > 2) $_SESSION['find_doc'] = '';

if (strlen($_SESSION['find_doc']) <= 0) $query = "SELECT * FROM upl_docs ORDER BY date DESC";
else $query = "SELECT * FROM upl_docs WHERE filename LIKE '%".$_SESSION['find_doc']."%' OR comment LIKE '%".$_SESSION['find_doc']."%' ORDER BY date DESC"; 
$docs = array();
foreach($dbh_my->query($query) as $row) $docs[] = $row;


$curr_page = 1;
if (!is_null($_REQUEST['page'])) $curr_page = $_REQUEST['page']; 

$docs_show = array();
foreach ($docs as $k=>$v) 
    if (($k >= ($curr_page - 1) * DOCS_PER_PAGE) && ($k < $curr_page * DOCS_PER_PAGE)) $docs_show[] = $v;
    
$max_page = ceil(count($docs) / DOCS_PER_PAGE);


$smarty->assign("is_adm_2", is_admin(2));
$smarty->assign("td_date", $td_date);
$smarty->assign("docs_show", $docs_show);
$smarty->assign("docs_path", DOCS_PATH);
$smarty->assign("message", $message);

$smarty->assign("max_page", $max_page);
$smarty->assign("curr_page", $curr_page);
$smarty->assign("pages_around", PAGES_AROUND);
$smarty->assign("p", max($curr_page - PAGES_AROUND, 1));
$smarty->assign("p_end", min($curr_page + PAGES_AROUND, $max_page));

$smarty->display("docs.tpl");




?>