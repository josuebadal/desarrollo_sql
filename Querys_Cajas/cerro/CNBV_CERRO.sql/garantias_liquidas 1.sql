
-- ##########################################################################################
-- ##########################################################################################
--                                        PRIMERA FASE
-- ##########################################################################################
-- ##########################################################################################

-- -----------------------------------------------------------------------------   
-- REVISION EN AUXILIARES
-- -----------------------------------------------------------------------------
-- TODOS LOS AUXILIARES CON SALDO O SIN SALDO

SELECT prestamos AS garantia_prestamos, ahorros AS garantia_ahorros, prestamos-ahorros AS diferencia_garantia_auxiliares 
  FROM (SELECT 
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto BETWEEN 30000 AND 39999) AS prestamos,
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto NOT BETWEEN 30000 AND 39999) AS ahorros
       ) AS x;

SELECT prestamos AS garantia_prestamos, ahorros AS garantia_ahorros, prestamos-ahorros AS diferencia_garantia_auxiliares 
  FROM (SELECT 
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto BETWEEN 30000 AND 39999 AND saldo > 0) AS prestamos,
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto NOT BETWEEN 30000 AND 39999 AND saldo > 0) AS ahorros
       ) AS x;

-- -----------------------------------------------------------------------------
-- ELIMINANDO GARANTIAS CON INCONSISTENCIA
-- -----------------------------------------------------------------------------

SELECT count(1) AS "AUXILIARES: Folios con GARANTIA mayor al SALDO" FROM auxiliares WHERE garantia > saldo ;
UPDATE auxiliares SET garantia = saldo WHERE garantia > saldo AND saldo >= 0; 
SELECT count(1) AS "AUXILIARES: Folios con GARANTIA Negativa" FROM auxiliares WHERE garantia < 0;
UPDATE auxiliares SET garantia = 0 WHERE garantia < 0; 

-- -----------------------------------------------------------------------------
-- BORRA TABLA DE PASO
-- -----------------------------------------------------------------------------

DROP TABLE xgarantias;

 -- -----------------------------------------------------------------------------
-- CREA NUEVA TABLA CON SOCIOS CON DESBALANCEO EN GARANTIAS
-- -----------------------------------------------------------------------------
SELECT 'CREA tabla XGARANTIAS Socios con diferencia en sus garantias' AS procesando;
DROP TABLE xgarantias;
SELECT * INTO xgarantias FROM (
SELECT idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar, 
       saldo, garantia, estatus AS e, 0.00 ga_pre, 0.00 ga_aho, 0.00 sa_pre, 0.00 sa_aho, 0 AS fa, 0 AS ft, 
	   0.00 AS ga_tp0, 0.00 AS ga_tp18, 00 AS br
 FROM auxiliares AS a
WHERE a.garantia <> 0) AS x;

-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

-- -----------------------------------------------------------------------------
-- CREA INDICES DE TABLA xgarantias
-- -----------------------------------------------------------------------------
CREATE INDEX xgarantias_idx1 ON xgarantias (idorigenp,idproducto,idauxiliar);
CREATE INDEX xgarantias_idx2 ON xgarantias (idorigen,idgrupo,idsocio); 

-- -----------------------------------------------------------------------------
-- LLENA EL MONTO DEL TOTAL DE GARANTIAS DE LOS PRESTAMOS DEL SOCIO
-- UPDATE PREVIO PARA LLENAR DATOS
-- -----------------------------------------------------------------------------
-- SUMA DE GARANTIAS DE PRESTAMOS
UPDATE xgarantias
   SET ga_pre = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(garantia) AS monto
             FROM xgarantias
            WHERE idproducto BETWEEN 30000 AND 39999
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   

-- -----------------------------------------------------------------------------
-- SUMA DE SALDOS DE PRESTAMOS
-- -----------------------------------------------------------------------------
UPDATE xgarantias
   SET sa_pre = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(saldo) AS monto
             FROM xgarantias
            WHERE idproducto BETWEEN 30000 AND 39999
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   

