<?php

$dbh = null;

try {
    $dbh = new PDO('sqlsrv:server=co1-vp-inf1 ; Database=IO_INF', '1C_Writer', 'shou-sliscorg-38');
    $dbh_my = new PDO('sqlsrv:server=co1-vt-dru1 ; Database=testportal', 'php', 'portal_63_test');       
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}

$initial_id = "56990d26-88df-11e8-838f-9c5c8ecdeaed";
$struct = array();
$struct[$initial_id]["NAME"] = 'ЗАО "Лидер"';
$struct[$initial_id]["PARENT"] = "-"; 

$parent_query = "SELECT t.[Ссылка] AS id, t.[Наименование] AS [NAME], t.[РодительСсылка] AS [PARENT] FROM
                (
                SELECT ROW_NUMBER() OVER (PARTITION BY [Ссылка] ORDER BY [ОбменНомер] DESC) AS Num
                      ,[Ссылка]
                      ,[Наименование]
                      ,[РодительСсылка]
                      ,[ПометкаУдаления]
                  FROM [IO_INF].[dbo].[Обмен1С_ПодразделенияОрганизаций]
                  WHERE [ПометкаУдаления] = 0
                  ) AS t
                  WHERE t.Num = 1
                  ORDER BY t.[Наименование]";  
                  
foreach ($dbh->query($parent_query) as $row) {
    $id = mb_strtolower($row["id"]);
    $struct[$id]["NAME"] = $row["NAME"];
    $struct[$id]["PARENT"] = ((strlen($row["PARENT"]) > 1) ? mb_strtolower($row["PARENT"]) : $initial_id);       
} 

$hidden_struct = array();
foreach ($dbh_my->query("select id from hide_struct") as $row) $hidden_struct[mb_strtolower($row["id"])] = 1;

foreach ($struct as $i=>$k) $struct[$i]["is_hs"] = is_hs($i);

$people = array();

$persons_query = "SELECT v1.[ФизическоеЛицоСсылка] AS [id], v1.[ФизическоеЛицоФамилия] AS [FAMILY]
                  ,v1.[ФизическоеЛицоОтчество] AS [SNAME], v1.[ФизическоеЛицоИмя] AS [NAME]
                  ,v1.[ФизическоеЛицоДатаРождения] AS [BIRTHDAY], v1.[ПодразделениеСсылка] AS [STRUCTURE]
                  ,t1.pos_name AS [POSITION], v1.[ТелефонРабочий] AS [WorkPhone]
                  ,v1.[EMailФизическиеЛица] AS [WorkEmail], v1.[Кабинет] AS [WorkCabinet]
                  ,v1.[ДатаПриема] AS [HireDate], v1.[ДатаУвольнения] AS [FireDate]
                    FROM [IO_INF].[dbo].[View_Обмен1С_АктуальныеСотрудники] AS v1 LEFT JOIN 
                     (
                    	SELECT t.* FROM
                    		(SELECT ROW_NUMBER() OVER (PARTITION BY [Ссылка] ORDER BY [ОбменДатаВремя] desc) AS rn
                    			  ,[Ссылка] AS id
                    			  ,[Наименование] AS pos_name
                    		FROM [IO_INF].[dbo].[Обмен1С_Должности]) AS t
                    	WHERE t.rn = 1 
                     ) AS t1
                      ON (v1.[ДолжностьСсылка] = t1.[id])
                      WHERE v1.[ДатаУвольнения] IS NULL
                      ORDER BY v1.[ФизическоеЛицоФамилия], v1.[ФизическоеЛицоИмя]";
                      
foreach ($dbh->query($persons_query) as $row) {
    $id = mb_strtolower($row["id"]);
    $parent_str = mb_strtolower($row["STRUCTURE"]);
    $people[$id] = $row;
    $people[$id]["STRUCTURE"] = $parent_str;
    $people[$id]["PHOTO"] = $id.".jpg";  
}

$hidden_people = array();
foreach ($dbh_my->query("select id, hide, use_alt from hide_person") as $row) $hidden_people[mb_strtolower($row["id"])] = $row;

foreach ($people as $i=>$k) $people[$i]["is_hp"] = is_hp($i);



?>