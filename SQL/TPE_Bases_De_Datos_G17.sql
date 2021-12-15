--TPE Bases de datos I - Grupo 17
drop table if exists Direccion;
drop table if exists Barrio;
drop table if exists Equipo;
drop table if exists LineaComprobante;
drop table if exists Servicio;
drop table if exists Categoria;
drop table if exists Ciudad;
drop table if exists Comprobante;
drop table if exists Cliente;
drop table if exists Mail;
drop table if exists Turno;
drop table if exists Personal;
drop table if exists Telefono;
drop table if exists Persona;
drop table if exists Rol;
drop table if exists TipoComprobante;

-- tables
-- Table: Barrio
CREATE TABLE Barrio
(
    id_barrio int         NOT NULL,
    nombre    varchar(20) NOT NULL,
    id_ciudad int         NOT NULL,
    CONSTRAINT Barrio_pk PRIMARY KEY (id_barrio)
);

-- Table: Categoria
CREATE TABLE Categoria
(
    id_cat int         NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT Categoria_pk PRIMARY KEY (id_cat)
);

-- Table: Ciudad
CREATE TABLE Ciudad
(
    id_ciudad int         NOT NULL,
    nombre    varchar(80) NOT NULL,
    CONSTRAINT Ciudad_pk PRIMARY KEY (id_ciudad)
);

-- Table: Cliente
CREATE TABLE Cliente
(
    id_cliente int            NOT NULL,
    saldo      numeric(18, 3) NULL,
    CONSTRAINT Cliente_pk PRIMARY KEY (id_cliente)
);

-- Table: Comprobante
CREATE TABLE Comprobante
(
    id_comp           bigint         NOT NULL,
    id_tcomp          int            NOT NULL,
    fecha             timestamp      NULL,
    comentario        varchar(2048)  NOT NULL,
    estado            varchar(20)    NULL,
    fecha_vencimiento timestamp      NULL,
    id_turno          int            NULL,
    importe           numeric(18, 5) NOT NULL,
    id_cliente        int            NOT NULL,
    CONSTRAINT pk_comprobante PRIMARY KEY (id_comp, id_tcomp)
);

-- Table: Direccion
CREATE TABLE Direccion
(
    id_direccion int         NOT NULL,
    id_persona   int         NOT NULL,
    calle        varchar(50) NOT NULL,
    numero       int         NOT NULL,
    piso         int         NULL,
    depto        varchar(50) NULL,
    id_barrio    int         NOT NULL,
    CONSTRAINT Direccion_pk PRIMARY KEY (id_direccion, id_persona)
);

-- Table: Equipo
CREATE TABLE Equipo
(
    id_equipo       int         NOT NULL,
    nombre          varchar(80) NOT NULL,
    MAC             varchar(20) NULL,
    IP              varchar(20) NULL,
    AP              varchar(20) NULL,
    id_servicio     int         NOT NULL,
    id_cliente      int         NOT NULL,
    fecha_alta      timestamp   NOT NULL,
    fecha_baja      timestamp   NULL,
    tipo_conexion   varchar(20) NOT NULL,
    tipo_asignacion varchar(20) NOT NULL,
    CONSTRAINT Equipo_pk PRIMARY KEY (id_equipo)
);

-- Table: LineaComprobante
CREATE TABLE LineaComprobante
(
    nro_linea   int            NOT NULL,
    id_comp     bigint         NOT NULL,
    id_tcomp    int            NOT NULL,
    descripcion varchar(80)    NOT NULL,
    cantidad    int            NOT NULL,
    importe     numeric(18, 5) NOT NULL,
    id_servicio int            NULL,
    CONSTRAINT pk_lineacomp PRIMARY KEY (nro_linea, id_comp, id_tcomp)
);

-- Table: Mail
CREATE TABLE Mail
(
    id_persona int          NOT NULL,
    mail       varchar(120) NOT NULL,
    tipo       varchar(20)  NOT NULL,
    CONSTRAINT Mail_pk PRIMARY KEY (id_persona, mail)
);

