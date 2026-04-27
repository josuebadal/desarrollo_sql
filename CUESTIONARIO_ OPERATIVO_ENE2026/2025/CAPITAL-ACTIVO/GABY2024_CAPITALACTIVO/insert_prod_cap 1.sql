delete from tablas where idtabla='cuestionario_opera_cnbv';
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',1,'Captación: Cuentas a la vista','110,1111');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',2,'Captación: Cuentas a plazo','200, 201, 205, 206, 215');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',3,'Captación: Cuentas de ahorro', null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',6,'Captación: Depósitos en garantía', null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',7,'Cartera de crédito: Crédito con garab liquida', null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',8,'Cartera de crédito: Comercial','30801,30811,30821,30901,30911,31101,31111,31121,31501,31511,31704,31706,31714,31716,31724,31726,32201,32221,32301,32311,32321,32401,33002,33012');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',9,'Cartera de crédito: Factoraje financiero','30701, 30702, 30703');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',10,'Cartera de crédito: Consumo',' 30301, 30302, 30303, 30304, 30305, 30322, 30402, 30410, 30411');
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',11,'Cartera de crédito: Arrendamiento financiero',null);
insert into tablas(idtabla, idelemento, nombre, dato2) values('cuestionario_opera_cnbv',12,'Cartera de crédito: Vivienda','30601, 30602');
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

insert into tablas values ('prod_base_cuestionario_op', '1', NULL,   '110',   '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '2', NULL,   '1111',  '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '3', NULL,   '200',   '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '4', NULL,   '201',   '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '5', NULL,   '205',   '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '6', NULL,   '206',   '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '7', NULL,   '215',   '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '8', NULL,   '3111',  '0.01', NULL, NULL, NULL, 0);	
insert into tablas values ('prod_base_cuestionario_op', '9', NULL,   '30101', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '10', NULL,  '30102', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '11', NULL,  '30103', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '12', NULL,  '30104', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '13', NULL,  '30112', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '14', NULL,  '30121', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '15', NULL,  '30122', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '16', NULL,  '30201', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '17', NULL,  '30202', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '18', NULL,  '30212', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '19', NULL,  '30301', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '20', NULL,  '30302', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '21', NULL,  '30303', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '22', NULL,  '30304', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '23', NULL,  '30305', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '24', NULL,  '30322', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '25', NULL,  '30402', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '26', NULL,  '30410', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '27', NULL,  '30411', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '28', NULL,  '30412', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '29', NULL,  '30501', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '30', NULL,  '30502', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '31', NULL,  '30512', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '32', NULL,  '30513', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '33', NULL,  '30601', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '34', NULL,  '30602', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '35', NULL,  '30701', '0.01', NULL, NULL, NULL, 0); 
insert into tablas values ('prod_base_cuestionario_op', '36', NULL,  '30702', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '37', NULL,  '30703', '0.01', NULL, NULL, NULL, 0);
insert into tablas values ('prod_base_cuestionario_op', '38', NULL,  '39999', '0.01', NULL, NULL, NULL, 0); 




----TABLA ESTADOS
select * from tabla_estados_para_cuestionarios();
