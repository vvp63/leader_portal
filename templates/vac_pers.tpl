<html>
<head>
    <meta charset="UTF-8">
	<title>Отсутствия сотрудника</title>
    <link rel="stylesheet" href="css/leader_site.css">	
	<script>
	function Filter() {
		var vcount = document.getElementById("vcount").value;
	}

	</script>

</head>

<body>

{if $is_adm_8}
<h2>{$pers.FAMILY} {$pers.NAME} {$pers.SNAME}</h1><br>

<input type=hidden id=vcount value={$vac|count}>


<table class=v3 style='margin: 5px;'>
<tr>
	<td class=vts>Вид отпуска</td>
	<td class=vts>Дата начала</td>
	<td class=vts>Количество дней</td>
	<td class=vts>Дата окончания</td>
</tr>
{foreach from=$vac key=k item=v}
<tr id=vac[{$k}]><input type=hidden id=vt[{$k}] value='{$v.Type}'>
	<td class=v{$v.Type} style='white-space: nowrap; padding: 2;'>{$v.name}</td>
	<td class=vtu>{$v.beg}</td>
	<td class=vtu>{$v.qty}</td>
	<td class=vtu>{$v.end}</td>
</tr>
{/foreach}
</table>


{/if}




</body>
</html>