-- -----------------------------------------------------------------------------
-- LLENA EL MONTO DEL TOTAL DE GARANTIAS DE AHORROS DEL SOCIO
-- UPDATE PREVIO PARA LLENAR DATOS
-- -----------------------------------------------------------------------------
-- SUMA DE GARANTIAS DE AHORROS
UPDATE xgarantias
   SET ga_aho = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(garantia) AS monto
             FROM xgarantias
            WHERE idproducto NOT BETWEEN 30000 AND 39999
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;

-- ---------------------------------------------------------------------------------------------------------------   
-- ================================  =============================================================================
-- ================================  =============================================================================
-- ===== UPDATE DE AUXILIARES =====  Elimina garantias liquidas AUXILIARES cuando solo tienen garantia de un lado
-- ================================  =============================================================================
-- ================================  =============================================================================
-- ---------------------------------------------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de AUXILIARES los PRESTAMOS cuando no tiene AHORROS con garantia .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE idproducto BETWEEN 30000 AND 39999 AND ga_aho = 0) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

SELECT 'Elimina garantias liquidas de AUXILIARES los AHORROS cuando no tiene PRESTAMOS con garantia .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE idproducto NOT BETWEEN 30000 AND 39999 AND ga_pre = 0) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

-- -----------------------------------------------------------------------------
-- ELIMINA DE LA TABLA DE PASO LAS PERSONAS QUE SOLO TIENEN UN FOLIO
-- -----------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de XGARANTIAS cuando solo tienen garantia de un lado .....' AS procesando;

DELETE FROM xgarantias WHERE ga_aho = 0 OR ga_pre = 0;

-- -----------------------------------------------------------------------------
-- NOS DAMOS CUENTA QUE EL UPDATE PREVIO LOCALIZO A PERSONAS CON UN SOLO FOLIO
-- -----------------------------------------------------------------------------
SELECT count(1) AS personas_con_un_solo_folio FROM xgarantias WHERE ft = 1;

-- TEMPORAL	   
SELECT idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar, saldo, garantia, ga_aho, ga_pre,
       'REVISAR REVISAR REVISAR REVISAR' AS "M E N S A J E"
  FROM xgarantias WHERE ga_aho = 0 OR ga_pre= 0;

-- SUMA DE GARANTIAS DE AHORROS
UPDATE xgarantias
   SET sa_aho = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(saldo) AS monto
             FROM xgarantias
            WHERE idproducto NOT BETWEEN 30000 AND 39999
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;

-- -----------------------------------------------------------------------------
-- BUSCA PRODUCTOS DE AHORRO EN GARANTIA
-- -----------------------------------------------------------------------------
SELECT 'XGARANTIAS: Lista productos de Grantia de Captacion .....' AS procesando;

SELECT * FROM (
SELECT idproducto, sum(garantia) AS suma_garantia 
  FROM xgarantias INNER JOIN productos AS p USING (idproducto)
 WHERE p.tipoproducto IN (0,1,8)  
       GROUP BY idproducto ORDER BY idproducto
               ) AS x WHERE suma_garantia <> 0;

-- -----------------------------------------------------------------------------
-- LLENA EL MONTO DE GARANTIAS DE PRODUCTOS TIPO 0 = AHORROS
-- -----------------------------------------------------------------------------

UPDATE xgarantias
   SET ga_tp0 = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(garantia) AS monto
             FROM xgarantias
            WHERE idproducto < 200
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;

-- -----------------------------------------------------------------------------
-- LLENA EL MONTO DE GARANTIAS DE PRODUCTOS TIPO 1,8 = DEPOSITOS E INVERAHORROS
-- -----------------------------------------------------------------------------

UPDATE xgarantias
   SET ga_tp18 = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(garantia) AS monto
             FROM xgarantias
            WHERE idproducto >= 200 AND idproducto < 30000
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;

