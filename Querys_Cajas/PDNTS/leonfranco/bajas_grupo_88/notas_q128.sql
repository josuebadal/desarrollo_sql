--SE TRABAJA LA BASE DE DATOS 31 DE MAYO 2026
--PARA CARGAR INFO ES EL QUERY  121

select alta_personas_bloqueadas('LPB-27052026.txt');

--PARA DAR DE BAJA ES EL QUERY 128

select elimina_persona_bloqueada(13501,88,1425);

select idorigen,idgrupo,idsocio,listanegra,estatus,aceptado from personas where idgrupo = 88;
