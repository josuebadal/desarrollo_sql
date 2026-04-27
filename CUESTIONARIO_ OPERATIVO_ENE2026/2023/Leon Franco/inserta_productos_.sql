delete from tablas where idtabla='cuestionario_opera_cnbv2023';
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',1,'Captación: Cuentas a la vista','130,121,120,131,170,111,131');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',2,'Captación: Cuentas a plazo','200,201,202,203');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',3,'Captación: Cuentas de ahorro','110');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',6,'Captación: Depósitos en garantía',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',7,'Cartera de crédito: Crédito con garantía liq',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',8,'Cartera de crédito: Comercial',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',9,'Cartera de crédito: Factoraje financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',10,'Cartera de crédito: Consumo','30202,30302,30402,30502,30602,30612,30702,30802,30902,31302,31402,31612,31902,32102,32202,32302,33102');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',12,'Cartera de crédito: Vivienda','31703');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',13,'Cartera de crédito: Puente',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',21,'Servicio: Compra de moneda extranjera Comi Naci',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',22,'Mercado Cambiario: Compra Venta de divisas en efec',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',23,'Mercado Cambiario: Compra Venta de divisas trans',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',25,'Mercado Cambiario: Compra Venta de div che terri',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',26,'Mercado Cambiario: Compra Venta de div chee extra',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',27,'Servicio: Órdenes de pago nacionales',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',28,'Servicio: Órdenes de pago internacionales','582');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',29,'Servicios: Venta y recargas de tarjetas prepagadas',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',33,'Mercado Cambiario: Contra_Comp Venta divs tran int',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',34,'Préstamo de Socios',null);
-----Datos Sociales 
delete from tablas where idtabla='prod_base_cuestionario_op';
insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '100', '950.0', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '120', '1.0', NULL, NULL, NULL, 0);
----TABLA ESTADOS
select * from tabla_estados_para_cuestionarios();