-- -----------------------------------------------------------------------------
-- QUITA DE LA JUGADA AQUELLOS SOCIOS QUE SUMANDO LAS GARANTIAS DE LOS AHORROS SON IGUALES A SUS PRESTAMOS
-- -----------------------------------------------------------------------------

DELETE FROM xgarantias WHERE ga_pre = ga_aho;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 01' AS pasos;


-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------

SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

-- ========================================================================================================================== 
-- INICIO 
-- -----------------------------------------------------------------------------
-- LLENA EL CONTEO DE FOLIOS CON GARANTIA
-- ESTO SE HACE PARA DISTINGUIR A LAS PERSONAS QUE SOLO TIENEN UN FOLIO
-- PORQUE QUIENES SOLO TIENEN UN FOLIO CON GARANTIA DEBERA COLOCARSE EN CEROS 
-- LO NORMAL ES QUE AL MENOS HAYA UN FOLIO DE AHORRO Y UNO DE PRESTAMO NO SOLO UNO
-- -----------------------------------------------------------------------------

SELECT 'XGARANTIAS: Llena el conteo de Folios con garantia' AS procesando;

UPDATE xgarantias
   SET ft = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   
 
-- -----------------------------------------------------------------------------
-- NOS DAMOS CUENTA QUE EL UPDATE PREVIO LOCALIZO A PERSONAS CON UN SOLO FOLIO
-- -----------------------------------------------------------------------------
SELECT count(1) AS personas_con_un_solo_folio FROM xgarantias WHERE ft = 1;

-- ---------------------------------------------------------------------------------------------------------------   
-- ================================  =============================================================================
-- ================================  =============================================================================
-- ===== UPDATE DE AUXILIARES =====  Elimina garantias liquidas de AUXILIARES de personas que solo tienen un folio
-- ================================  =============================================================================
-- ================================  =============================================================================
-- OK este si es un solo folio de todos los productos......
-- ---------------------------------------------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de AUXILIARES de personas que solo tienen un folio .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE ft = 1) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

-- -----------------------------------------------------------------------------
-- ELIMINA DE LA TABLA DE PASO LAS PERSONAS QUE SOLO TIENEN UN FOLIO
-- -----------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de XGARANTIAS de personas que solo tienen un folio .....' AS procesando;

DELETE FROM xgarantias WHERE ft = 1;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 02' AS pasos;
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;


-- FIN
-- ==========================================================================================================================


-- ========================================================================================================================== 
-- INICIO 

-- -----------------------------------------------------------------------------
-- LLENA EL CONTEO DE FOLIOS DE AHORRO CON GARANTIA
-- CUENTA LOS FOLIOS DE CAPTACION CON GARANTIA DEL SOCIO
-- -----------------------------------------------------------------------------

SELECT 'XGARANTIAS: Llena el conteo de Folios con garantia' AS procesando;

UPDATE xgarantias
   SET fa = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
            WHERE idproducto NOT BETWEEN 30000 AND 39999 
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	


UPDATE xgarantias
   SET ft = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;

-- -----------------------------------------------------------------------------------------------------------------   
-- ================================ ================================================================================
-- ================================ ================================================================================
-- ===== UPDATE DE AUXILIARES ===== Modifica garantía en AUXILIARES en AHORROS cuando es MAYOR a TODOS sus PRESTAMOS
-- ================================ ================================================================================
-- ================================ ================================================================================
-- -----------------------------------------------------------------------------------------------------------------

SELECT 'Modifica garantía en AUXILIARES en AHORROS cuando es MAYOR a TODOS sus PRESTAMOS' AS procesando;

-- SELECT * FROM xgarantias WHERE fa = 1 AND ga_pre < ga_aho ORDER BY idorigen, idgrupo, idsocio;

UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_pre AS total
          FROM xgarantias
         WHERE idproducto NOT BETWEEN 30000 AND 39999 AND fa = 1 AND ga_aho > ga_pre
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;

