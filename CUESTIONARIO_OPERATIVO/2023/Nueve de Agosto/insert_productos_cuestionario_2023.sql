delete from tablas where idtabla='cuestionario_opera_cnbv2023';
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 1,  'Captación: Cuentas a la vista', 						'130');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 2,  'Captación: Cuentas a plazo', 							'204');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 3,  'Captación: Cuentas de ahorro', 						'110,120');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 6,  'Captación: Depósitos en garantía', 					'11208, 11217, 11219, 11220, 11221, 11222');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 7,  'Crédito con garantía líquida',						'30805, 30815, 31505, 31704, 31714,31902, 32005, 32102, 32201, 32301, 32311, 32401, 32605, 32615,32809, 32819, 33001');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 8,  'Cartera de crédito: Comercial',						'32301, 32311, 32201, 32401, 31704, 31714');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 9,  'Cartera de crédito: Factoraje financiero',			null);	
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 10, 'Cartera de crédito: Consumo', 						'31902, 32102, 30705, 30805, 31505, 32005, 32605, 32615, 32809, 32819, 33001');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 11, 'Cartera de crédito: Arrendamiento financiero',		null);	
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 12, 'Cartera de crédito: Vivienda',						'32703, 32803');	
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 13, 'Cartera de crédito: Puente', 							null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 21, 'Servicio: Compra de moneda extranjera C.N.', 	null);	
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 22, 'Mercado cambiario: Compra Venta de D.E.', 						null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 23, 'Mercado cambiario: Compra Venta de D.T.I.', 	null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 25, 'Mercado cambiario: Compra Venta de D.C.E.T.N.', 		null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 26, 'Mercado cambiario: Compra Venta de D.C.E.E.', 		null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 27, 'Servicio: Órdenes de pago nacionales', 				null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 28, 'Servicio: Órdenes de pago internacionales', 			null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 29, 'Servicios: Venta y recargas de tarjetas prepagadas', 	null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv2023', 33, 'Contravalor - Compra Venta de D.T.I.', 	null);
	-----Datos Sociales 
delete from tablas where idtabla='prod_base_cuestionario_op';
insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '101', '500.0', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '120', '1.0', NULL, NULL, NULL, 0);
----TABLA ESTADOS
select * from tabla_estados_para_cuestionarios();