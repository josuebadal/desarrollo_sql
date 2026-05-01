UPDATE tablas
SET tipo = -456
where    idtabla = 'param' 
and idelemento like 'formato_analisis_credito_b' ;

UPDATE tablas
SET tipo = 0
where    idtabla = 'param' 
and idelemento like 'formato_analisis_credito_b' ;

/*
INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato2,dato3,dato4,dato5,tipo)
VALUES ('param','indicador_inegi','Indicador Inegi',null,'18',null,null,null,0);
*/

UPDATE tablas
SET dato2 = ''
where    idtabla = 'param' 
and idelemento like 'formato_analisis_credito_b' ;
