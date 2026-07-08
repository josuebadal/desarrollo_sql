
-----------------------------------------------------------
--                    INICIO FUNCION CUESTIONARIO D2
-----------------------------------------------------------
drop type if exists numero_clientes_aperturaron_cuenta_por_canal_envio cascade;
create type numero_clientes_aperturaron_cuenta_por_canal_envio as (
    anio                                integer,
    clave_formulario                    text,
    clave_entidad                       text,
    tipo_canal                          integer,
    num_clientes_aper                   integer
);

create or replace function cuestionario_d2 (integer,integer)
    returns setof numero_clientes_aperturaron_cuenta_por_canal_envio as $$
    declare
    r           numero_clientes_aperturaron_cuenta_por_canal_envio%rowtype;
    clave_ent   alias for $1;
    perio       alias for $2;
    p_inicial   date;
    p_final     date;
    r_paso      record;
    rec         record;
    r_paso_pro  record;
    y           integer;  
    fecha       varchar;

    begin

    p_inicial   :=( '01/01/'||perio)::date;
    p_final     :=('31/12/'||perio)::date;



    DROP table IF EXISTS copiar;
    CREATE temp table copiar(
        id    integer,
        fila  text);
    y:=0;
    insert into copiar values(y,'anio;clave_formulario;clave_entidad;tipo_canal;num_clientes_aper');
    y:=1;

    DROP table IF EXISTS tmp_activos;
    CREATE temp table tmp_activos(
        idorigen    integer,
        idgrupo     integer,
        idsocio     integer
        );



for rec in
    select * from tablas where lower(idtabla) = 'prod_base_cuestionario_op'
    order by idelemento::integer
  loop

    insert into tmp_activos
      select distinct idorigen,idgrupo,idsocio
      from auxiliares a
      where idproducto = rec.dato1::integer and saldo >= rec.dato2::numeric and a.fechaactivacion between p_inicial  and p_final ;

      
  end loop;





        select into r_paso sum(ts.total) as total_cli
                from(
                select count(*) as total
                from tmp_activos 
                --from auxiliares a
            --   where (a.idproducto = 101 and a.saldo >= 500.0)  and a.fechaactivacion between '01/01/2024' and '31/12/2024'
                 ) 
                as ts;
            

    r.anio                      := trim(to_char(perio,'9999'));
    r.clave_formulario          := 'D2';
    r.clave_entidad             := clave_ent;
    r.tipo_canal                := '1';
    r.num_clientes_aper         := trim(to_char(r_paso.total_cli::numeric,'99999999999999999'));

    return next r;

    insert into copiar values(y,
        coalesce(r.anio                             ::text,'')||';'||
        coalesce(r.clave_formulario                 ::text,'')||';'||
        coalesce(r.clave_entidad                    ::text,'')||';'||
        coalesce(r.tipo_canal                       ::text,'')||';'||
        coalesce(r.num_clientes_aper                ::text,''));

    select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
    execute 'copy (select fila from copiar order by id) to ''/tmp/D2_con_encabezados_'||fecha||'.csv''  ';
    execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/D2_sin_encabezados_'||fecha||'.csv''  ';

    end;
$$ language 'plpgsql';

-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO D2
-----------------------------------------------------------



