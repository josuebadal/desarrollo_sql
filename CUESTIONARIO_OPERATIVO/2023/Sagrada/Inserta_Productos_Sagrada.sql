delete from tablas where idtabla='cuestionario_opera_cnbv2023';
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 1,  'Captación: Cuentas a la vista', 						'130,131');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 2,  'Captación: Cuentas a plazo', 							'200,201');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 3,  'Captación: Cuentas de ahorro', 						'110,111,114,115,118,119,124,125,132,140,142,143');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 6,  'Captación: Depósitos en garantía', 					'120');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 7,  'Cartera de crédito:Crédito con garantía liquida', 	'30902,30912,30922,34902,34912,34922,35002,35102');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 8,  'Cartera de crédito:Comercial', 						'31315,31021,31325,31305,34602,31324,31304,31001,31306,31303,31314,31011,31323,31317,31326,31313');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 9,  'Cartera de crédito:Factoraje financiero', 			null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 10, 'Cartera de crédito:Consumo', 							'33402,35402,34802,30104,30107,35603,30106,30704,35502,30202,32902,30402,30502,30602,35802,31002,32802,32302,32202,30802,32102,33202,31102,32402,32602,33102,34402,33002,33902,34702,33302,33702,34002,34502,35202,31203,32002,32502,32702,33802,33602,34102,35702,30103,33502,34202,30105,30102,35602,34112,34302,30512,30724,31223,30812,31213,33512,35512,30412,33212,33012,33412,30714,31112,30612,34122,30112,34412,30212,31012,30113,33312,33112,34212,35613,33712,33812,33612,33912,34012,35612,30115,30312,30120,30117,32512,30322,33822,35522,34322,30522,30122,35622,30422,35623,30222,30822,34422,30622,30123,30130,31022,31122,34312,30108,30702,30712,30722,30110,30109,30119,30129,30302,30203,30213,30223,30703,30713');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 11, 'Cartera de crédito:Arrendamiento financiero', 		null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 12, 'Cartera de crédito:Vivienda', 						'35303,31813,31023,31613,31423,35902,31803,31413,31403,31503,31513,31523,31603,31623,31013,31033,31823,31117,31923,31903,31703,31713,31723,31913');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 13, 'Cartera de crédito:Puente', 							null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 21, 'Servicio:Comp de moneda ext Comision Naci',			null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 22, 'Mercado C: Compra Venta de divisas en efectivo',		null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 23, 'Mercado C: Compra Venta de divisas en efectivo',		null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 25, 'C/V de divisas en cheq expedidoterritorio na.',		null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 26, 'C/V de divisas en cheq expedido extranjero',			null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 27, 'Servicio: Órdenes de pago nacionales',	 			'436');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 28, 'Servicio: Órdenes de pago internacionales',			'432');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 29, 'Servicios: Venta y recargas de tarjetas prepagadas',	null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 33, 'Contravalor C/V de divisas en transfe inter',			null);
-----Datos Sociales 
delete from tablas where idtabla='prod_base_cuestionario_op';
insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '100', '1000.0', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '140', '1.0', NULL, NULL, NULL, 0);
----TABLA ESTADOS
select * from tabla_estados_para_cuestionarios();