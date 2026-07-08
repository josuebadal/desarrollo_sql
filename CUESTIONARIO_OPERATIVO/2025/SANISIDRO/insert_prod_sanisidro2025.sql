delete from tablas where idtabla='cuestionario_opera_cnbv';

insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',1,'Captación: Cuentas a la vista','113,114,130');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',2,'Captación: Cuentas a plazo','200');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',3,'Captación: Cuentas de ahorro','110,111,120');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',6,'Captación: Depósitos en garantía',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',7,'Cartera de crédito: Crédito con garab liquida',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',8,'Cartera de crédito: Comercial',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',9,'Cartera de crédito: Factoraje financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',10,'Cartera de crédito: Consumo','30102,30112,30122,30202,30212,30222,30302,30312,30402,30412,31602,31612,31802,31812,31902,31912,32602,32612,32702,32712,32802');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',11,'Cartera de crédito: Arrendamiento financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',12,'Cartera de crédito: Vivienda',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',13,'Cartera de crédito: Puente',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',21,'Servicio: Compra de moneda extranjera Comi Naci',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',22,'Mercado Cambiario: Compra Venta de divisas en efec',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',23,'Mercado Cambiario: Compra Venta de divisas trans',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',25,'Mercado Cambiario: Compra Venta de div che terri',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',26,'Mercado Cambiario: Compra Venta de div chee extra',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',27,'Servicio: Órdenes de pago nacionales',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',28,'Servicio: Órdenes de pago internacionales',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',29,'Servicios: Venta y recargas de tarjetas prepagadas',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',33,'Mercado Cambiario: Contra_Comp Venta divs tran int',null);

delete from tablas where idtabla='prod_base_cuestionario_op';
insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '101', '1000.0', NULL, NULL, NULL, 0); ---- Insertar certificados de aportacion o partes sociales
insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '120', '0.01', NULL, NULL, NULL, 0); ---- Insertar ahorros menores
--insert into tablas values ('prod_base_cuestionario_op', '3', NULL, '615', '1.0', NULL, NULL, NULL, 0); ---- Insertar remesas

----TABLA ESTADOS
select * from tabla_estados_para_cuestionarios();