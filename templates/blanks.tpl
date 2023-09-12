{include file="header.tpl"}

<h1>Бланки и документы</h1><br>

{if $subdir != ''}
<b>.. {$subdir|replace:'_':' '}</b>&nbsp;&nbsp;&nbsp;&nbsp;<a class=l1 href={$links.blanks}>&uparrow; Наверх</a><br><br>
{/if}

{foreach from=$files_ord key=k item=v}
{if $v.type == 'D'}
<img src=./img/folder.png>&nbsp;<b><a class=l1 href={$links.blanks}?subdir={$v.value}>{$v.value|replace:'_':' '}</a></b><br>
{/if}
{if $v.type == 'F'}
<img src=./img/file.png>&nbsp;<a class=l1 target=_blank href='{$rootdir}{$subdir}/{$v.value}'>{$v.value}</a><br>
{/if}
{/foreach}

{include file="footer.tpl"}