--Sacar las inerversiones activas

30138 |      10 |  233635 |     30146 |        202 |        124 |    1018 | 18/10/2025      |  300000.00 | INVERPLUSMAX6          |       2
  30133 |      10 |  122022 |     30139 |        202 |        818 |    1618 | 04/12/2025      |   10000.00 | INVERPLUSMAX6          |       2
    30122 |      10 |  110389 |     30122 |        201 |       2324 |    1313 | 21/08/2024      |   50000.00 | Inver-Mas              |       2
    30122 |      10 |  266788 |     30122 |        202 |        291 |    1313 | 21/09/2024      |   20000.00 | INVERPLUSMAX6          |       2
    30137 |      10 |  155471 |     30137 |        203 |        180 |    1256 | 09/04/2025      |  100007.00 | INVERPLUSMAX12         |       2
    30106 |      10 |   85773 |     30135 |        203 |        574 |    1481 | 13/04/2025      |  100000.00 | INVERPLUSMAX12         |       2

--Validar las inversiones anterior en auxiliares_d , la poliza original sale con la fecha de activacion
select * from v_auxiliares_d where (idorigenp,idproducto,idauxiliar) = (30146,202,124);

--Valdidar quien esta en referenciasp 
--No existe datos en referenciasp lo debe traer de otr amanera
select * from referenciasp where (idorigenp,idproducto,idauxiliar) = (30146,202,124);
