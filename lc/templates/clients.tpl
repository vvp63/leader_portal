<html>
<head>
    <meta charset="UTF-8">
	<title>LC3</title>
	
    <script src="../js/jquery.js"></script>

    <script>

	function FindContr(str) {
		
		if (str.length < 2) {
			document.getElementById("contr_list").innerHTML="";
			return;
		}
		xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (this.readyState==4 && this.status==200) {
				document.getElementById("contr_list").innerHTML=this.responseText;
				document.getElementById("contr_list").size = 10;
			}
		}
		xmlhttp.open("GET","./contr_find.php?search_txt=" + encodeURIComponent(str),true);
		xmlhttp.send();
	}	
	
	function SetFndStr() {
		document.getElementById("contr_list").size = 1;
	}

    </script> 	
    

</head>

<body>

<b>Клиент</b>
<select name=client>
	{foreach from=$clients key=k item=v}
		<option value={$k}>{$v.fullname}</option>
	{/foreach}
</select>
<br>

	<input type=text width=400 id="search_txt" style="width: 500px;" onkeyup="FindContr(this.value)"><br>
	<select name="contr" id="contr_list" style="width: 500px;" onchange="SetFndStr()" onclick="SetFndStr()"></select>
</div>



<br><br>



		
</body>