-- Table: Persona
CREATE TABLE Persona
(
    id_persona       int         NOT NULL,
    tipo             varchar(10) NOT NULL,
    tipodoc          varchar(10) NOT NULL,
    nrodoc           varchar(10) NOT NULL,
    nombre           varchar(40) NOT NULL,
    apellido         varchar(40) NOT NULL,
    fecha_nacimiento timestamp   NOT NULL,
    fecha_baja       timestamp   NULL,
    CUIT             varchar(20) NULL,
    activo           boolean     NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (id_persona)
);

-- Table: Personal
CREATE TABLE Personal
(
    id_personal int NOT NULL,
    id_rol      int NOT NULL,
    CONSTRAINT Personal_pk PRIMARY KEY (id_personal)
);

-- Table: Rol
CREATE TABLE Rol
(
    id_rol int         NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT Rol_pk PRIMARY KEY (id_rol)
);

-- Table: Servicio
CREATE TABLE Servicio
(
    id_servicio    int            NOT NULL,
    nombre         varchar(80)    NOT NULL,
    periodico      boolean        NOT NULL,
    costo          numeric(18, 3) NOT NULL,
    intervalo      int            NULL,
    tipo_intervalo varchar(20)    NULL,
    activo         boolean        NOT NULL DEFAULT true,
    id_cat         int            NOT NULL,
    CONSTRAINT CHECK_0 CHECK ((tipo_intervalo in ('semana', 'quincena', 'mes', 'bimestre'))) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT pk_servicio PRIMARY KEY (id_servicio)
);

-- Table: Telefono
CREATE TABLE Telefono
(
    id_persona int NOT NULL,
    carac      int NOT NULL,
    numero     int NOT NULL,
    CONSTRAINT Telefono_pk PRIMARY KEY (id_persona, carac, numero)
);

-- Table: TipoComprobante
CREATE TABLE TipoComprobante
(
    id_tcomp int         NOT NULL,
    nombre   varchar(30) NOT NULL,
    tipo     varchar(80) NOT NULL,
    CONSTRAINT pk_tipo_comprobante PRIMARY KEY (id_tcomp)
);

-- Table: Turno
CREATE TABLE Turno
(
    id_turno      int            NOT NULL,
    desde         timestamp      NOT NULL,
    hasta         timestamp      NULL,
    dinero_inicio numeric(18, 3) NOT NULL,
    dinero_fin    numeric(18, 3) NULL,
    id_personal   int            NOT NULL,
    CONSTRAINT Turno_pk PRIMARY KEY (id_turno)
);

-- foreign keys
-- Reference: LineaComprobante_Servicio (table: LineaComprobante)
ALTER TABLE LineaComprobante
    ADD CONSTRAINT LineaComprobante_Servicio
        FOREIGN KEY (id_servicio)
            REFERENCES Servicio (id_servicio)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_barrio_ciudad (table: Barrio)
ALTER TABLE Barrio
    ADD CONSTRAINT fk_barrio_ciudad
        FOREIGN KEY (id_ciudad)
            REFERENCES Ciudad (id_ciudad)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_cliente_persona (table: Cliente)
ALTER TABLE Cliente
    ADD CONSTRAINT fk_cliente_persona
        FOREIGN KEY (id_cliente)
            REFERENCES Persona (id_persona)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_comprobante_cliente (table: Comprobante)
ALTER TABLE Comprobante
    ADD CONSTRAINT fk_comprobante_cliente
        FOREIGN KEY (id_cliente)
            REFERENCES Cliente (id_cliente)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_comprobante_tipocomprobante (table: Comprobante)
ALTER TABLE Comprobante
    ADD CONSTRAINT fk_comprobante_tipocomprobante
        FOREIGN KEY (id_tcomp)
            REFERENCES TipoComprobante (id_tcomp)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_comprobante_turno (table: Comprobante)
ALTER TABLE Comprobante
    ADD CONSTRAINT fk_comprobante_turno
        FOREIGN KEY (id_turno)
            REFERENCES Turno (id_turno)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_direccion (table: Direccion)
ALTER TABLE Direccion
    ADD CONSTRAINT fk_direccion
        FOREIGN KEY (id_persona)
            REFERENCES Persona (id_persona)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_direccion_barrio (table: Direccion)
