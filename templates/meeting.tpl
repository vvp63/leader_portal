{include file="header.tpl"}

<h1>Бронирование переговорных</h1>

{if isset($smarty.session.roomid)}

    <h2>Переговорная {$curr_room.name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href={$links.meet}?roomid=0> К списку переговорных &gt;&gt;</a></h2>
    
    {if $add_text != ""}{$add_text}<br />{/if}

    {if $is_adm_1}
        <table><tr><td class=form><form action='{$links.meet}?ts={$ts}' method=POST>
        <input type=date name=calend_dt value='{$ts|date_format:"%Y"}-{$ts|date_format:"%m"}-{$ts|date_format:"%d"}'>&nbsp;&nbsp;&nbsp;
        <select name=tb>
        {foreach from=$ints key=k item=v}<option value='{($today + $v)|date_format:"%H:%M"}'>{($today + $v)|date_format:"%H:%M"}</option>{/foreach}
        </select>&nbsp;-&nbsp;<select name=te>
        {foreach from=$ints key=k item=v}<option value='{($today + $v + $ti)|date_format:"%H:%M"}'>{($today + $v + $ti)|date_format:"%H:%M"}</option>{/foreach}
        </select><br><br>
        <input type=checkbox class=cb name=everyday value=1>&nbsp;Ежедневно до&nbsp;
        <input type=date name=date_till value='{$ts|date_format:"%Y"}-{$ts|date_format:"%m"}-{$ts|date_format:"%d"}'><br /><br />
        <select class='js-select2' name='person' placeholder='ФИО'><option value=''></option>
        {foreach from=$people key=k item=v}
            {if !$v.is_hp}
                <option value={$k}>{$v.FAMILY} {$v.NAME} {$v.SNAME}</option>
            {/if}      
        {/foreach}
        </select><br><br>
        Комментарий<br><input type=text name=comment size=37><br><br>
        <input type=submit name=add_btn value='Забронировать' class=btn></form></td></tr></table><br>
    {/if}
    
    
    <table><tr><td colspan=8 align=center>
    <a href={$links.meet}?ts={($w_s - 7 * 86400)}>&lt;&lt; Предыдущая неделя</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href={$links.meet}?ts={($w_s + 7 * 86400)}>Следующая неделя &gt;&gt;</a><br><br>
    </td></tr><tr><td>&nbsp;</td>
    {foreach from=$calend key=kd item=d}<td class=calend>{$d.w_d}<br>({$d.date})</td>{/foreach}
    </tr>
    {foreach from=$ints key=k item=v}
        <tr><td class=calend>{($today + $v)|date_format:"%H:%M"}&nbsp;-&nbsp;{($today + $v + $curr_room.time_incr)|date_format:"%H:%M"}</td>
        {foreach from=$calend key=kd item=d}
            {assign var=i_ts value=($d.ts + $v)}
            {assign var=is_meet value=$in_meet.$i_ts}
            {if $is_meet.curr == 1}
                {assign var=mi value=$is_meet.meet_id}
                {assign var=pers_id value=$meetings.$mi.person|lower}
                {assign var=fam value=$people.$pers_id.FAMILY}
                {assign var=name_s value=mb_substr($people.$pers_id.NAME, 0, 1)}
                {assign var=sname_s value=mb_substr($people.$pers_id.SNAME, 0, 1)}
                {assign var=pers_text value=''}
                <td class=meet rowspan={$is_meet.num}>
                {if isset($people.$pers_id) && !($people.$pers_id.is_hp)}
                    <a class=meet href={$links.pers}?id={$pers_id}>{$fam} {$name_s}.{$sname_s}.</a><br><br>
                {/if} 
                {$meetings.$mi.comment} <br />  
                {if $is_adm_1}
                    <form method=post action='{$smarty.server.REQUEST_URI}' onsubmit="return confirm('Удалить бронирование?');">
                    <input type=hidden name=delid value={$mi}>
                    <input type=submit class=btn_adm name=del value='Удалить'>
                    </form>
                {/if}                                  
                </td>
            {/if}
            {if $is_meet.curr == 0}
                <td class=ce>&nbsp;</td>
            {/if}     
        {/foreach}
        
        </tr>
    {/foreach}
      
    </table><br><br>   

{else}

    <table><tr>
    <td class=pc>&nbsp;</td><td class=pc>Этаж</td><td class=pc>Количество мест</td><td class=pc>Начало</td><td class=pc>Конец</td><td class=pc>Интервал</td></tr>
    {foreach from=$rooms key=k item=v}
        <tr><td class=pc><span class=mr{$k}><a class=mr href={$links.meet}?roomid={$k}>{$v.name}</a></span></td><td class=pc>{$v.level}</td>
        <td class=pc>{$v.places}</td><td class=pc>{($today + $v.beg_time)|date_format:"%H:%M"}</td><td class=pc>
        {($today + $v.end_time)|date_format:"%H:%M"}</td><td class=pc>{($today + $v.time_incr)|date_format:"%H:%M"}</td></tr>
    {/foreach}
    </tr></table><br><br> 
    <a href={$links.meet}?ts={$prevmonth}>&lt;&lt; {$prevmonth_rus} {$prevmonth|date_format:"%Y"}</a>&nbsp;&nbsp;&nbsp;
    <b>{$lastmonth_rus} {$lastmonth|date_format:"%Y"}</b>&nbsp;&nbsp;&nbsp;
    <a href={$links.meet}?ts={$nextmonth}>{$nextmonth_rus} {$nextmonth|date_format:"%Y"} &gt;&gt;</a><br><br>     
    
    <table width=600> 
    {assign var=d value=$lastmonth}
    {while $d < $nextmonth}
        
        {assign var=c_wd value=$d|date_format:"%u"}
        {assign var=c_dt value=$d|date_format:"%d.%m.%Y"}  
        <tr><td width=100 class=pc{if $c_wd < 6} {else}_sel{/if}>{$c_dt}</td><td width=100% class=pc{if $c_wd < 6} {else}_sel{/if}> 
        {foreach from=$meetings key=k item=v}
            {if $v.time_begin >= $d && $v.time_begin < ($d + 86400)}
                {assign var=pers_id value=$v.person|lower}
                {assign var=fam value=$people.$pers_id.FAMILY}
                {assign var=name_s value=mb_substr($people.$pers_id.NAME, 0, 1)}
                {assign var=sname_s value=mb_substr($people.$pers_id.SNAME, 0, 1)}
                {assign var=roomid value=$v.room_id}
                <span class=mr{$roomid}><a href={$links.meet}?roomid={$roomid}&ts={$v.time_begin}>{$rooms.$roomid.name}</a></span>&nbsp;
                {$v.time_begin|date_format:"%H:%M"} - {($v.time_begin + $v.intervals_num * $rooms.$roomid.time_incr)|date_format:"%H:%M"}&nbsp;
                {$v.comment}&nbsp;
                {if isset($people.$pers_id) && !($people.$pers_id.is_hp)} 
                    <a href={$links.pers}?id={$pers_id}>{$fam} {$name_s}.{$sname_s}.</a>
                {/if}
                <br>
            {/if}
        {/foreach}        
        
        </td></tr>

        {assign var=d value=$d + 86400}
    {/while}
    </table><br><br>  
    
{/if}

{include file="footer.tpl"}


