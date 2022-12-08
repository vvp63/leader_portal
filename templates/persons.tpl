{include file="header.tpl"}

<h1>Сотрудники</h1>


<form action={$links.persons} method="POST"><input type="search" size=40 name="ft" placeholder="Поиск по сотрудникам" value="{$smarty.session.find_pers}">
&nbsp;<input type="submit" name="find_btn" value="Найти" class=btn>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a class=l1 href={$links.birth}?id={$k}>Дни рождения &gt;&gt;</a>
</form>



{include file="pers_table.tpl"}

{if $max_page > 1}
    {if ($curr_page - $pages_around) > 1}
        <a href={$links.persons}?page=1>&lt;&lt</a>...
    {/if}
    
    {while $p <= $p_end}
        {if $p == $curr_page}
            <b>{$p}</b>
        {else}
            <a href={$links.persons}?page={$p}>{$p}</a>
        {/if}
        &nbsp;&nbsp;
        {assign var=p value=$p+1}
    {/while} 
    
    {if ($curr_page + $pages_around) < $max_page}
        ...<a href={$links.persons}?page={$max_page}>&gt;&gt;</a>
    {/if}    

{/if}


{include file="footer.tpl"}