ALTER TABLE Direccion
    ADD CONSTRAINT fk_direccion_barrio
        FOREIGN KEY (id_barrio)
            REFERENCES Barrio (id_barrio)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_equipo_cliente (table: Equipo)
ALTER TABLE Equipo
    ADD CONSTRAINT fk_equipo_cliente
        FOREIGN KEY (id_cliente)
            REFERENCES Cliente (id_cliente)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_equipo_servicio (table: Equipo)
ALTER TABLE Equipo
    ADD CONSTRAINT fk_equipo_servicio
        FOREIGN KEY (id_servicio)
            REFERENCES Servicio (id_servicio)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_lineacomprobante_comprobante (table: LineaComprobante)
ALTER TABLE LineaComprobante
    ADD CONSTRAINT fk_lineacomprobante_comprobante
        FOREIGN KEY (id_comp, id_tcomp)
            REFERENCES Comprobante (id_comp, id_tcomp)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_mail_persona (table: Mail)
ALTER TABLE Mail
    ADD CONSTRAINT fk_mail_persona
        FOREIGN KEY (id_persona)
            REFERENCES Persona (id_persona)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_personal_persona (table: Personal)
ALTER TABLE Personal
    ADD CONSTRAINT fk_personal_persona
        FOREIGN KEY (id_personal)
            REFERENCES Persona (id_persona)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_personal_rol (table: Personal)
ALTER TABLE Personal
    ADD CONSTRAINT fk_personal_rol
        FOREIGN KEY (id_rol)
            REFERENCES Rol (id_rol)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_personal_turno (table: Turno)
ALTER TABLE Turno
    ADD CONSTRAINT fk_personal_turno
        FOREIGN KEY (id_personal)
            REFERENCES Personal (id_personal)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_servicio_categoria (table: Servicio)
ALTER TABLE Servicio
    ADD CONSTRAINT fk_servicio_categoria
        FOREIGN KEY (id_cat)
            REFERENCES Categoria (id_cat)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: fk_telefono (table: Telefono)
ALTER TABLE Telefono
    ADD CONSTRAINT fk_telefono
        FOREIGN KEY (id_persona)
            REFERENCES Persona (id_persona)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;
-- Cargado de datos


-- Seccion CONSULTAS
-- Consulta 1 -> Funcionando
select c.id_cliente,
       p.nombre           "Nombre",
       p.apellido         "Apellido",
       p.tipodoc          "Tipo Documento",
       p.nrodoc           "Numero Doc",
       p.fecha_nacimiento "Fecha Nacimiento",
       count(e.id_equipo) "Cantidad de equipos"
from cliente c
         join persona p on c.id_cliente = p.id_persona
         join equipo e on c.id_cliente = e.id_cliente
group by c.id_cliente, p.nombre, p.apellido, p.tipodoc, p.nrodoc, p.fecha_nacimiento
order by p.apellido, p.nombre;
-- Consulta 2 -> Funcionando (Revisar JOINS)
select c2.nombre, c2.id_ciudad, B.nombre, count(id_equipo)
from equipo e
         join direccion d on e.id_cliente = d.id_persona
         join Barrio B on d.id_barrio = B.id_barrio
         join ciudad c2 on B.id_ciudad = c2.id_ciudad
where e.fecha_baja IS NULL
  AND age(e.fecha_alta) < '24 months'
group by c2.nombre, c2.id_ciudad, b.id_barrio
order by count(id_equipo) DESC;
-- Consulta 3 ->
Select b.nombre, count(e.id_servicio)
from barrio b
         join Direccion D on b.id_barrio = D.id_barrio
         join Equipo E on d.id_persona = e.id_cliente
where age(e.fecha_alta) < '3 years'
  and e.id_servicio in (select id_servicio from servicio where periodico = true)
group by b.id_barrio
order by count(e.id_servicio) DESC
limit 3;

-- Consulta 4 ->

SELECT p.nombre, p.apellido, p.tipodoc, p.nrodoc
from Persona p
         join equipo e on p.id_persona = e.id_cliente
         join servicio s on e.id_servicio = s.id_servicio
where s.periodico = true
  and (s.intervalo > 5 and s.intervalo < 10)