DELETE FROM xgarantias WHERE fa = 1 AND ga_pre < ga_aho;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 03' AS pasos;
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;


-- -----------------------------------------------------------------------------------------------------------------
-- ================================ ================================================================================
-- ===== UPDATE DE AUXILIARES ===== Modifica garantía en AUXILIARES 
-- ================================ ================================================================================
-- -----------------------------------------------------------------------------------------------------------------

SELECT 'Modifica garantía en AUXILIARES en AHORROS cuando ......' AS procesando;

UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_aho AS total
          FROM xgarantias
         WHERE idproducto BETWEEN 30000 AND 39999 AND 
			   fa = 1 AND ga_pre > ga_aho AND ga_pre > sa_aho AND ft = 2
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;
	
-- NUEVOS UPDATE CASO SAN ISIDRO



UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_pre AS total
          FROM xgarantias
         WHERE idproducto NOT BETWEEN 30000 AND 39999 AND 
			   fa = 1 AND ga_pre > ga_aho AND sa_aho >= ga_pre AND ft = 2
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;
-----------------------------------------------------------------------------		
UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_aho AS total
          FROM xgarantias
         WHERE idproducto BETWEEN 30000 AND 39999 AND 
			   fa = 1 AND ga_pre > ga_aho AND sa_aho < ga_pre AND ft = 2
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;		


SELECT 'BORRA los movimientos considerados de XGARANTIAS para modificar AUXILIARES' AS procesando;
DELETE FROM xgarantias WHERE fa = 1 AND ga_pre > ga_aho AND ga_pre > sa_aho AND ft = 2;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 04' AS pasos;
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;


-- SELECT * FROM xgarantias ORDER BY idorigen, idgrupo, idsocio, idproducto;
-- -----------------------------------------------------------------------------------------------------------------
-- ================================ ================================================================================
-- ===== UPDATE DE AUXILIARES ===== Modifica garantía en AUXILIARES 
-- ================================ ================================================================================
-- -----------------------------------------------------------------------------------------------------------------

--SELECT * FROM xgarantias WHERE fa = 1 AND ga_pre > ga_aho AND sa_aho > ga_pre AND ft > 2 ORDER BY idorigen, idgrupo, idsocio, idproducto;

UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_pre AS total
          FROM xgarantias
         WHERE idproducto NOT BETWEEN 30000 AND 39999 AND 
		       fa = 1 AND ga_pre > ga_aho AND sa_aho > ga_pre AND ft > 2 
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;

DELETE FROM xgarantias WHERE fa = 1 AND ga_pre > ga_aho AND sa_aho > ga_pre AND ft > 2;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 05' AS pasos;
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------

SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

-- ========================================================================================================================== 
-- INICIO 
-- -----------------------------------------------------------------------------
-- LLENA EL CONTEO DE FOLIOS TOTALES CON GARANTIA
-- -----------------------------------------------------------------------------

SELECT 'XGARANTIAS: Llena NUEVAMENTE el conteo de Folios totales con garantia' AS procesando;

UPDATE xgarantias
   SET ft = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   
 
-- -----------------------------------------------------------------------------
-- NOS DAMOS CUENTA QUE EL UPDATE PREVIO LOCALIZO A PERSONAS CON UN SOLO FOLIO
-- -----------------------------------------------------------------------------

SELECT count(1) AS personas_con_un_solo_folio FROM xgarantias WHERE ft = 1;

-- ---------------------------------------------------------------------------------------------------------------   
-- ================================  =============================================================================
-- ================================  =============================================================================
-- ===== UPDATE DE AUXILIARES =====  Elimina garantias liquidas de AUXILIARES de personas que solo tienen un folio
-- ================================  =============================================================================
-- ================================  =============================================================================
-- OK este si es un solo folio de todos los productos......
-- ---------------------------------------------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de AUXILIARES de personas que solo tienen un folio .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE ft = 1) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

