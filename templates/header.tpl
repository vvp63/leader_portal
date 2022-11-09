<html>
<head>
    <meta charset="UTF-8">
	<title>Корпоративный портал ЗАО "Лидер"</title>
       
    <link rel="stylesheet" href="css/leader_site.css">
    <link rel="stylesheet" href="css/select2.min.css">
    <link rel="icon" type="image/png" href="img/favicon.ico" type="image/x-icon">
    <script src="js/jquery.min.js"></script>
    <script src="js/select2.min.js"></script>
    <script src="js/ru.js"></script>
    
    <script>
    $(document).ready(function() {
    	$('.js-select2').select2({
    		placeholder: "ФИО",
    		maximumSelectionLength: 2,
    		language: "ru"
    	});
    });
    </script>      
    
</head>

<body>

<table height="110%" width="100%">
<tr>
    <td align=center width=60></td>
    <td align=center width=226><a href={$links.idx}><img src="img/Logo_Lider.png" width="209" height="69"></a><br /><br /></td>
    <td class=top_menu>
    
        <table><tr>     
        {assign var=i value=0}
        {foreach from=$menu key=k item=v}
            <td class='menu'><a class='top' href='{$k}'>{$v}</a></td>
            {assign var=i value=$i+1}
            {if $i % 3 == 0}
            </tr><tr>
            {/if}
        {/foreach}
        </tr></table>    
            
    </td>
    <td align=center width=226>
    {if $is_admin || $smarty.session.hide_adm == 1}
        {if $smarty.session.hide_adm != 1}
            Режим администратора<br>{$smarty.session.admin.login}<br>         
        {/if}
        <form method=post action={$smarty.server.REQUEST_URI}>     
        <input type=submit class=btn name=ch_adm value='{if $smarty.session.hide_adm == 1}Режим администратора{else}Режим пользователя{/if}'>
        </form>
    {/if}
       
    </td>     
    <td align=center width=60></td>      
</tr>    

<tr height=100%>
    <td align=center width=60><img src="img/blank.png" hspace=0 vspace=0 width=60 height=1></td>
    <td align=center width=226 bgcolor=#0550A0 valign=bottom><img src="img/wave2.png" hspace=0 vspace=0></td>
    <td width=100% class=main{$class_idx}>