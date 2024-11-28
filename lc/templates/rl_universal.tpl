{include file="header.tpl"}


<script>
	
	$(function() {
	
		ShowFilteredList();
	
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
			ShowFilteredList();
		});
				
		$('#rtype').on('change', function(){
			if ($('#rtype').val() == 'I') { 
				$('#d_cbtypes').hide();				
				$("#d_issues").show(); 
			} else { 
				$("#d_issues").hide();
				$('#d_cbtypes').show();				
			} 
			ShowFilteredList();
		});
		
		$("#corg_list").on('change', function(){
			ShowFilteredList();
		});
		
		$("#cbtypes").on('change', function(){
			ShowFilteredList();
		});	
		
		$("#issues_list").on('change', function(){
			ShowFilteredList();
		});			
								
		$('#fl_cgrt').on('change', function(){
			ShowFilteredList();
		});
		
		$('#fl_cgid').on('change', function(){
			ShowFilteredList();
		});		
		
		$('#fl_tliss').on('change', function(){
			ShowFilteredList();
		});	

		$('#editreset').on('click', function(){
			$('#editreset').hide();
			$('#ed_rid').val('');
			$('#addedittop').html('Добавить ограничение');
		});
		
		$('#copy_all').on('click', function(){
			if (confirm("Выполнить копирование?")) {
				$('#fl').val('copyall');
				$('#addupdate').submit();
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
	
	function TypesListStr() {
		var ct = '';
		const options = document.getElementById('cbtypes').options;
		for (let opt of options) {
			if (opt.selected) ct = ct + opt.value + ';';
		}
		return ct;
	}
	
	function CheckRL() {
		var cbtypes = TypesListStr();
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
					document.getElementById("fl").value = "add";
					document.getElementById("addupdate").submit();
				}
			}
		}
		xmlhttp.open("POST", "./s_check_rl.php", true);
		xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xmlhttp.send(body);
	}		
	
	
	function ShowFilteredList() {
		var lstcount = {$rlu|@count};
		var flCGRL = document.getElementById("CORG").value + document.getElementById("rtype").value;
		for (let i = 1; i <= lstcount; i++) {
			var flt_result = 1;
			var rid = 'lstrows[' + i +']';
			var flcgrt = 'hiddcgrt[' + i +']';
			var flcgid = 'hiddcgid[' + i +']';
			var fltl = 'hiddtl[' + i +']';
			var fliss = 'hiddiss[' + i +']';
			var hidd = 'hidd[' + i +']';
			var cb = 'cb[' + i +']';
			if ( (document.getElementById("fl_cgrt").checked) && (document.getElementById(flcgrt).value != flCGRL) ) {
				flt_result = 0;
			}
			
			if ( (document.getElementById("fl_cgid").checked) && (document.getElementById("corg_list").value != "") && 
					(document.getElementById("corg_list").value != document.getElementById(flcgid).value) ) {
				flt_result = 0;
			}	

			if (document.getElementById("fl_tliss").checked) {
				if (document.getElementById("rtype").value == 'I')  {
					if ( (document.getElementById("issues_list").value != "") &&  (document.getElementById("issues_list").value != document.getElementById(fliss).value) )
						flt_result = 0;
				} else {
					var cbtypes = TypesListStr();
					if (document.getElementById(fltl).value != cbtypes) flt_result = 0;
				}
			}
		
			if (flt_result == 0) {
				document.getElementById(rid).style.display='none';
				document.getElementById(hidd).value = '1';
				document.getElementById(cb).checked = false;
			} else {
				document.getElementById(rid).style.display='';
				document.getElementById(hidd).value = '0';
			}			
		}
	}
	
	function SubmEdit(rid) {
		document.getElementById("fl").value = "edit";
		document.getElementById("ed_rid").value = rid;
		document.getElementById("addupdate").submit();	
	}
	
	function SubmDelete(rid) {
		if (confirm("Вы уверены, что хотите удалить запись?")) {
			document.getElementById("fl").value = "del";
			document.getElementById("ed_rid").value = rid;
			document.getElementById("addupdate").submit();			
		}
	}
	
	function SetIX(ix_type, itt, rid) {
		var iid = 'lim_' + ix_type + '[' + itt +']';
		xmlhttp=new XMLHttpRequest();
		var body = 	'rid=' + encodeURIComponent(rid) + '&ix=' + encodeURIComponent(ix_type) +
					'&val=' + encodeURIComponent(document.getElementById(iid).value);	
		xmlhttp.onreadystatechange=function() {
			if (this.readyState==4 && this.status==200) {
				document.getElementById(iid).value = this.responseText;
			}
		}
		xmlhttp.open("POST", "./s_ix_change.php", true);
		xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xmlhttp.send(body);		
	}
	
	function CheckAll(val) {
		var lstcount = {$rlu|@count};
		for (let i = 1; i <= lstcount; i++) {
			var hidd = 'hidd[' + i +']';
			var cb = 'cb[' + i +']';
			document.getElementById(cb).checked = val && (document.getElementById(hidd).value == '0');			
		}
	}

