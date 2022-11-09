{if $perstable|@count > 0}
    <table>
    {foreach from=$perstable key=k item=v}
        <tr><td class=calend><a href={$links.pers}?id={$k}><img class=photo width={$v.width} height={$v.height} src='{$v.src}'></a></td>
        <td class=pc{$v.sel}>
        {if $v.hide}<b class=err>Сотрудник скрыт от пользователей</b><br>{/if}
        <a class=l2 href={$links.pers}?id={$k}>
        {$v.fio}</a><br><i>{$v.position}</i><br> Тел. {$v.phone}</td></tr>
    {/foreach}
    </table>
{/if}