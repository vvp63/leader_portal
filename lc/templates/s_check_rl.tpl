{$res_code};
{if $res_code == 1}Не задан клиент{/if}
{if $res_code == 2}Не заданы все необходимые параметры - эмитент или группа, выпуск или список типов, величина ограничений{/if}
{if $res_code == 3}Ограничения с заданными параметрами существуют. Минимум {$rl_ex.min}, максимум {$rl_ex.max}{/if}