</script>

<form method="POST" id="cl_from"> 
<table width=100% class=main><tr><td class=client>
	<b>Клиент</b>
	<select name=client id=client>
		{foreach from=$clients key=k item=v}
			{if $k > 0}
			<option value={$k}{if $k==$smarty.session.client} selected{/if}>{$v.fullname}</option>
			{/if}
		{/foreach}
	</select>
</td></tr></table>
</form>

<div id="message">
{$message}
</div>
<br>


<form id="addupdate" method="POST" action="rl_universal.php">
<table width=100% class=addupdate>
<tr><td colspan=4 class=rltop id="addedittop">{if $aa.mode == "edit"}Редактировать ограничение{else}Добавить ограничение{/if}</td></tr>
<tr>
	<td class=rlsubtop>Ограничение</td>
	<td class=rlsubtop>Эмитент или группа</td>
	<td class=rlsubtop>Типы ЦБ или выпуск</td>
	<td class=rlsubtop>Величина ограничений</td>
</tr>
<tr>
	<td class=rlform>
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
	Поиск <input type=text id="search_txt" class=srch onkeyup="FindContr(this.value)"><br>
	<select name="corg_list" id="corg_list" class=slct onchange="SetFndStr(this.value)" onclick="SetFndStr(this.value)">
		{if $aa.fl == "1"}<option value="{$aa.cgrid}" selected>{$aa.cgname}</option>{/if}
	</select>
</td>
<td class=rlform>
	<div id=d_cbtypes class={if $aa.fl == "1" and $aa.rtype == "I"}unvis{else}vis{/if}>
		<select name=cbtypes[] id=cbtypes multiple size=10 class=slct>
			{foreach from=$cbtypes key=k item=v}
				<option value="{$k}"{if $aa.fl == "1" and $k|in_array:$aa.cbtypes} selected{/if}>{$v}</option>
			{/foreach}
		</select><br>
	</div>
	<div id=d_issues class={if $aa.fl == "1" and $aa.rtype == "I"}vis{else}unvis{/if}>
		<select name="issues_list" id="issues_list" class=slct{if $aa.fl == "1" and $aa.rtype == "I"} size=10{/if}>
		{if $aa.fl == "1"}
			{foreach $aa.issues key=k item=v}<option value="{$k}"{if $k == $aa.issueid} selected{/if}>{$v}</option>{/foreach}
		{/if}
		</select>
	</div>
</td>
<td class=rlform>
	Минимум&nbsp;&nbsp;<input type=text name=minval id=minval value="{if $aa.fl == "1"}{$aa.minval|string_format:"%g"}{else}0{/if}"><br><br>
	Максимум&nbsp;<input type=text name=maxval id=maxval value="{if $aa.fl == "1"}{$aa.maxval|string_format:"%g"}{else}0{/if}"><br><br>
	<select name="ltype" id="ltype">
		<option value=P{if $aa.fl == "1" and $aa.ltype == "P"} selected{/if}{if $aa.fl != "1"} selected{/if}>% от СЧА</option>
		<option value=R{if $aa.fl == "1" and $aa.ltype == "R"} selected{/if}>Рублей</option>
	</select><br><br>
	<input type=hidden name="fl" id="fl" value="">
	<input type=hidden name="ed_rid" id="ed_rid" value="{if $aa.fl == "1"}{$aa.ed_rid}{/if}">
	<input type=button value="Сохранить" onclick="CheckRL()" class=butt>
	{if $aa.mode == "edit"}&nbsp;&nbsp;<input type=button value="Отмена редактирования" class=butt id="editreset">{/if}
