/*------------------------------------------------PRESTAMO NUEVO Y ANTERIOR--------------------------------------------------*/
select distinct a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar as "OPA",
				a.fechaactivacion as "FECHA ACTIVACION",
				a.montoprestado as "MONTO PRESTADO",
				a.saldo as "SALDO",
				(case when f.dependede=1 then 'Consumo' 
					  when f.dependede=2 then 'Comercial' 
					  when f.dependede=3 then 'Vivienda' 
					  when f.dependede=0 then '(*)' end) "FINALIDAD",
				---TRAE EL FOLIO ANTERIOR
				rf.idorigenpr||'-'||rf.idproductor||'-'||rf.idauxiliarr as "Folio Anterior",
				--TRAE LA FECHA DE ACTIVACION DEL FOLIO ANTERIOR
				(select fechaactivacion from v_auxiliares v where v.idorigenp=rf.idorigenpr and v.idproducto=rf.idproductor 
					and v.idauxiliar=rf.idauxiliarr)as "Fecha Activacion Anterior",
				(select montoprestado from v_auxiliares v where v.idorigenp=rf.idorigenpr and v.idproducto=rf.idproductor 
					and v.idauxiliar=rf.idauxiliarr)as "Monto Prestado Anterior",
				(select saldo from v_auxiliares v where v.idorigenp=rf.idorigenpr and v.idproducto=rf.idproductor 
					and v.idauxiliar=rf.idauxiliarr)as "Saldo Anterior",
				(select case when f.dependede=1 then 'Consumo'
							 when f.dependede=2 then 'Comercial'
							 when f.dependede=3 then 'Vivienda' 
							 when f.dependede=0 then '(*)' end 
				from v_auxiliares v 
				inner join finalidades f using(idfinalidad)
				where v.idorigenp=rf.idorigenpr and v.idproducto=rf.idproductor and v.idauxiliar=rf.idauxiliarr)as "Finalidad Anterior", 
				(select estatus from v_auxiliares v where v.idorigenp=rf.idorigenpr and v.idproducto=rf.idproductor 
					and v.idauxiliar=rf.idauxiliarr)as "Estatus Anterior"
from auxiliares a 
	inner join referenciasp rf using(idorigenp,idproducto,idauxiliar)
	inner join finalidades f on (a.idfinalidad=f.idfinalidad)
	where a.estatus=2 and a.tipoprestamo in (2,3) and rf.tiporeferencia in(2,3) 
	and a.idorigenp > 0 and a.idproducto in (select idproducto from productos where tipoproducto = 2) and a.idauxiliar > 0 
	and f.dependede in(1,2,3); 