-- -----------------------------------------------------------------------------
-- ELIMINA DE LA TABLA DE PASO LAS PERSONAS QUE SOLO TIENEN UN FOLIO
-- -----------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de XGARANTIAS de personas que solo tienen un folio .....' AS procesando;

DELETE FROM xgarantias WHERE ft = 1;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 08' AS pasos;

-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;


-- FIN
-- ==========================================================================================================================

SELECT * FROM xgarantias WHERE ga_tp18 = garantia AND idproducto BETWEEN 30000 AND 39999;
SELECT * FROM xgarantias WHERE ga_tp18 = garantia AND idproducto > 200 AND idproducto < 30000;

UPDATE xgarantias SET br = 1 WHERE ga_tp18 = garantia AND idproducto BETWEEN 30000 AND 39999;
UPDATE xgarantias SET br = 1 WHERE ga_tp18 = garantia AND idproducto > 200 AND idproducto < 30000;

-- EMIMINA LOS FOLIOS QUE ESTAN CUADRADOS
DELETE FROM xgarantias 
 WHERE (idorigen, idgrupo, idsocio) 
    IN (SELECT idorigen, idgrupo, idsocio FROM (
SELECT idorigen, idgrupo, idsocio, sum(br) AS total 
  FROM xgarantias GROUP BY idorigen, idgrupo, idsocio
              ) AS x WHERE total = 2) AND br=1;

SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 09' AS pasos;
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

-- -----------------------------------------------------------------------------   

-- -----------------------------------------------------------------------------
-- LLENA EL MONTO DEL TOTAL DE GARANTIAS DE LOS PRESTAMOS DEL SOCIO
-- -----------------------------------------------------------------------------

-- SUMA DE GARANTIAS DE PRESTAMOS

UPDATE xgarantias
   SET ga_pre = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(garantia) AS monto
             FROM xgarantias
            WHERE idproducto BETWEEN 30000 AND 39999
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   


-- -----------------------------------------------------------------------------
-- LLENA EL MONTO DEL TOTAL DE GARANTIAS DE AHORROS DEL SOCIO
-- -----------------------------------------------------------------------------

-- SUMA DE GARANTIAS DE AHORROS

UPDATE xgarantias
   SET ga_aho = z.monto 
  FROM    (SELECT idorigen,idgrupo,idsocio,sum(garantia) AS monto
             FROM xgarantias
            WHERE idproducto NOT BETWEEN 30000 AND 39999
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;


-- ---------------------------------------------------------------------------------------------------------------   
-- ================================  =============================================================================
-- ================================  =============================================================================
-- ===== UPDATE DE AUXILIARES =====  Elimina garantias liquidas AUXILIARES cuando solo tienen garantia de un lado
-- ================================  =============================================================================
-- ================================  =============================================================================

-- ---------------------------------------------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de AUXILIARES los PRESTAMOS cuando no tiene AHORROS con garantia .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE idproducto BETWEEN 30000 AND 39999 AND ga_aho = 0) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

SELECT 'Elimina garantias liquidas de AUXILIARES los AHORROS cuando no tiene PRESTAMOS con garantia .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE idproducto NOT BETWEEN 30000 AND 39999 AND ga_pre = 0) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

-- -----------------------------------------------------------------------------
-- ELIMINA DE LA TABLA DE PASO LAS PERSONAS QUE SOLO TIENEN UN FOLIO
-- -----------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de XGARANTIAS cuando solo tienen garantia de un lado .....' AS procesando;

DELETE FROM xgarantias WHERE ga_aho = 0 OR ga_pre = 0;

-- -----------------------------------------------------------------------------
-- NOS DAMOS CUENTA QUE EL UPDATE PREVIO LOCALIZO A PERSONAS CON UN SOLO FOLIO
-- -----------------------------------------------------------------------------
SELECT count(1) AS personas_con_un_solo_folio FROM xgarantias WHERE ft = 1;


