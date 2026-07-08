delete from tablas where idtabla='cuestionario_opera_cnbv';

insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',1,'Captación: Cuentas a la vista','130');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',2,'Captación: Cuentas a plazo','204');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',3,'Captación: Cuentas de ahorro','110,120');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',6,'Captación: Depósitos en garantía','11207,11208,11209,11211,11215,11217,11218,11219,11220,11221,11222,11223');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',7,'Cartera de crédito: Crédito con garab liquida','30803,30805,30808,30813,30815,30823,30825,30905,31103,31105,31115,31123,31125,31503,31505,31515,31703,31705,31708,31715,31725,31902,31912,32005,32015,32102,32112,32605,32615,32703,32809,32819,33001,33003,33011,33013');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',8,'Cartera de crédito: Comercial','30811,30821,30901,30911,31101,31111,31121,31501,31511,31704,31706,31714,31716,31724,31726,32201,32221,32301,32311,32321,32401,33002,33012');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',9,'Cartera de crédito: Factoraje financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',10,'Cartera de crédito: Consumo','30705,33101,33201,33301,33401');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',11,'Cartera de crédito: Arrendamiento financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',12,'Cartera de crédito: Vivienda','32803');
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
insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '101', '500.0', NULL, NULL, NULL, 0); -- Parte social
insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '120', '1.0', NULL, NULL, NULL, 0); -- Ahorro menor
insert into tablas values ('prod_base_cuestionario_op', '3', NULL, '615', '1.0', NULL, NULL, NULL, 0); ---- Insertar remesas

----TABLA ESTADOS
select * from tabla_estados_para_cuestionarios();