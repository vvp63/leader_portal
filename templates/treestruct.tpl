{include file="header.tpl"}

<h1>Структура компании</h1>

{if $tree.is_adm_4}
    <b class=err>Отмеченные подразделения (и все их дочерние) будут скрыты от пользователей</b><br><br>
    <form method=post action={$links.struct}><input type=submit class=btn_adm name=hs_btn value='Скрыть отмеченные'><br><br>
{/if}

{foreach from=$tree.tree key=k item=v}
   {if $v.lev > 0}
        {assign var=shift value="&nbsp;"|str_repeat:($v.lev*7)}
        {if $tree.is_adm_4}
            {$shift}   
            <input type=checkbox class=cb name=hs[{$v.id}]{if $v.hide} checked{/if}>
            <a class=l{$v.lev} href={$links.struct}?depid={$v.id}>{$v.name}</a></br>
        {else}
            {if !$v.hide}
                {$shift}
                <a class=l{$v.lev} href={$links.struct}?depid={$v.id}>{$v.name}</a></br>
            {/if}
        {/if}
    {/if}
{/foreach}


{if $tree.is_adm_4}
    <br><input type=submit class=btn_adm name=hs_btn value='Скрыть отмеченные'></form>
{/if}

{include file="footer.tpl"}