{include file="header.tpl"}


<script>
	
	$(function() {
		$('#client').on('change', function(){
			$('#cl_from').submit();
		});	
		
		$('#CORG').on('change', function(){
			$('#search_txt').val('');
			$("#corg_list").attr("size", 1);
			$("#corg_list").html('');	
			if ($('#CORG').val() == 'G') { 
				$("#opti").attr('disabled', true); 
				$('#rtype').val('A');
				$("#d_issues").hide();
				$('#d_cbtypes').show();					
			} else { 
				$("#opti").attr('disabled', false); 
			} 
		});
				
		$('#rtype').on('change', function(){
			if ($('#rtype').val() == 'I') { 
				$('#d_cbtypes').hide();				
				$("#d_issues").show(); 
			} else { 
				$("#d_issues").hide();
				$('#d_cbtypes').show();				
			} 
		});
				
	});
	

	function FindContr(str) {	
		if (str.length < 2) {
			document.getElementById("corg_list").innerHTML="";
			return;
		}
		xmlhttp=new XMLHttpRequest();
		var body = 'search_txt=' + encodeURIComponent(str) + '&CORG=' + encodeURIComponent(document.getElementById("CORG").value);
		xmlhttp.onreadystatechange=function() {
			if (this.readyState==4 && this.status==200) {
				document.getElementById("corg_list").innerHTML=this.responseText;
				document.getElementById("corg_list").size = 10;
			}
		}
		xmlhttp.open("POST", "./s_contr_find.php", true);
		xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xmlhttp.send(body);
	}	
	
	function SetFndStr(contrid) {
		document.getElementById("corg_list").size = 1;
		xmlhttp=new XMLHttpRequest();
		var body = 'contrid=' + encodeURIComponent(contrid);
		xmlhttp.onreadystatechange=function() {
			if (this.readyState==4 && this.status==200) {
				document.getElementById("issues_list").innerHTML=this.responseText;
				document.getElementById("issues_list").size = 10;
			}
		}
		xmlhttp.open("POST", "./s_issue_find.php", true);
		xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xmlhttp.send(body);		
	}
	
	function CheckRL() {
		var cbtypes = '';
		const options = document.getElementById('cbtypes').options;
		for (let opt of options) {
			if (opt.selected) cbtypes = cbtypes + opt.value + ';';
		}
		xmlhttp=new XMLHttpRequest();
		var body = 	'CORG=' + encodeURIComponent(document.getElementById("CORG").value) + '&rtype=' + encodeURIComponent(document.getElementById("rtype").value) +
					'&corgid=' + encodeURIComponent(document.getElementById("corg_list").value) + '&cbtypes=' + encodeURIComponent(cbtypes) + 
					'&issueid=' + encodeURIComponent(document.getElementById("issues_list").value);	

		xmlhttp.onreadystatechange=function() {
			if (this.readyState==4 && this.status==200) {
				document.getElementById("check_div").innerHTML=this.responseText;
			}
		}
		xmlhttp.open("POST", "./s_check_rl.php", true);
		xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xmlhttp.send(body);
	}		

</script>

<table width=100% class=main><tr><td class=client>
<form method="POST" id="cl_from"> 
<br>
<b>Портфель клиента</b>
<select name=client id=client>
	{foreach from=$clients key=k item=v}
		<option value={$k}{if $k==$smarty.session.client} selected{/if}>{$v.fullname}</option>
	{/foreach}
</select>
</form>
</td></tr></table>
<br>

<table width=100% class=main>
<tr>
<td colspan=4 class=rltop><b>Добавить или редактировать ограничение</b></td>
</tr>
<tr>
<td class=rlform>
На <select name=CORG id=CORG>
		<option value=C>Эмитента</option>
		<option value=G>Группу</option>
	</select><br><br>
Тип ограничения&nbsp;
<select name=rtype id=rtype>
	<option value=A selected>Любая бумага из указанных типов</option>
	<option value=S>Сумма всех бумаг указанных типов</option>
	<option value=I id=opti>Конкретный выпуск</option>
</select><br>	

</td>
<td class=rlform>
Поиск <input type=text id="search_txt" class=srch onkeyup="FindContr(this.value)"><br>
<select name="corg_list" id="corg_list"  class=slct onchange="SetFndStr(this.value)" onclick="SetFndStr(this.value)"></select>
</td>
<td class=rlform>
<div id=d_cbtypes class=vis>
<select name=cbtypes[] id=cbtypes multiple size=10 class=slct>
	{foreach from=$cbtypes key=k item=v}
		<option value={$v.Value}>{$v.Name}</option>
	{/foreach}
</select><br>
</div>
<div id=d_issues class=unvis>
<select name="issues_list" id="issues_list" class=slct onchange="SetFndIssue()" onclick="SetFndIssue()"></select>
</div>
</td>
<td class=rlform>
Минимум&nbsp;&nbsp;<input type=text name=minval id=minval><br><br>
Максимум&nbsp;<input type=text name=maxval id=maxval><br><br>
<input type=button value="Сохранить" onclick="CheckRL()">
</td>

</tr></table>
<div id="check_div">

</div>


{include file="footer.tpl"}