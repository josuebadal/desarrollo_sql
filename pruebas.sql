  x_formato := replace(x_formato,'@@considera_importe@@', 
      (CASE 
        WHEN r_sec.ingresosordinarios::numeric > x_divide_estimacion::numeric then  r_sec.ingresosordinarios
        ELSE x_divide_estimacion
        END)::text);


-----------------------------------
      x_mes   := '@@flujo_ah_mes_'||x_cont::text||'@@';
      x_monto := '@@flujo_ah_monto_'||x_cont::text||'@@';
      x_formato := replace(x_formato,x_mes,   sai_formato_analisis_credito_nombre_periodo (x_periodo_ah::text));
      x_formato := replace(x_formato,x_monto, 
                    case when x_periodo_ah is NULL then '' 
                    else trim(to_char(x_monto_abonos, '999,999,999.00')) 
                    end);

      x_suma_abonos := x_suma_abonos + x_monto_abonos;