{foreach from=$currdep.topline key=k item=v}
    {if $v.link == "" && $k != $currdep.parnum}
        <b>{$v.name}</b><br>
    {else}
        <a class=l1 href={$links.struct}?depid={$v.link}>{$v.name}</a>&nbsp;&gt;&gt;&nbsp;
    {/if}
{/foreach}


{if $currdep.chld|@count > 0}
    <h2>Дочерние подразделения</h2>
    {foreach from=$currdep.chld key=k item=v}
        <a class=l1 href={$links.struct}?depid={$k}>{$v}</a></br>
    {/foreach}
{/if}

{assign var=perstable value=$currdep.persons}

<br><h2>Сотрудники</h2>

{include file="pers_table.tpl"}