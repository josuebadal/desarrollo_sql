Buenas tardes.
Podrian apoyarnos para agregar al query 123 
el ahorro adulto (110), 
el ahorro adicional (111) , 
ahorro cuenta corriente (130), 
ahorro cuenta confianza (131) 
además de si tiene inversiones (depósitos a plazo fijo) (200,201,202,203) 
con los que cuentan los socios que salen en este reporte.
Gracias de antemano por el apoyo brindado saludos cordiales.






--SE TRABAJA LA BASE DE DATOS 31 DE MAYO 2026
--PARA CARGAR INFO ES EL QUERY  121

select alta_personas_bloqueadas('LPB-27052026.txt');

--PARA DAR DE BAJA ES EL QUERY 128

select elimina_persona_bloqueada(13501,88,1425);

select idorigen,idgrupo,idsocio,listanegra,estatus,aceptado from personas where idgrupo = 88;
