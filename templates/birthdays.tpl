{include file="header.tpl"}

<h1>Дни рождения сотрудников</h1>

<table width=700>

{foreach from=$birthdays key=d item=p}
<tr><td class=form colspan="2"><h2>{$d}</h2></td></tr>
    {foreach from=$p key=k item=v}
        <tr><td class=person><a href={$links.pers}?id={$k}><img class=photo width={$v.pw} height={$v.ph} src='{$v.fn}'></a></td>  
        <td class=person width=100%><a class=l2 href={$links.pers}?id={$k}><h2>{$v.FAMILY} {$v.NAME} {$v.SNAME}</h2></a><i>{$v.POSITION}</i></td></tr>  
    {/foreach}
{/foreach}

</table>

{include file="footer.tpl"}