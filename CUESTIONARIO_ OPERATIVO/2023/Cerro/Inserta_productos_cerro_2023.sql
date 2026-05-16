delete from tablas where idtabla='cuestionario_opera_cnbv2023';
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',1,'Captación: Cuentas a la vista','130');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',2,'Captación: Cuentas a plazo','200');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',3,'Captación: Cuentas de ahorro','110,120');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',6,'Captacion: Depositos en garantia',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',7,'Cartera de crédito: Crédito con garantía liq',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',8,'Cartera de crédito: Comercial',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',9,'Cartera de crédito: Factoraje financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',10,'Cartera de crédito: Consumo','30102,30133,34202,30602,37002,36002,32102,32132,32802,32832,33902,33932,32002,30302,30332,30402,30432,31802,30702,30202,30406,34102,32702,30132,31812,32112,33912,30112,32012,32712,34112,32812,30312,30412,30122,30222,34122,30142,32822,32722,33822');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',11,'Cartera de crédito: Arrendamiento financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',12,'Cartera de crédito: Vivienda','30103,30134');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',13,'Cartera de crédito: Puente',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',21,'Servicio: Compra de moneda extranjera Comi Naci',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',22,'Mercado Cambiario: Compra Venta de divisas en efec',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',23,'Mercado Cambiario: Compra Venta de divisas trans',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',25,'Mercado Cambiario: Compra Venta de div che terri',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',26,'Mercado Cambiario: Compra Venta de div chee extra',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',27,'Servicio: Órdenes de pago nacionales',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',28,'Servicio: Órdenes de pago internacionales',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',29,'Servicios: Venta y recargas de tarjetas prepagadas',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023',33,'Mercado Cambiario: Contra_Comp Venta divs tran int',null);

delete from tablas where idtabla='prod_base_cuestionario_op';
insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '101', '2000.0', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '120', '1.0', NULL, NULL, NULL, 0);

select * from tabla_estados_para_cuestionarios();