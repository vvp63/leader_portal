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
					'&issueid=' + encodeURIComponent(document.getElementById("issues_list").value) + '&client=' + encodeURIComponent(document.getElementById("client").value) + 
					'&minval=' + encodeURIComponent(document.getElementById("minval").value) + '&maxval=' + encodeURIComponent(document.getElementById("maxval").value) +
					'&ltype=' + encodeURIComponent(document.getElementById("ltype").value);	
		xmlhttp.onreadystatechange=function() {
			if (this.readyState==4 && this.status==200) {
				var resp = this.responseText;
				const res = resp.split(';');
				if (res[0] != 0) {
					if (res[0] == 3) {
						if (confirm(res[1])) document.getElementById("addupdate").submit();
					} else {
						alert(res[1]);
					}
				} else {
					document.getElementById("addupdate").submit();
				}
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
		{if $k > 0}
		<option value={$k}{if $k==$smarty.session.client} selected{/if}>{$v.fullname}</option>
		{/if}
	{/foreach}
</select>
</form>
</td></tr></table>
<br>
<div id="message">
{$message}
</div>
<br>


<form id="addupdate" method="POST" action="rl_universal.php">
<table width=100% class=main>
<tr>
<td colspan=4 class=rltop><b>Добавить или редактировать</b></td>
</tr>
<tr>
<td class=rlform>
<b>Ограничение</b><br><br>
На <select name=CORG id=CORG>
		<option value=C{if $aa.fl == "1" and $aa.CORG == "C"} selected{/if}>Эмитента</option>
		<option value=G{if $aa.fl == "1" and $aa.CORG == "G"} selected{/if}>Группу</option>
	</select><br><br>
Вид&nbsp;
<select name=rtype id=rtype>
	<option value=A{if $aa.fl == "1" and $aa.rtype == "A"} selected{/if}{if $ad.fl != "1"} selected{/if}>Любая бумага из указанных типов</option>
	<option value=S{if $aa.fl == "1" and $aa.rtype == "S"} selected{/if}>Сумма всех бумаг указанных типов</option>
	<option value=I id=opti{if $aa.fl == "1" and $aa.rtype =="I"} selected{/if}>Конкретный выпуск</option>
</select><br>	

</td>
<td class=rlform>
<b>Эмитент или группа</b><br>
Поиск <input type=text id="search_txt" class=srch onkeyup="FindContr(this.value)"><br>
<select name="corg_list" id="corg_list" class=slct onchange="SetFndStr(this.value)" onclick="SetFndStr(this.value)">
{if $aa.fl == "1"}<option value="{$aa.cgrid}" selected>{$aa.cgname}</option>{/if}
</select>
</td>
<td class=rlform>
<div id=d_cbtypes class={if $aa.fl == "1" and $aa.rtype == "I"}unvis{else}vis{/if}>
<b>Типы ЦБ</b><br>
<select name=cbtypes[] id=cbtypes multiple size=10 class=slct>
	{foreach from=$cbtypes key=k item=v}
		<option value="{$v.Value}"{if $aa.fl == "1" and $v.Value|in_array:$aa.cbtypes} selected{/if}>{$v.Name}</option>
	{/foreach}
</select><br>
</div>
<div id=d_issues class={if $aa.fl == "1" and $aa.rtype == "I"}vis{else}unvis{/if}>
<b>Выпуски ЦБ</b><br>
<select name="issues_list" id="issues_list" class=slct onchange="SetFndIssue()" onclick="SetFndIssue()">
{if $aa.fl == "1"}
{foreach $aa.issues key=k item=v}<option value="{$k}"{if $k == $aa.issueid} selected{/if}>{$v}</option>{/foreach}
{/if}
</select>
</div>
</td>
<td class=rlform>
<b>Величина ограничений</b><br><br>
Минимум&nbsp;&nbsp;<input type=text name=minval id=minval value="{if $aa.fl == "1"}{$aa.minval}{else}0{/if}"><br><br>
Максимум&nbsp;<input type=text name=maxval id=maxval value="{if $aa.fl == "1"}{$aa.maxval}{else}0{/if}"><br><br>
<select name="ltype" id="ltype">
<option value=P{if $aa.fl == "1" and $aa.ltype == "P"} selected{/if}{if $aa.fl != "1"} selected{/if}>% от СЧА</option>
<option value=R{if $aa.fl == "1" and $aa.ltype == "R"} selected{/if}>Рублей</option>
</select><br><br>


<input type=hidden name="fl" value="add">
<input type=button value="Сохранить" onclick="CheckRL()" class=butt>
</td>

</tr></table>
</form>

<table width=100% class=main>
<tr>
<td class=rltop>Ограничение на</td>
<td class=rltop>Эмитент или группа</td>
<td class=rltop>Список типов или выпуск</td>
<td class=rltop>Минимум</td>
<td class=rltop>Максимум</td>
<td class=rltop>% СЧА / руб.</td>
<td></td>
<td></td>
</tr>

{foreach $rlu key=k item=v}
<tr>
<td>{($v.RestrictType == "I") ? "Конкретный выпуск" : (($v.RestrictType == "A") ? "Любая бумага" : "Сумма всех бумаг")}   {($v.CORG == "C") ? "эмитента" : "группы"}</td>

<td>{$v.CORGname}</td>
<td>{($v.RestrictType == "I") ? $v.Issue : $v.TypesList}</td>
<td>{$v.Min}</td>
<td>{$v.Max}</td>
<td>{($v.LimitType == "P") ? "% от СЧА" : "руб."}</td>
<td></td>
<td></td>
</tr>

{/foreach}

</table>

{include file="footer.tpl"}