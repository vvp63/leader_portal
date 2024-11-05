<?php

include('../smarty/libs/Smarty.class.php');

$dbh = null;

try {
    $dbh = new PDO('sqlsrv:server=co1-vp-lc1 ; Database=LC3_dev', 'lc_web', 'lc_web_123');     
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}

$smarty = new Smarty;


?>