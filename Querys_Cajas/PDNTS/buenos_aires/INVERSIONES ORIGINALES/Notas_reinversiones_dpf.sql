--Sacar las inerversiones activas
 idorigen | idgrupo | idsocio | idorigenp | idproducto | idauxiliar | fechaactivacion | elaboro 
----------+---------+---------+-----------+------------+------------+-----------------+---------
    30109 |      10 |   16757 |     30137 |        202 |        680 | 04/12/2025      |     999
    30133 |      10 |  122022 |     30139 |        202 |        818 | 04/12/2025      |    1618
    30122 |      10 |  110389 |     30122 |        201 |       2324 | 21/08/2024      |    1313
    30122 |      10 |  266788 |     30122 |        202 |        291 | 21/09/2024      |    1313
    30109 |      10 |  191335 |     30109 |        202 |       2236 | 03/12/2025      |     999
    30124 |      10 |  222109 |     30124 |        202 |       1973 | 03/12/2025      |     999
    30125 |      10 |  201842 |     30125 |        202 |        812 | 03/12/2025      |     999


--Validar las inversiones anterior en auxiliares_d , la poliza original sale con la fecha de activacion
select * from v_auxiliares_d where (idorigenp,idproducto,idauxiliar) = (30146,202,124);

--Valdidar quien esta en referenciasp 
--No existe datos en referenciasp lo debe traer de otr amanera
select * from referenciasp where (idorigenp,idproducto,idauxiliar) = (30146,202,124);
