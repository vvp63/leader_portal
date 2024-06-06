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
    <tr><td class=pc><b>Телефон</b></td><td class=pc>{$pers.WorkPhone}</td></tr>
    <tr><td class=pc><b>Кабинет</b></td><td class=pc>{$pers.WorkCabinet}</td></tr>
    <tr><td class=pc><b>Email</b></td><td class=pc><a href='mailto:{$pers.WorkEmail}'>{$pers.WorkEmail}</a></td></tr>
    <tr><td class=pc><b>Дата рождения</b></td><td class=pc>{$birth}</td></tr>
    {if $vactxt != ""}
        <tr><td class=pc><b>Текущее отсутствие</b></td><td class=pc>{$vactxt}</td></tr>
    {/if}
    
    
    {if $is_adm_8}
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


