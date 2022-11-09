<?php

error_reporting(E_ALL);

const PHOTO_PATH = "./photo_1c/";

include("incl/s_header.php");

$n = 0;
$not_empty = true;
const PP_QUERY = 20;
$currid = 0;

if (is_admin(64)) {
    
    while ($not_empty) {
        
        print($n." ".date("H:i:s", time())."<br>");
        
        $query = "SELECT TOP(10) [Id],[ФизическоеЛицоСсылка] AS person,[ФизическоеЛицоФото] AS photo
          FROM [IO_INF].[dbo].[Обмен1С_ФотографииФизическихЛиц] WHERE [ФизическоеЛицоФото] IS NOT NULL AND [Id] > ".$currid." ORDER BY [Id]"; 
        print($query."<br>");   
            
        $photoes = array();
        
        $not_empty = false;
        foreach ($dbh->query($query) as $row) {
            $photoes[$row["Id"]] = $row;
            $not_empty = true;
            if ($row["Id"] > $currid) $currid = $row["Id"];
        } 
        
        foreach ($photoes as $i=>$k) {
            $fn = PHOTO_PATH.main_photo(mb_strtolower($k["person"]));
            if (isset($k["photo"])) {
                print($i." ".$fn."<br>");
                $img = imagecreatefromstring($k["photo"]);
                imagejpeg($img, $fn);
                imagedestroy($img);
            }   
        }
        
        $n++;
    
    }    
    
}




?>