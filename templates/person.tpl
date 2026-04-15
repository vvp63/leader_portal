{include file="header.tpl"}

{if $is_adm_8 || !$is_hp}
    <table height=100% width=100% border=0><tr><td width=500 class=person>
    <img src='img/blank.png' width=500 height=1>
    <h1>{$pers.FAMILY} {$pers.NAME} {$pers.SNAME}</h1><br>
    {if $is_alt}
        <img class=photo width={$w_alt} height={$h_alt} src={$im_fn_alt}>
    {else}
        <img class=photo width={$w} height={$h} src={$im_fn}>
    {/if}
    <br><br><table width=100%>
    <tr><td class=pc><b>Должность</b></td><td class=pc>{$pers.POSITION}</td></tr>
    <tr><td class=pc><b>Телефон</b></td><td class=pc>
		{if $pers.use_alt_t}
			{$pers.alt_t}
			{if $is_adm_8} <i class=alt>&nbsp;(Из 1С - {$pers.WorkPhone})&nbsp;</i>{/if}
		{else}
			{$pers.WorkPhone}
		{/if}
	</td></tr>
    <tr><td class=pc><b>Кабинет</b></td><td class=pc>
		{if $pers.use_alt_c}
			{$pers.alt_c}
			{if $is_adm_8} <i class=alt>&nbsp;(Из 1С - {$pers.WorkCabinet})&nbsp;</i>{/if}
		{else}
			{$pers.WorkCabinet}
		{/if}	
	</td></tr>
    <tr><td class=pc><b>Email</b></td><td class=pc>
		{if $pers.use_alt_e}
			<a href='mailto:{$pers.alt_e}'>{$pers.alt_e}</a>
			{if $is_adm_8} <i class=alt>&nbsp;(Из 1С - <a href='mailto:{$pers.WorkEmail}'>{$pers.WorkEmail}</a>)&nbsp;</i>{/if}
		{else}
			<a href='mailto:{$pers.WorkEmail}'>{$pers.WorkEmail}</a>
		{/if}	
	

	</td></tr>
    <tr><td class=pc><b>Дата рождения</b></td><td class=pc>{$birth}</td></tr>
    {if $vactxt != ""}
        <tr><td class=pc><b>Текущее отсутствие</b></td><td class=pc>{$vactxt}</td></tr>
    {/if}
    
    
    {if $is_adm_8}
		<tr><td class=pc colspan=2>
		<input type=button class=btn_adm value='Посмотреть отсутствия' onclick='window.open("./vac_pers.php?id={$curr_pid}", "_blank", "top=100, left=100, width=800, height=700")'>
		</td></tr>
        <tr><td class=pc colspan=2><form method=post enctype='multipart/form-data' action={$links.pers}?id={$curr_pid}> <table><tr><td class=form>   
        <b class=err>Настройка отображения</b><br>
        <input type=checkbox class=cb name=hide value=1 {if $is_hp} checked{/if}>&nbsp;Скрывать сотрудника<br>
        <input type=checkbox class=cb name=alt_photo value=1 {if $is_alt} checked{/if}>&nbsp;Использовать в карточке альтернативное фото<br>
        
        {if $is_alt}
            (Ниже показано фото из 1С)<br><img class=photo width={$w} height={$h} src={$im_fn}><br>
        {else}
            <img class=photo width={$w_alt} height={$h_alt} src={$im_fn_alt}><br>
        {/if}
        Загрузить JPG <input name=photo_file type=file class=f2 /><br>
        <input type=checkbox class=cb name=del_alt value=1>&nbsp;Удалить альтернативное фото<br>
		<br>
		<table>
		<tr>
		<td class=alt><input type=checkbox class=cb name=use_alt_t value=1 {if $pers.use_alt_t} checked{/if}>&nbsp;Альтернативный телефон&nbsp;</td>
		<td><input type=text name=alt_t value='{$pers.alt_t}' class=f3></td>
		</tr><tr>
		<td class=alt><input type=checkbox class=cb name=use_alt_c value=1 {if $pers.use_alt_c} checked{/if}>&nbsp;Альтернативный кабинет&nbsp;</td>
		<td><input type=text name=alt_c value='{$pers.alt_c}' class=f3></td>
		</tr><tr>
		<td class=alt><input type=checkbox class=cb name=use_alt_e value=1 {if $pers.use_alt_e} checked{/if}>&nbsp;Альтернативный Email&nbsp;</td>
		<td><input type=text name=alt_e value='{$pers.alt_e}' class=f3></td>
		</tr>		
		</table>
		
        <input type=submit class=btn_adm name=save_btn value='Сохранить'></td></tr></table></form></td></tr>
    {/if}
    </table>
    
    </td><td class=main width=100%>
    
    {include file="struct_incl.tpl"}
    
    </td></tr></table>
       
{else}
    <b class=err>Сотрудник не найден!</b><br>
{/if}


{include file="footer.tpl"}