</td>
</tr>

<tr>
	<td class=rlsubtop><input type="checkbox" name="fl_cgrt" id="fl_cgrt" value="1"{if $aa.fl == "1" and $aa.fl_cgrt == "1"} checked{/if}>&nbsp;Фильтровать</td>
	<td class=rlsubtop><input type="checkbox" name="fl_cgid" id="fl_cgid" value="1"{if $aa.fl == "1" and $aa.fl_cgid == "1"} checked{/if}>&nbsp;Фильтровать</td>
	<td class=rlsubtop><input type="checkbox" name="fl_tliss" id="fl_tliss" value="1"{if $aa.fl == "1" and $aa.fl_tliss == "1"} checked{/if}>&nbsp;Фильтровать</td>
	<td class=rlsubtop></td>
</tr>

</table>


<table width=100% class=main>
<tr><td colspan=9 class=rltop>Список существующих ограничений</td></tr>
<tr>
	<td class=rlsubtop><input type=checkbox id=cb_all onchange="CheckAll(this.checked)"></td>
	<td class=rlsubtop>Ограничение на</td>
	<td class=rlsubtop>Эмитент или группа</td>
	<td class=rlsubtop>Список типов или выпуск</td>
	<td class=rlsubtop>Минимум</td>
	<td class=rlsubtop>Максимум</td>
	<td class=rlsubtop>% СЧА / руб.</td>
	<td class=rlsubtop>&nbsp;</td>
	<td class=rlsubtop>&nbsp;</td>
</tr>


{foreach $rlu key=k item=v}
<tr id="lstrows[{$v@iteration}]" class=rllist{$v@iteration % 2}>
	<td>
		<input type=checkbox id="cb[{$v@iteration}]" name="cb[{$v@iteration}]">
		<input type=hidden id="rid[{$v@iteration}]" value="{$k}" name="rid[{$v@iteration}]">
		<input type=hidden id="hidd[{$v@iteration}]" value="0">
	</td>
	<td>
		<input type=hidden id="hiddcgrt[{$v@iteration}]" value="{$v.CORG}{$v.RestrictType}">
		{($v.RestrictType == "I") ? "Конкретный выпуск" : (($v.RestrictType == "A") ? "Любая бумага" : "Сумма всех бумаг")} 
		{($v.CORG == "C") ? "эмитента" : "группы"}
	</td>
	<td><input type=hidden id="hiddcgid[{$v@iteration}]" value="{$v.CORGid}">{$v.CORGname}</td>
	<td>
		<input type=hidden id="hiddtl[{$v@iteration}]" value="{$v.TypesList}">
		<input type=hidden id="hiddiss[{$v@iteration}]" value="{$v.IssueRid}">
		{($v.RestrictType == "I") ? $v.Issue : $v.TLNames}
	</td>
	<td><input type=text id="lim_i[{$v@iteration}]" value="{$v.Min|string_format:"%g"}" onchange="SetIX('i', {$v@iteration}, '{$k}')"></td>
	<td><input type=text id="lim_x[{$v@iteration}]" value="{$v.Max|string_format:"%g"}" onchange="SetIX('x', {$v@iteration}, '{$k}')"></td>
	<td>{($v.LimitType == "P") ? "% от СЧА" : "руб."}</td>
	<td><input type=button class=butt_edit value="" onclick="SubmEdit('{$k}')"></td>
	<td><input type=button class=butt_del value="" onclick="SubmDelete('{$k}')"></td>
</tr>

{/foreach}

</table>
<br>
Скопировать отмеченные на клиента 
<select name="copytocl" id="copytocl" class=slct>
	{foreach from=$clients key=k item=v}
		{if $k > 0}
		<option value={$k}{if $k==$smarty.session.client} disabled{/if}>{$v.fullname}</option>
		{/if}
	{/foreach}
</select>
<input type=button value="Копировать" class=butt id="copy_all">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type=button value="Удалить отмеченные" class=butt>
</form>


{include file="footer.tpl"}