group by p.nombre, p.apellido, p.tipodoc, p.nrodoc, e.id_servicio
having count(e.id_servicio) =
       (select count(*) from servicio where periodico = true and (intervalo > 5 and intervalo < 10));

-- SECCION  ELABORACIÓN DE RESTRICCIONES Y REGLAS DEL NEGOCIO
-- A Es un check de tupla debido a que se checkean dos mismos campos de la tupla que o debe ser activo o la diferencia entre fecha y fecha nacimiento debe ser mayor a 18
ALTER TABLE Persona
    add constraint baja_persona_2a
        CHECK ( activo = true or (DATE_PART('year', fecha_baja) - DATE_PART('year', fecha_nacimiento) > 18) );
-- B Es un check general debido a que debemos comparar tanto la tabla de comprobante como la de nro_linea
--CREATE ASSERTION importeComprobante_2b
--CHECK(NOT EXISTS(SELECT 1 from Comprobante c where c.importe <> (SELECT Sum(l.importe*l.cantidad) from LineaComprobante l where l.id_comp = c.id_comp and l.id_tcomp = c.id_tcomp))

-- C
ALTER TABLE Equipo
    add constraint mac_requerida_2c
        CHECK ( ip IS null or mac iS NOT null );
-- D CHECK DE TABLA
ALTER TABLE Equipo
    add constraint ip_asignada_2d
        CHECK ( not exists(SELECT 1
                           from equipo a
                           where ip is not null
                             and ip in (Select ip
                                        from equipo b
                                        where a.id_cliente != b.id_cliente)
                           limit 1
            ));

-- SOLUCION CON TRIGGER
CREATE OR REPLACE FUNCTION checkeo_ip_distinta() RETURNS TRIGGER AS
$$
BEGIN
    if exists(SELECT 1
              from equipo
              where ip is not null
                and ip = new.ip
                and id_cliente <> new.id_cliente) then
        raise exception 'Hay un cliente con esa ip distinto del ingresado';
    end if;
    RETURN NEW;
END
$$ language 'plpgsql';


CREATE trigger ip_asignada_2d
    before insert or update
    on equipo
    for each row
    when ( new.ip is not null )
execute function checkeo_ip_distinta();

-- E
CREATE
ASSERTION importeComprobante_2b
CHECK
(NOT EXISTS (SELECT 1
    from Barrio b join direccion d on b.id_barrio = d.id_barrio
    join equipo e on d.id_persona = e.id_cliente
    group by b.id_barrio
    having count(id_equipo) > 25))

-- Solucion con triggers
CREATE OR REPLACE FUNCTION checkeo_cantidad_equipos_barrio_direccion() RETURNS TRIGGER AS
$$
DECLARE
    cant integer;
BEGIN
    Select count(id_equipo)
    into cant
    from barrio b
             join direccion d on b.id_barrio = d.id_barrio
             join equipo e on d.id_persona = e.id_cliente
    where b.id_barrio = (select id_barrio from Direccion where id_persona = 3)
    group by b.id_barrio;
    if (cant > 10) then
        RAISE EXCEPTION 'Se alcanzó la cantidad maxima de equipos instalados para ese barrio';
    end if;
    RETURN NEW;
END
$$ language 'plpgsql';

CREATE trigger equiposPorBarrio_direccion
    after insert or update
    on Direccion
    for each row
execute function checkeo_cantidad_equipos_barrio_direccion();

CREATE OR REPLACE FUNCTION checkeo_cantidad_equipos_barrio() RETURNS TRIGGER AS
$$
DECLARE
    cant integer;
BEGIN
    Select count(id_equipo)
    into cant
    from barrio b
             join direccion d on b.id_barrio = d.id_barrio
             join equipo e on d.id_persona = e.id_cliente
    where b.id_barrio = (select id_barrio from Direccion where id_persona = new.id_cliente)
    group by b.id_barrio;
    if (cant > 4) then
        RAISE EXCEPTION 'Se alcanzó la cantidad maxima de equipos instalados para ese barrio';
    end if;
    RETURN NEW;
END
$$ language 'plpgsql';

CREATE trigger equiposPorBarrio_equipo
    after insert or update
    on equipo
    for each row
execute function checkeo_cantidad_equipos_barrio();


-- VISTAS

-- Vista 1

CREATE OR REPLACE VIEW clientesCiudad AS
SELECT saldo
from cliente
where id_cliente in (select id_persona
                     from direccion
                     where id_barrio in (select id_barrio
                                         from barrio
                                         where id_ciudad in (SELECT id_ciudad from ciudad where nombre = 'Tandil')));

/*
    Es una view automaticamente actualizable debido a que no tiene subconsultas en el SELECT no trae información de otras tablas en el from o con joins
    ni utiliza funciones como distinct o de agregación limit,etc...
*/

update clientesciudad
set saldo= 5000
where saldo = 300;
/*
Esta operacion solo sería posible con WCO si todas las personas que tienen el saldo 300
su id_cliente figura en la subconsulta hecha en el where, por ejemplo, si una de las personas con saldo 300es el id 3 que tiene residencia en bolivar
entonces no se updatearia debido a que no figura en la consulta que se buscan los id_clientes que tengan residencia en tandil o ciudad x

*/

-- Vista 2
CREATE OR REPLACE VIEW servicioActivosClientes AS
SELECT id_cliente, s.id_servicio, s.costo
from equipo
         join servicio s on Equipo.id_servicio = s.id_servicio
where s.activo = true
group by id_cliente, s.id_servicio, s.costo;


CREATE OR REPLACE FUNCTION fn_actualizar_vista()
    RETURNS TRIGGER AS
$$
BEGIN

    update equipo
    set id_servicio=new.id_servicio,
        id_cliente=new.id_cliente
    where id_cliente = old.id_cliente
      and id_servicio = old.id_servicio;
    update Servicio set costo=new.costo, id_servicio=new.id_servicio where id_servicio = old.id_servicio;
    return new;


end;
$$ language 'plpgsql';

CREATE TRIGGER actualizarVistaServiciosActivos
    INSTEAD OF UPDATE
    ON servicioActivosClientes
    FOR EACH ROW
execute procedure fn_actualizar_vista();


/*
    No es automaticamente actualizable en POSTGRESQL porque utiliza funciones de agregación como el group by y ademas utiliza un join entre tablas.
*/


-- Vista 3
CREATE OR REPLACE VIEW montoFacturadoServicio AS
SELECt s.id_servicio,
       date_trunc('year', fecha)   as "year",
       date_trunc('month', fecha)  as "month",
       SUM(l.importe * l.cantidad) as monto
from lineacomprobante l
         join comprobante c on l.id_comp = c.id_comp
         join Servicio S on l.id_servicio = S.id_servicio
where s.periodico = true
  and age(c.fecha) < '5 years'
group by s.id_servicio, year, month
order by s.id_servicio, year, month, monto;



-- Servicios
--a


create or replace procedure crearFacturas()
as
$$
declare
    clientes          record;
    servicio          record;
    importeTotal      numeric(18, 3);
    ultimoComprobante integer;
    lineaComp         integer;
    importeAux        integer;
begin
    if exists(select 1 from comprobante where id_tcomp = 1) then
        select max(id_comp) into ultimoComprobante from comprobante where id_tcomp = 1 group by id_comp;
        ultimoComprobante := ultimoComprobante + 1;
    else
        ultimoComprobante = 1;
    end if;
    for clientes in (select id_cliente
                     from equipo
                              join servicio s on Equipo.id_servicio = s.id_servicio
                     where s.periodico = true
                     group by id_cliente) -- por cada cliente que tiene servicio periodico
        loop
            importeTotal := 0;
            insert into comprobante(id_comp, id_tcomp, fecha, comentario, estado, fecha_vencimiento, id_turno, importe,
                                    id_cliente)
            values (ultimoComprobante, 1, current_date, '', '', current_date + interval '1 month', NULL, 0,
                    clientes.id_cliente); -- se inserta vacio porque necesitamos la fk para insertar en linea comprobante
            lineaComp := 1;
            importeAux := 0;
            for servicio in (select e.id_servicio, s.costo, count(id_equipo) as Cantidad
                             from equipo e
                                      join servicio s on e.id_servicio = s.id_servicio
                             where id_cliente = clientes.id_cliente
                               and s.periodico = true
                             group by e.id_servicio, s.costo)
                loop
                    importeAux := servicio.Cantidad * servicio.costo;
                    insert into lineacomprobante(nro_linea, id_comp, id_tcomp, descripcion, cantidad, importe,
                                                 id_servicio)
                    values (lineaComp, ultimoComprobante, 1, '', servicio.Cantidad, servicio.costo,
                            servicio.id_servicio);
                    lineaComp := lineaComp + 1;
                end loop;
            importeTotal := importeTotal + importeAux;
            update comprobante c
            set importe=importeTotal
            where id_comp = ultimoComprobante
              and id_tcomp = 1; -- se actualiza al final porque no se recorrio los servicios uno por uno
            ultimoComprobante := ultimoComprobante + 1;
        end loop;
end;
$$
    language 'plpgsql';

call crearFacturas();



/*
 Proveer el mecanismo que crea más adecuado para que al ser invocado (una vez por mes), tome todos los servicios que son periódicos y genere la/s
 factura/s correspondiente/s. Indicar si se deben proveer parámetros adicionales para su generación. Explicar además cómo resolvería el tema de la
 invocación mensual (pero no lo implemente).

 */


-- Servicio 2

CREATE OR REPLACE VIEW inventarioEquipos AS
select nombre, tipo_asignacion, tipo_conexion, count(id_equipo)
from equipo
where fecha_baja is null
group by nombre, tipo_asignacion, tipo_conexion;


-- Servicio 3 se utiliza un procedure que devuelve una tabla debido a que necesitamos implementar los dos parametros de fecha

drop function generarReporteEmpleado(fecha_1 date, fecha_2 date);
create or replace function generarReporteEmpleado(fecha_1 date, fecha_2 date)
    returns table
            (
                "Nombre Empleado"  varchar,
                "Localidad" varchar,
                Cantidad           Bigint,
                "Tiempo Promedio"  interval,
                "Tiempo máximo"    interval

            )
as
$$
begin
    return query
        select p.nombre               as Empleado,
               c2.nombre              as Localidad,
               count(t.id_turno)      as Cantidad,
               avg(t.hasta - t.desde) as "Tiempo promedio",
               max(t.hasta - t.desde) as "Tiempo maximo"
        from Persona p
                 join turno t on (p.id_persona = t.id_personal)
                 join comprobante c on (t.id_turno = c.id_turno)
                 join direccion d on (c.id_cliente = d.id_persona)
                 join barrio b on (d.id_barrio = b.id_barrio)
                 join ciudad c2 on (b.id_ciudad = c2.id_ciudad)
        where t.desde >= fecha_1
          and t.hasta is not null
          and t.hasta <= fecha_2
        group by p.id_persona, c2.id_ciudad;
end;
$$
    language 'plpgsql';


select *
from generarReporteEmpleado(TO_DATE('2020-04-08', 'YYYY-MM-DD'), TO_DATE('2021-11-08', 'YYYY-MM-DD'));
-- End of file.


create or replace function informe_empleados(fecha1 date, fecha2 date)
    returns table
            (
                empleado    varchar,
                localidad   varchar,
                cant_turnos Bigint,
                T_Promedio  interval,
                T_Maximo    interval
            )
as
$$
begin
    return query
        select p.nombre               as empleado,
               c2.nombre              as localidad,
               count(t.id_turno)      as cant_turnos,
               avg(t.hasta - t.desde) as T_Promedio,
               max(t.hasta - t.desde) as T_Maximo
        from Persona p
                 join turno t on (p.id_persona = t.id_personal)
                 join comprobante c on (t.id_turno = c.id_turno)
                 join direccion d on (c.id_cliente = d.id_persona)
                 join barrio b on (d.id_barrio = b.id_barrio)
                 join ciudad c2 on (b.id_ciudad = c2.id_ciudad)
        where t.desde >= fecha1
          and t.hasta is not null
          and t.hasta <= fecha2
        group by p.id_persona, c2.id_ciudad;
end;
$$
    language 'plpgsql';


select *
from informe_empleados(TO_DATE('2019-11-08', 'YYYY-MM-DD'), TO_DATE('2021-11-08', 'YYYY-MM-DD'));
