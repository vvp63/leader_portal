{include file="header.tpl"}

<h1>График отсутствий</h1><br>

<table class=v3><tr><td class=vv width=30>&nbsp;</td><td class=vtu>&nbsp;Основной&nbsp;отпуск&nbsp;</td>
<td class=va width=30>&nbsp;</td><td class=vtu>&nbsp;Дополнительный&nbsp;отпуск&nbsp;</td>
<td class=vk width=30>&nbsp;</td><td class=vtu>&nbsp;Командировка&nbsp;</td>
<td class=vb width=30>&nbsp;</td><td class=vtu>&nbsp;Больничный&nbsp;</td></tr></table><br>


<a href={$links.vac}?ts={$prevmonth}>&lt;&lt; {$prevmonth_rus} {$prevmonth|date_format:"%Y"}</a>&nbsp;&nbsp;&nbsp;
<b>{$lastmonth_rus} {$lastmonth|date_format:"%Y"}</b>&nbsp;&nbsp;&nbsp;
<a href={$links.vac}?ts={$nextmonth}>{$nextmonth_rus} {$nextmonth|date_format:"%Y"} &gt;&gt;</a><br><br>

<table class=v3><tr><td>ФИО</td>

{foreach from=$mdays key=k item=v}
     <td class=vt{if $v|date_format:"%u" < 6}u{else}s{/if}>{$v|date_format:"%d"}</td>
{/foreach}
</tr>

{foreach from=$vacantions key=k item=v}
    {if !$v.hide}
        <tr><td class=vfio><a class=meet href={$links.pers}?id={$k}>{$v.fio}</a>&nbsp;</td>
        {assign var=previd value=""}
        {foreach from=$v.days key=i item=d}
            {if $d.idb != $previd}
                <td {if $d.N > 1} colspan={$d.N}{/if} class=v{$d.type} {if $d.title != ""} title='{$d.title}'{/if}>&nbsp;</td>
            {/if} 
            {assign var=previd value=$d.idb}
        {/foreach}
        </tr>
    {/if}
{/foreach}



</table><br><br>

{include file="footer.tpl"}