<?php

//const MAX_SIZE = 100;

$treestruct = array();
$treenum = 0;
RecurseGetChild($initial_id, 0);

function DepExists($depid) {
    global $struct;
    $res = array("id"=>$depid, "name"=>"");
    foreach ($struct as $key=>$value) if ($key == $depid) {
        $res["name"] = $value["NAME"];
        return $res;
    }
    foreach ($struct as $key=>$value) if ($value["PARENT"] == "-") {
        $res["id"] = $key;
        $res["name"] = $value["NAME"];
        return $res;
    }  
    $res["id"] = "";  
    return $res;
}

function GetChildren($depid) {
    global $struct;
    $children = array();
    foreach ($struct as $key=>$value) if ((!is_hs($key)) && ($value["PARENT"] == $depid)) $children[$key] = $value["NAME"];         
    return $children; 
}

function ParentsTree($depid) {
    global $struct;
    $i = 0;
    $arr[$i] = array("id" => $depid, "name" => $struct[$depid]["NAME"], "parent" => $struct[$depid]["PARENT"]);
    while (strlen($arr[$i]["parent"]) > 3) {
        $parid = $arr[$i]["parent"];
        $arr[++$i] = array("id" => $parid, "name" => $struct[$parid]["NAME"], "parent" => $struct[$parid]["PARENT"]);
    }
    return $arr;
}

function RecurseGetChild($depid,  $lev) {
    global $struct;
    global $treestruct;
    global $treenum;
    $treestruct[$treenum++] = array("lev" => $lev, "id" => $depid, "name" => $struct[$depid]["NAME"]);
    foreach ($struct as $key=>$value) if ($value["PARENT"] == $depid) RecurseGetChild($key, $lev + 1); 
  
}

function GetPeople($depid) {
    global $people;
    $arr = array();
    foreach ($people as $k=>$v) 
    if ((is_admin(8)) || (!is_hp($k))) {
        if ($v["STRUCTURE"] == $depid) $arr[$k] = $v;
    }   
    return $arr;
}


function PersIS($persons) {
    $result = array();
    foreach ($persons as $k=>$v) {
        $result[$k] = $v;
        if (is_alt($k)) {
            $im_fn = PH_ALT_PATH.alt_photo($k);
        } else {
            $im_fn = PH_PATH.main_photo($k);
        }
        
        $im_sz = @getimagesize($im_fn);
        $w = $im_sz[0]; $h = $im_sz[1];
        $s_max = max($w, $h);
        if ($s_max > IMG_S_SIZE) {
            $w = round(IMG_S_SIZE * $w / $s_max); $h = round(IMG_S_SIZE * $h / $s_max);
        }
        if ($w <= 0) $w = IMG_S_SIZE; if ($h <= 0) $h = IMG_S_SIZE;  
        $result[$k]["fn"] = $im_fn;     
        $result[$k]["pw"] = $w; $result[$k]["ph"] = $h;     
    }  
    return $result;   
}


//  --------------------------- TEMPLATE ----------------------- //


function s_PersTable($persons, $sel_person) {
    $result = array();       
    foreach ($persons as $key=>$value) {
        if ((is_admin(8)) || (!is_hp($k))) {
            $result[$key]["width"] = $value["pw"];
            $result[$key]["height"] = $value["ph"];
            $result[$key]["src"] = $value["fn"];
            $result[$key]["sel"] = ($key == $sel_person ? "_sel" : "");
            $result[$key]["hide"] = is_hp($key);
            $result[$key]["fio"] = $value["FAMILY"]." ".$value["NAME"]." ".$value["SNAME"];
            $result[$key]["position"] = $value["POSITION"];
            $result[$key]["phone"] = $value["WorkPhone"];
        }
    }       
    return $result; 
}


function s_ReturnStructHTML($curr_depid, $sel_person) {
    
    global $initial_id;

    $result = array();
    
    if ((is_admin(4)) || (!is_hs($curr_depid))) {

        $currdep = DepExists($curr_depid);
        $chld = GetChildren($currdep["id"]);
        $parents = ParentsTree($currdep["id"]);
        $persons = GetPeople($currdep["id"]);       
        $persons = PersIS($persons);
        
        for ($i = (count($parents) - 1); $i >= 0; $i--) {
            if (!is_hs($parents[$i]["id"])) {
                if ($i == 0) $result["topline"][$i] = array("link" => "", "name" => $parents[$i]["name"]);
                else $result["topline"][$i] = array("link" => ($parents[$i]["id"] == $initial_id ? "" : $parents[$i]["id"]), "name" => $parents[$i]["name"]);                  
            }
        }  
        $result["parnum"] = count($parents) - 1;        
        $result["chld"] = $chld;  
        $result["persons"] = s_PersTable($persons, $sel_person);        

    }   
    return $result;
}



function s_ReturnTreeHTML() {
    global $treestruct, $hidden_struct;
    $result = array();
    $result["is_adm_4"] = is_admin(4);
    foreach ($treestruct as $key => $value) {
        $result["tree"][$key]["id"] = $value["id"];
        $result["tree"][$key]["lev"] = $value["lev"];
        $result["tree"][$key]["name"] = $value["name"];
        $result["tree"][$key]["hide"] = is_hs($value["id"]);   
    }   
    return $result;
}



?>