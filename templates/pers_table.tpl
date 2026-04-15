{if $perstable|@count > 0}
<table>
{foreach from=$perstable key=k item=v}
	<tr><td class=calend{if $k == $gid}_gid{/if}><a href={$links.pers}?id={$k}>
	<img class=photo width={if $k == $gid}{($v.width * 1.4)|round}{else}{$v.width}{/if} height={if $k == $gid}{($v.height * 1.4)|round}{else}{$v.height}{/if} src='{$v.src}'></a></td>
	<td class={if $k == $gid}pc_gid{else}pc{$v.sel}{/if}>
	{if $v.hide}<b class=err>Сотрудник скрыт от пользователей</b><br>{/if}
	<a class={if $k == $gid}l0{else}l2{/if} href={$links.pers}?id={$k}>
	{$v.fio}</a><br><i>{$v.position}</i><br> Тел. {$v.phone}</td></tr>
	{if $k == $gid}<tr><td class=pc style="border: 0px;">&nbsp;</td><td class=pc style="border: 0px;">&nbsp;</td></tr>{/if}
{/foreach}
</table>
{/if}