-- TEMPORAL	   
SELECT idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar, saldo, garantia, ga_aho, ga_pre,
       'REVISAR REVISAR REVISAR REVISAR' AS "M E N S A J E"
  FROM xgarantias WHERE ga_aho = 0 OR ga_pre= 0;

-- -----------------------------------------------------------------------------
-- LLENA FOLIOS TOTALES
-- -----------------------------------------------------------------------------

UPDATE xgarantias
   SET ft = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE ft = 1) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

DELETE FROM xgarantias WHERE ft = 1;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 10' AS pasos;
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

-- -----------------------------------------------------------------------------
-- LLENA FOLIOS DE AHORRO
-- -----------------------------------------------------------------------------

UPDATE xgarantias
   SET fa = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
            WHERE idproducto NOT BETWEEN 30000 AND 39999 
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	

UPDATE xgarantias
   SET ft = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;

UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_pre AS total
          FROM xgarantias
         WHERE idproducto NOT BETWEEN 30000 AND 39999 AND fa = 1 AND ga_aho > ga_pre
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;

DELETE FROM xgarantias WHERE fa = 1 AND ga_pre < ga_aho;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 11' AS pasos;

-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------

SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

UPDATE auxiliares
   SET garantia = z.total
  FROM (SELECT idorigenp, idproducto, idauxiliar, ga_aho AS total
          FROM xgarantias
         WHERE idproducto BETWEEN 30000 AND 39999 AND 
			   fa = 1 AND ga_pre > ga_aho AND ga_pre > sa_aho AND ft = 2
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;
	
SELECT 'BORRA los movimientos considerados de XGARANTIAS para modificar AUXILIARES' AS procesando;
DELETE FROM xgarantias WHERE fa = 1 AND ga_pre > ga_aho AND ga_pre > sa_aho AND ft = 2;
SELECT * FROM xgarantias WHERE idorigen = 030201 AND idgrupo = 10 AND idsocio = 8897;
SELECT '=======          >>>>>      PASO 12' AS pasos;

-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

-- SE BORRA TABLA xultimos

DROP TABLE xultimos;

-- SE CREA TABLA CON LOS ULTIMOS FOLIOS QUE NO SE ELIMINARON
SELECT * INTO xultimos FROM ( 
SELECT * FROM (
SELECT x.idorigen, x.idgrupo, x.idsocio, x.idorigenp, x.idproducto, x.idauxiliar, x.saldo, x.garantia,
       r.idorigenpr, r.idproductor, r.idauxiliarr,
	   (SELECT saldo FROM auxiliares AS a 
	     WHERE a.idorigenp = r.idorigenpr AND a.idproducto = r.idproductor AND a.idauxiliar = r.idauxiliarr) AS sdo
  FROM xgarantias AS x INNER JOIN referenciasp AS r USING (idorigenp, idproducto, idauxiliar)
 WHERE r.tiporeferencia = 4
               ) AS x WHERE sdo > 0) AS y;

-- SE IDENTIFICAN FOLIOS QUE ESTAN EN xgarantias PERO QUE NO ESTAN VINCULADOS A REFERENCIAS P

SELECT xg.idorigenp, xg.idproducto, xg.idauxiliar, xg.saldo, xg.garantia
  FROM xgarantias AS xg 
 WHERE xg.idproducto < 30000 AND NOT EXISTS 
       (SELECT xu.idorigenpr, xu.idproductor, xu.idauxiliarr
          FROM xultimos AS xu
         WHERE xu.idorigenpr  = xg.idorigenp AND  
               xu.idproductor = xg.idproducto AND 
               xu.idauxiliarr = xg.idauxiliar);

-- QUITA LA GARANTIA DE AUXILIARES

UPDATE auxiliares
   SET garantia = 0
  FROM (
  
SELECT xg.idorigenp, xg.idproducto, xg.idauxiliar, xg.saldo, xg.garantia
  FROM xgarantias AS xg 
 WHERE xg.idproducto < 30000 AND NOT EXISTS 
       (SELECT xu.idorigenpr, xu.idproductor, xu.idauxiliarr
          FROM xultimos AS xu
         WHERE xu.idorigenpr  = xg.idorigenp AND  
               xu.idproductor = xg.idproducto AND 
               xu.idauxiliarr = xg.idauxiliar)  
  
		 ) AS z 
  WHERE auxiliares.idorigenp = z.idorigenp AND
        auxiliares.idproducto = z.idproducto AND
        auxiliares.idauxiliar = z.idauxiliar;



-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================

------------------------------------------------------------- 
-- ELIMINA LOS FOLIOS QUE ESTAN CUADRADOS
-- CUANDO HAY PERSONAS CON TRES FOLIOS Y SOBRA UNO QUE NO ESTA LIGADO PERO TIENE GARANTIA
-------------------------------------------------------------
DELETE FROM xgarantias 
 WHERE (idorigenp, idproducto, idauxiliar) 
    IN (
SELECT idorigenp, idproducto, idauxiliar
  FROM xgarantias 
 WHERE garantia 
    IN (SELECT garantia 
          FROM (SELECT garantia AS garantia, sum(conteo) AS conteo 
                 FROM (SELECT garantia, count(1) AS conteo FROM xgarantias WHERE ft = 3 GROUP BY garantia 
                UNION 
		       SELECT ga_aho, count(1) AS conteo FROM xgarantias WHERE ft = 3 GROUP BY ga_aho
	           ) AS x GROUP BY garantia
	   ) AS y WHERE conteo = 5)
	   ) ;

	
-- ----------------------------------------------------------------------------------------------
-- CUENTA REGISTROS DE TABLA xgarantias PARA VER EL AVANCE. AL FINAL DEBE QUEDAR VACIA
-- ----------------------------------------------------------------------------------------------
SELECT count(1) AS "Si el conteo de la tabla XGARANTIAS es CERO hemos TERMINADO" FROM xgarantias;

SELECT 'XGARANTIAS: Llena el conteo de Folios con garantia' AS procesando;

UPDATE xgarantias
   SET ft = z.total 
  FROM    (SELECT idorigen,idgrupo,idsocio,count(1) AS total
             FROM xgarantias
				  GROUP BY idorigen,idgrupo,idsocio) AS z 
     WHERE xgarantias.idorigen = z.idorigen
       AND xgarantias.idgrupo = z.idgrupo 
       AND xgarantias.idsocio = z.idsocio;	   
 
-- -----------------------------------------------------------------------------
-- NOS DAMOS CUENTA QUE EL UPDATE PREVIO LOCALIZO A PERSONAS CON UN SOLO FOLIO
-- -----------------------------------------------------------------------------
SELECT count(1) AS personas_con_un_solo_folio FROM xgarantias WHERE ft = 1;

-- ---------------------------------------------------------------------------------------------------------------   
-- ================================  =============================================================================
-- ================================  =============================================================================
-- ===== UPDATE DE AUXILIARES =====  Elimina garantias liquidas de AUXILIARES de personas que solo tienen un folio
-- ================================  =============================================================================
-- ================================  =============================================================================
-- OK este si es un solo folio de todos los productos......
-- ---------------------------------------------------------------------------------------------------------------

SELECT 'Elimina garantias liquidas de AUXILIARES de personas que solo tienen un folio .....' AS procesando;

UPDATE auxiliares
   SET garantia = 0
  FROM (SELECT idorigenp, idproducto, idauxiliar
          FROM xgarantias
         WHERE ft = 1) AS z 
     WHERE auxiliares.idorigenp = z.idorigenp
       AND auxiliares.idproducto = z.idproducto 
       AND auxiliares.idauxiliar = z.idauxiliar;

-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================
-- =======================================================================================================================



-- -----------------------------------------------------------------------------   
-- REVISION EN AUXILIARES
-- -----------------------------------------------------------------------------
-- TODOS LOS AUXILIARES CON SALDO O SIN SALDO

SELECT prestamos AS garantia_prestamos, 
       ahorros AS garantia_ahorros, 
	   prestamos-ahorros AS diferencia_garantia_auxiliares 
  FROM (SELECT 
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto BETWEEN 30000 AND 39999) AS prestamos,
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto NOT BETWEEN 30000 AND 39999) AS ahorros
       ) AS x;

