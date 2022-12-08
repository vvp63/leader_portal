{include file="header.tpl"}

<h1>Распорядительные документы</h1><br>

{if $message != ''}
    {$message}<br /><br />
{/if}

{if $is_adm_2}
    <table><tr><td class=form><form enctype="multipart/form-data" action="{$links.docs}" method="POST">
    <b>Загрузка файла</b>: <br><br>Дата <input name='upl_date' type='date' value='{$td_date}' />&nbsp;&nbsp;&nbsp;&nbsp;
    <input name="userfile" type="file" class=fl /><br><br>
    Комментарий <input name="comment" type="text" size=60 /><br><br><input type="hidden" name="MAX_FILE_SIZE" value="104857600" />
    <input type="submit" value="Отправить" class=btn /></form></td></tr></table><br>
{/if}

<form action="{$links.docs}" method="POST"><input size=40 type="search" name="ft" placeholder="Поиск по документам" value='{$smarty.session.find_doc}'>
<input type="submit" name="find_btn" value="Найти" class=btn></form>

{foreach from=$docs_show key=k item=v}
    <b>{$v.date|truncate:11:"":false}</b> <i>{$v.comment}</i><br>
    <img src=./img/file.png>&nbsp;<a target=_blank href='{$docs_path}/{$v.filename}'>{$v.filename}</a><br>
    {if $is_adm_2}
        <form method=post action="{$smarty.server.REQUEST_URI}" onsubmit="return confirm('Удалить документ {$v.filename}?');"> 
        <input type=hidden name=del value='delete'><input type=hidden name=doc_id value={$v.id}><input type=hidden name=doc_name value='{$v.filename}'>
        <input type=submit class=btn value='Удалить'></form>  
    {/if}    
{/foreach}

<br />
{if $max_page > 1}
    {if ($curr_page - $pages_around) > 1}
        <a href={$links.docs}?page=1>&lt;&lt</a>...
    {/if}
    
    {while $p <= $p_end}
        {if $p == $curr_page}
            <b>{$p}</b>
        {else}
            <a href={$links.docs}?page={$p}>{$p}</a>
        {/if}
        &nbsp;&nbsp;
        {assign var=p value=$p+1}
    {/while} 
    
    {if ($curr_page + $pages_around) < $max_page}
        ...<a href={$links.docs}?page={$max_page}>&gt;&gt;</a>
    {/if}
  
{/if}

{include file="footer.tpl"}