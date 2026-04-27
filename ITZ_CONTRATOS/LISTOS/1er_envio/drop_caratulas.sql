delete from tablas
where       idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef_%';
insert into tablas 
            (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_01','2269-139-004460/02-16923-0812','31302');

insert into tablas 
            (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_02','269-140-004464/05-13168-07-11','30102|30502|31102');

insert into tablas 
            (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_03','2269-435-004459/02-13186-0811','30402|31602|30602|31002|31502|31202|33202|30302|31212');