SELECT prestamos AS garantia_prestamos, 
       ahorros AS garantia_ahorros, 
	   prestamos-ahorros AS diferencia_garantia_auxiliares 
  FROM (SELECT 
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto BETWEEN 30000 AND 39999 AND saldo > 0) AS prestamos,
       (SELECT sum(garantia) FROM auxiliares WHERE idproducto NOT BETWEEN 30000 AND 39999 AND saldo > 0) AS ahorros
       ) AS x;

-- -----------------------------------------
-- CREA TABLA gahorros;
-- -----------------------------------------

DROP TABLE gahorros;
SELECT * INTO gahorros 
  FROM (SELECT idorigen, idgrupo, idsocio, sum(garantia) AS garantia 
          FROM auxiliares WHERE idproducto < 30000 
		       GROUP BY  idorigen, idgrupo, idsocio 
			   ORDER BY  idorigen, idgrupo, idsocio
	    ) AS x WHERE garantia <> 0;

-- -----------------------------------------
-- CREA TABLA gprestamos;
-- -----------------------------------------

DROP TABLE gprestamos;
SELECT * INTO gprestamos 
  FROM (SELECT idorigen, idgrupo, idsocio, sum(garantia) AS garantia 
          FROM auxiliares WHERE idproducto > 30000 
		       GROUP BY  idorigen, idgrupo, idsocio 
			   ORDER BY  idorigen, idgrupo, idsocio
	    ) AS x WHERE garantia <> 0;


-- -----------------------------------------
-- PERSONAS QUE TIENE LA DIFERENCIA
-- -----------------------------------------

SELECT a.idorigen, a.idgrupo, a.idsocio, a.garantia
  FROM gahorros AS a
 WHERE NOT EXISTS 
       (SELECT p.idorigen, p.idgrupo, p.idsocio, p.garantia
          FROM gprestamos AS p
         WHERE a.idorigen  = p.idorigen AND  
               a.idgrupo = p.idgrupo AND 
               a.idsocio = p.idsocio)
                     UNION			   
SELECT p.idorigen, p.idgrupo, p.idsocio, p.garantia
  FROM gprestamos AS p
 WHERE NOT EXISTS 
       (SELECT a.idorigen, a.idgrupo, a.idsocio, a.garantia
          FROM gahorros AS a
         WHERE a.idorigen  = p.idorigen AND  
               a.idgrupo = p.idgrupo AND 
               a.idsocio = p.idsocio)
                      UNION
SELECT a.idorigen, a.idgrupo, a.idsocio, a.garantia
  FROM gahorros AS a INNER JOIN gprestamos AS p USING (idorigen, idgrupo, idsocio)
 WHERE a.garantia <> p.garantia
                      UNION
SELECT p.idorigen, p.idgrupo, p.idsocio, p.garantia
  FROM gprestamos AS p INNER JOIN gahorros AS a USING (idorigen, idgrupo, idsocio)
 WHERE a.garantia <> p.garantia;



-- #############################################################################################
-- #                                                                                           #
-- #   ##### ##### ##  #     ####  ##### #         ##### ##### ##### ##### ##### ##### #####   #
-- #   #       #   ### #     #   # #     #         #   # #   # #   # #     #     #     #   #   #
-- #   #####   #   #####     #   # ##### #         ##### ##### #   # #     ##### ##### #   #   #
-- #   #       #   # ###     #   # #     #         #     ###   #   # #     #         # #   #   #
-- #   #     ##### #  ##     ####  ##### #####     #     # ### ##### ##### ##### ##### #####   #
-- #                                                                                           #
-- #############################################################################################


