

-- ALTERS DEL MODULO DE CONTABILIDAD 28-10-2024
ALTER TABLE tbl_cuentas

ADD COLUMN es_efectivo TINYINT DEFAULT 0 AFTER Pk_id_cuenta_enlace;
-- FIN DE ALTER 28-10-2024
    
-- Alteraciones para asegurar integridad y consistencia con el script principal

-- **1. Añadir claves primarias y auto-incrementos a las tablas referenciadas**

-- Primero, aseguramos que `tbl_recetas` tenga su clave primaria definida
ALTER TABLE `tbl_recetas`
    ADD PRIMARY KEY (`Pk_id_receta`),
    MODIFY `Pk_id_receta` int(11) NOT NULL AUTO_INCREMENT;

-- Luego, definimos la clave primaria en `tbl_cierre_produccion`
ALTER TABLE `tbl_cierre_produccion`
    ADD PRIMARY KEY (`pk_id_cierre`),
    MODIFY `pk_id_cierre` int(11) NOT NULL AUTO_INCREMENT;

-- Definimos la clave primaria en `tbl_conversiones`
ALTER TABLE `tbl_conversiones`
    ADD PRIMARY KEY (`id_conversion`),
    MODIFY `id_conversion` int(11) NOT NULL AUTO_INCREMENT;

-- Definimos la clave primaria en `tbl_mantenimientos`
ALTER TABLE `tbl_mantenimientos`
    ADD PRIMARY KEY (`Pk_id_maquinaria`),
    MODIFY `Pk_id_maquinaria` int(11) NOT NULL AUTO_INCREMENT;

-- Definimos la clave primaria en `tbl_ordenes_produccion`
ALTER TABLE `tbl_ordenes_produccion`
    ADD PRIMARY KEY (`Pk_id_orden`),
    MODIFY `Pk_id_orden` int(11) NOT NULL AUTO_INCREMENT;

-- **2. Añadir claves foráneas y índices en las tablas que referencian a otras**

-- Tabla `tbl_proceso_produccion_encabezado`
ALTER TABLE `tbl_proceso_produccion_encabezado`
    ADD PRIMARY KEY (`Pk_id_proceso`),
    MODIFY `Pk_id_proceso` int(11) NOT NULL AUTO_INCREMENT,
    ADD INDEX `idx_fk_orden` (`Fk_id_orden`),
    ADD INDEX `idx_fk_maquinaria` (`Fk_id_maquinaria`),
    ADD CONSTRAINT `fk_orden_proceso_produccion` FOREIGN KEY (`Fk_id_orden`) REFERENCES `tbl_ordenes_produccion` (`Pk_id_orden`),
    ADD CONSTRAINT `fk_maquinaria_proceso_produccion` FOREIGN KEY (`Fk_id_maquinaria`) REFERENCES `tbl_mantenimientos` (`Pk_id_maquinaria`);

-- Tabla `tbl_lotes_encabezado`
ALTER TABLE `tbl_lotes_encabezado`
    ADD PRIMARY KEY (`Pk_id_lote`),
    MODIFY `Pk_id_lote` int(11) NOT NULL AUTO_INCREMENT,
    ADD INDEX `idx_fk_proceso_lote_encabezado` (`Fk_id_proceso`),
    ADD CONSTRAINT `fk_proceso_lote_encabezado` FOREIGN KEY (`Fk_id_proceso`) REFERENCES `tbl_proceso_produccion_encabezado` (`Pk_id_proceso`);

-- Tabla `tbl_lotes_detalles`
ALTER TABLE `tbl_lotes_detalles`
    ADD PRIMARY KEY (`Pk_id_lotes_detalle`),
    MODIFY `Pk_id_lotes_detalle` int(11) NOT NULL AUTO_INCREMENT,
    ADD INDEX `idx_fk_producto` (`Fk_id_producto`),
    ADD INDEX `idx_fk_lote` (`Fk_id_lote`),
    ADD CONSTRAINT `fk_producto_lotes_detalles` FOREIGN KEY (`Fk_id_producto`) REFERENCES `Tbl_Productos` (`Pk_id_Producto`),
    ADD CONSTRAINT `fk_lote_lotes_detalles` FOREIGN KEY (`Fk_id_lote`) REFERENCES `tbl_lotes_encabezado` (`Pk_id_lote`);

-- Tabla `tbl_ordenes_produccion_detalle`
ALTER TABLE `tbl_ordenes_produccion_detalle`
    ADD PRIMARY KEY (`Pk_id_detalle`),
    MODIFY `Pk_id_detalle` int(11) NOT NULL AUTO_INCREMENT,
    ADD INDEX `idx_fk_orden` (`Fk_id_orden`),
    ADD INDEX `idx_fk_producto` (`Fk_id_producto`),
    ADD CONSTRAINT `fk_orden_detalle_produccion` FOREIGN KEY (`Fk_id_orden`) REFERENCES `tbl_ordenes_produccion` (`Pk_id_orden`),
    ADD CONSTRAINT `fk_producto_detalle_produccion` FOREIGN KEY (`Fk_id_producto`) REFERENCES `Tbl_Productos` (`Pk_id_Producto`);

-- Tabla `tbl_receta_detalle`
ALTER TABLE `tbl_receta_detalle`
    ADD PRIMARY KEY (`Pk_id_detalle`),
    MODIFY `Pk_id_detalle` int(11) NOT NULL AUTO_INCREMENT,
    ADD INDEX `idx_fk_receta` (`Fk_id_receta`),
    ADD INDEX `idx_fk_producto` (`Fk_id_producto`),
    ADD CONSTRAINT `fk_receta_detalle` FOREIGN KEY (`Fk_id_receta`) REFERENCES `tbl_recetas` (`Pk_id_receta`),
    ADD CONSTRAINT `fk_producto_receta_detalle` FOREIGN KEY (`Fk_id_producto`) REFERENCES `Tbl_Productos` (`Pk_id_Producto`);

-- Tabla `tbl_proceso_produccion_detalle`
ALTER TABLE `tbl_proceso_produccion_detalle`
    ADD PRIMARY KEY (`Pk_id_proceso_detalle`),
    MODIFY `Pk_id_proceso_detalle` int(11) NOT NULL AUTO_INCREMENT,
    ADD INDEX `idx_fk_productos` (`Fk_id_productos`),
    ADD INDEX `idx_fk_receta` (`Fk_id_receta`),
    ADD INDEX `idx_fk_empleado` (`Fk_id_empleado`),
    ADD INDEX `idx_fk_proceso` (`Fk_id_proceso`),
    ADD CONSTRAINT `fk_productos_proceso_produccion` FOREIGN KEY (`Fk_id_productos`) REFERENCES `Tbl_Productos` (`Pk_id_Producto`),
    ADD CONSTRAINT `fk_receta_proceso_produccion` FOREIGN KEY (`Fk_id_receta`) REFERENCES `tbl_recetas` (`Pk_id_receta`),
    ADD CONSTRAINT `fk_empleado_proceso_produccion` FOREIGN KEY (`Fk_id_empleado`) REFERENCES `tbl_empleados` (`pk_clave`),
    ADD CONSTRAINT `fk_proceso_produccion` FOREIGN KEY (`Fk_id_proceso`) REFERENCES `tbl_proceso_produccion_encabezado` (`Pk_id_proceso`);

-- **3. Integración de claves foráneas en tablas existentes**

-- Aseguramos que `tbl_recetas` tenga su clave primaria antes de ser referenciada
ALTER TABLE `Tbl_Productos`
    ADD COLUMN `Fk_id_receta` INT(11),
    ADD INDEX `idx_fk_receta_producto` (`Fk_id_receta`),
    ADD CONSTRAINT `fk_receta_producto` FOREIGN KEY (`Fk_id_receta`) REFERENCES `tbl_recetas` (`Pk_id_receta`);    
    
 -- Aprobado por Brandon Boch
 -- Alters de componente de producción
 -- Inicio
 -- 1. Dropeo de columnas
ALTER TABLE tbl_rrhh_produccion 
DROP COLUMN id_empleado,
DROP COLUMN id_contrato,
DROP COLUMN dias,
DROP COLUMN total_dias,
DROP COLUMN horas,
DROP COLUMN total_horas,
DROP COLUMN id_hora_extra,
DROP COLUMN total_horas_extras,
DROP COLUMN total_mano_obra,
DROP COLUMN estado;

-- 2. Se agregan las columnas
ALTER TABLE tbl_rrhh_produccion 
ADD COLUMN id_empleado INT NOT NULL,
ADD COLUMN salario DECIMAL(10, 2) NOT NULL,
ADD COLUMN dias INT NOT NULL,
ADD COLUMN total_dias DECIMAL(10, 2) NOT NULL,
ADD COLUMN horas INT NOT NULL,
ADD COLUMN total_horas DECIMAL(10, 2) NOT NULL,
ADD COLUMN horas_extras INT NOT NULL,
ADD COLUMN total_horas_extras DECIMAL(10, 2) NOT NULL,
ADD COLUMN total_mano_obra DECIMAL(10, 2) NOT NULL,
ADD COLUMN estado TINYINT(1) NOT NULL;

-- 3. Se dropea la columna id_RRHH
ALTER TABLE tbl_rrhh_produccion
DROP COLUMN id_RRHH;

-- 4. Se agrega el pk correcto
ALTER TABLE tbl_rrhh_produccion
ADD COLUMN pk_id_RRHH INT AUTO_INCREMENT PRIMARY KEY;
 -- Fin
-- ALTERS DEL MODULO DE LOGISTICA 31-10-2024
ALTER TABLE Tbl_TrasladoProductos
MODIFY costoTotal INT NOT NULL;
ALTER TABLE Tbl_TrasladoProductos
MODIFY costoTotalGeneral INT NOT NULL;
ALTER TABLE Tbl_TrasladoProductos
MODIFY precioTotal INT NOT NULL;

ALTER TABLE Tbl_TrasladoProductos
ADD COLUMN codigoProducto INT NOT NULL;

ALTER TABLE Tbl_chofer
ADD COLUMN estado TINYINT NOT NULL DEFAULT 1;


ALTER TABLE Tbl_Productos
ADD COLUMN comisionInventario DOUBLE NOT NULL DEFAULT 0;
ALTER TABLE Tbl_Productos
ADD COLUMN comisionCosto DOUBLE NOT NULL DEFAULT 0;
ALTER TABLE Tbl_Marca
ADD COLUMN comision DOUBLE NOT NULL;
ALTER TABLE Tbl_Linea
ADD COLUMN comision DOUBLE NOT NULL;
ALTER TABLE Tbl_Productos
ADD COLUMN estado TINYINT NOT NULL DEFAULT 1;

ALTER TABLE Tbl_Productos
ADD COLUMN fk_id_marca INT,
ADD COLUMN fk_id_linea INT;

-- Luego agregar las constraints de clave foránea
ALTER TABLE Tbl_Productos
ADD CONSTRAINT fk_producto_marca 
FOREIGN KEY (fk_id_marca) REFERENCES Tbl_Marca(Pk_id_Marca);

ALTER TABLE Tbl_Productos
ADD CONSTRAINT fk_producto_linea 
FOREIGN KEY (fk_id_linea) REFERENCES Tbl_Linea(Pk_id_linea);

-- ALTERS DEL MODULO DE CUENTAS CORRIENTES 31-10-2024

/*ALTER TABLE Tbl_caja_cliente
DROP COLUMN caja_deuda_monto,
DROP COLUMN caja_mora_monto,
DROP COLUMN caja_transaccion_monto;
ALTER TABLE Tbl_caja_cliente
ADD COLUMN Fk_id_factura INT NOT NULL;*/

-- caja General
-- Eliminar tablas antiguas
DROP TABLE IF EXISTS Tbl_caja_cliente;
DROP TABLE IF EXISTS Tbl_caja_proveedor;

CREATE TABLE Tbl_caja_general (
    Pk_id_caja INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Fk_id_cliente INT NULL,
    Fk_id_proveedor INT NULL,
    Fk_id_deuda INT NOT NULL,
    deuda_monto DECIMAL(10, 2) NOT NULL,
    mora_monto DECIMAL(10, 2) NOT NULL,
    transaccion_monto DECIMAL(10, 2) NOT NULL,
    saldo_restante DECIMAL(10, 2) NOT NULL DEFAULT 0,
    estado TINYINT NOT NULL DEFAULT 1, -- 0 = cancelado, 1 = pendiente
    fecha_registro DATE,
    FOREIGN KEY (Fk_id_cliente) REFERENCES Tbl_clientes (Pk_id_cliente),
    FOREIGN KEY (Fk_id_proveedor) REFERENCES Tbl_proveedores (Pk_prov_id),
    FOREIGN KEY (Fk_id_deuda) REFERENCES Tbl_Deudas_Clientes (Pk_id_deuda) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE Tbl_caja_general
   
    DROP COLUMN mora_monto,
    DROP COLUMN deuda_monto,
    DROP COLUMN transaccion_monto,
   
    ADD COLUMN Fk_id_deuda_proveedor INT NULL,

    ADD CONSTRAINT FK_Tbl_caja_general_deuda_prov
        FOREIGN KEY (Fk_id_deuda_proveedor)
        REFERENCES Tbl_deudas_proveedores (Pk_id_deuda);

-- Datos factura Cuentas Corrientes


CREATE TABLE IF NOT EXISTS tbl_encabezado_compras (
    id_compra INT NOT NULL AUTO_INCREMENT,
    numero_factura VARCHAR(50) NOT NULL,
    No_serial_factura VARCHAR(50) NOT NULL,
    id_proveedor INT NOT NULL,
    fecha_compra DATE NOT NULL,
    PRIMARY KEY (id_compra, numero_factura, No_serial_factura),
    FOREIGN KEY (id_proveedor) REFERENCES Tbl_proveedores(Pk_prov_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS Tbl_Factura_Proveedor (
    Pk_id_FacturaProv INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Fk_id_compra INT NOT NULL,
    Fk_numero_factura VARCHAR(50) NOT NULL,
    Fk_No_serial_factura VARCHAR(50) NOT NULL,
    Fk_prov_id INT,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    Total_a_pagar DECIMAL(10,2) NOT NULL,
    saldo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Fk_prov_id) REFERENCES Tbl_proveedores(Pk_prov_id),
    FOREIGN KEY (Fk_id_compra, Fk_numero_factura, Fk_No_serial_factura)
        REFERENCES tbl_encabezado_compras(id_compra, numero_factura, No_serial_factura)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS Tbl_Factura_Cliente (
    Pk_id_FacturaCli INT AUTO_INCREMENT PRIMARY KEY,
    Fk_id_venta INT NOT NULL,
    Fk_No_serie INT NOT NULL,
    Fk_No_de_facV INT(11) NULL,
    id_clienteFact INT(11) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    Total_a_pagar DECIMAL(10,2) NOT NULL,
    saldo DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_clienteFact) REFERENCES Tbl_clientes(Pk_id_cliente),
    FOREIGN KEY (Fk_No_de_facV) REFERENCES Tbl_factura(Pk_id_factura)		
    -- FOREIGN KEY (Fk_id_venta, Fk_No_serie) REFERENCES tbl_ventas_encabezado(Pk_id_venta, Pk_No_SerieEnc)
    -- no tiene No. de serie encabezado ventas
    -- numero_de_facturaVenta`, se puede relacionar AGREGAR; Pendiente
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- NUEVOS ALTER DEL MODULO DE PRODUCCIÓN 03-11-2024 aprobado por Brandon Boch
-- 2. Alter para añadir la foránea a la tabla de mantenimiento
ALTER TABLE `tbl_mantenimientos`
ADD COLUMN `fk_id_maquina` int(11) NOT NULL;

ALTER TABLE `tbl_mantenimientos`
ADD CONSTRAINT `fk_maquina`
FOREIGN KEY (`fk_id_maquina`) REFERENCES `tbl_maquinaria`(`pk_id_maquina`);

-- NUEVOS ALTERS DEL MODULO DE CUENTAS CORRIENTES DEL 03/11/2024 
-- inica modulo de cuentas corrientes
ALTER TABLE Tbl_cobrador
CHANGE COLUMN cobrador_estado estado TINYINT DEFAULT 0 NOT NULL;

-- TBL_paises

ALTER TABLE Tbl_paises
CHANGE COLUMN pais_estado estado TINYINT DEFAULT 1 NOT NULL;

-- TBL_Formadepago

ALTER TABLE Tbl_Formadepago
CHANGE COLUMN pado_estado estado TINYINT DEFAULT 1 NOT NULL;

-- TBL_Deudas_Clientes
-- ALTER TABLE Tbl_Deudas_Clientes
-- ADD COLUMN transaccion_tipo VARCHAR(150) NOT NULL;

-- ALTER TABLE Tbl_Deudas_Clientes
-- ADD COLUMN Efecto_trans VARCHAR(150) NOT NULL;
ALTER TABLE Tbl_Deudas_Clientes
ADD COLUMN deuda_mora VARCHAR(150) NOT NULL;

ALTER TABLE Tbl_Deudas_Clientes
ADD COLUMN Fk_id_factura INT NOT NULL,
ADD CONSTRAINT fk_id_factura FOREIGN KEY (Fk_id_factura) REFERENCES Tbl_factura(Pk_id_factura);

ALTER TABLE Tbl_Deudas_Clientes 
DROP FOREIGN KEY tbl_deudas_clientes_ibfk_3;
ALTER TABLE Tbl_Deudas_Clientes 
DROP COLUMN Fk_id_pago;

-- TBL_Transaccion_clientes
ALTER TABLE Tbl_Transaccion_cliente
-- ADD COLUMN Fk_id_factura INT NOT NULL,
-- ADD CONSTRAINT fk_factura_trans_cliente FOREIGN KEY (Fk_id_factura) REFERENCES Tbl_factura(Pk_id_factura),
ADD COLUMN Fk_id_transC INT NOT NULL,
ADD CONSTRAINT fk_transC_trans_cliente FOREIGN KEY (Fk_id_transC) REFERENCES Tbl_transaccion_cuentas(Pk_id_tran_cue);

-- Eliminar llaves foráneas 
ALTER TABLE Tbl_Transaccion_cliente 
DROP FOREIGN KEY tbl_transaccion_cliente_ibfk_3, 
DROP FOREIGN KEY tbl_transaccion_cliente_ibfk_2;

-- Eliminar columnas innecesarias
ALTER TABLE Tbl_Transaccion_cliente
DROP COLUMN transaccion_cuotas, 
DROP COLUMN tansaccion_cuenta,
DROP COLUMN Fk_id_pais,
DROP COLUMN Fk_id_pago,
DROP COLUMN transaccionserie;

-- TBL_mora_clientes
ALTER TABLE Tbl_mora_clientes MODIFY COLUMN morafecha VARCHAR(15) NOT NULL;

-- TBL_caja_clientes

/*ALTER TABLE Tbl_caja_cliente MODIFY COLUMN caja_fecha_registro VARCHAR(15) NOT NULL;
ALTER TABLE Tbl_caja_cliente ADD COLUMN Fk_id_factura INT NOT NULL;
ALTER TABLE Tbl_caja_cliente ADD CONSTRAINT id_factura FOREIGN KEY (Fk_id_factura) REFERENCES Tbl_factura(Pk_id_factura); 

ALTER TABLE Tbl_caja_cliente
DROP COLUMN caja_deuda_monto, 
DROP COLUMN caja_mora_monto, 
DROP COLUMN caja_transaccion_monto; */



-- TBL_Deuda_Proveedores
ALTER TABLE Tbl_Deudas_Proveedores MODIFY COLUMN deuda_fecha_inicio VARCHAR(150) NOT NULL;
ALTER TABLE Tbl_Deudas_Proveedores MODIFY COLUMN deuda_fecha_vencimiento VARCHAR(150) NOT NULL;
ALTER TABLE Tbl_Deudas_Proveedores
ADD COLUMN transaccion_tipo VARCHAR(150) NOT NULL;

ALTER TABLE Tbl_Deudas_Proveedores
ADD COLUMN Efecto_trans VARCHAR(150) NOT NULL;

ALTER TABLE Tbl_Deudas_Proveedores
ADD COLUMN Fk_id_factura INT NOT NULL,
ADD CONSTRAINT fk_id_factura2 FOREIGN KEY (Fk_id_factura) REFERENCES Tbl_factura(Pk_id_factura);

ALTER TABLE Tbl_Deudas_Proveedores 
DROP FOREIGN KEY tbl_deudas_proveedores_ibfk_2;
ALTER TABLE Tbl_Deudas_Proveedores
DROP COLUMN Fk_id_pago;

-- ----------------------------------------------------------

ALTER TABLE Tbl_Deudas_Proveedores
  MODIFY COLUMN Fk_id_factura INT NULL;
  
  ALTER TABLE Tbl_Deudas_Proveedores
  DROP FOREIGN KEY fk_id_factura2;
  
  
  ALTER TABLE Tbl_Deudas_Proveedores
  ADD CONSTRAINT fk_id_factura2
    FOREIGN KEY (Fk_id_factura)
    REFERENCES Tbl_factura_proveedor (Pk_id_FacturaProv)
    ON UPDATE CASCADE
    ON DELETE SET NULL;

-- TBL_Transaccion_proveedor
ALTER TABLE Tbl_Transaccion_proveedor
ADD COLUMN Fk_id_transC INT NOT NULL,
ADD CONSTRAINT fk_transC_trans_proveedor FOREIGN KEY (Fk_id_transC) REFERENCES Tbl_transaccion_cuentas(Pk_id_tran_cue);

-- Eliminar llaves foráneas 
ALTER TABLE Tbl_Transaccion_proveedor 
DROP FOREIGN KEY tbl_transaccion_proveedor_ibfk_3, 
DROP FOREIGN KEY tbl_transaccion_proveedor_ibfk_2;

-- Eliminar columnas innecesarias
ALTER TABLE Tbl_Transaccion_proveedor
DROP COLUMN tansaccion_cuotas, 
DROP COLUMN tansaccion_cuenta,
DROP COLUMN Fk_id_pais,
DROP COLUMN Fk_id_pago,
DROP COLUMN transaccion_serie;

-- TBL_caja_proveedor

/*ALTER TABLE Tbl_caja_proveedor MODIFY COLUMN caja_fecha_registro VARCHAR(150) NOT NULL;
ALTER TABLE Tbl_caja_proveedor
ADD COLUMN Fk_id_factura INT NOT NULL,
ADD CONSTRAINT fk_factura_caja FOREIGN KEY (Fk_id_factura) REFERENCES Tbl_factura(Pk_id_factura);

ALTER TABLE Tbl_caja_proveedor
DROP COLUMN caja_deuda_monto, 
DROP COLUMN caja_transaccion_monto; */


-- ALTER MODULO LOGISTICA 04/11/2024
ALTER TABLE tbl_productos ADD CONSTRAINT UQ_codigoProducto UNIQUE
(codigoProducto);

-- Alter del modulo de nominas 4/11/2024
ALTER TABLE tbl_dedu_perp_emp
ADD COLUMN dedu_perp_emp_mes VARCHAR(25) NOT NULL AFTER dedu_perp_emp_cantidad;

ALTER TABLE tbl_horas_extra
MODIFY COLUMN horas_cantidad_horas INT;


-- ALTER MODULO DE LOGISTICA 05/11/2024
ALTER TABLE Tbl_Productos
ADD COLUMN precio_venta DECIMAL(10, 2) AFTER precioUnitario,
ADD COLUMN costo_compra DECIMAL(10, 2) AFTER precio_venta;
ALTER TABLE TBL_LOCALES
MODIFY FECHA_REGISTRO DATE NOT NULL;

-- ALTER MODULO COMERCIAL 06/11/2024

CREATE TABLE Tbl_clasificacionLista (
    pk_id_clasificacion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_clasificacion VARCHAR(50) NOT NULL,  
    descripcion_clasificacion VARCHAR(100),                   
    estado TINYINT NOT NULL DEFAULT 1           
);

  
ALTER TABLE tbl_lista_encabezado
  ADD COLUMN Fk_id_clasificacion INT AFTER Pk_id_lista_Encabezado;
  
ALTER TABLE tbl_lista_encabezado
  ADD CONSTRAINT fk_clasificacion
  FOREIGN KEY (Fk_id_clasificacion) REFERENCES Tbl_clasificacionLista(Pk_id_clasificacion);


ALTER TABLE tbl_lista_encabezado
  CHANGE COLUMN ListEncabezado_fecha ListEncabezado_fecha DATE;


ALTER TABLE tbl_lista_encabezado
  CHANGE COLUMN ListEncabezado_estado estado TINYINT(1) DEFAULT 1;
  

ALTER TABLE tbl_lista_encabezado
  DROP COLUMN ListEncabezado_nombre;

 ALTER TABLE tbl_cotizacion_detalle
DROP FOREIGN KEY tbl_cotizacion_detalle_ibfk_2;
 
 SHOW CREATE TABLE tbl_cotizacion_detalle;

  
ALTER TABLE Tbl_lista_detalle
DROP COLUMN Pk_id_lista_detalle;



ALTER TABLE Tbl_lista_detalle
  CHANGE COLUMN ListDetalle_preVenta ListDetalle_precio DECIMAL(10,2) NULL;


ALTER TABLE Tbl_lista_detalle
  ADD PRIMARY KEY (Fk_id_lista_Encabezado, Fk_id_Producto);  


ALTER TABLE Tbl_lista_detalle
  ADD CONSTRAINT fk_lista_encabezado FOREIGN KEY (Fk_id_lista_Encabezado) REFERENCES Tbl_lista_encabezado(Pk_id_lista_Encabezado),
  ADD CONSTRAINT fk_producto FOREIGN KEY (Fk_id_Producto) REFERENCES Tbl_Productos(Pk_id_Producto);


ALTER TABLE Tbl_lista_detalle
  DROP COLUMN ListDetalle_descuento,
  DROP COLUMN ListDetalle_impuesto;


DROP TABLE IF EXISTS Tbl_detalle_comisiones;
DROP TABLE IF EXISTS Tbl_comisiones_encabezado;
DROP TABLE IF EXISTS Tbl_pedido_detalle;
DROP TABLE IF EXISTS Tbl_pedido_encabezado;
DROP TABLE IF EXISTS Tbl_cotizacion_detalle;
DROP TABLE IF EXISTS Tbl_cotizacion_encabezado;
DROP TABLE IF EXISTS Tbl_vendedores;
DROP TABLE IF EXISTS Tbl_detalle_ordenes_compra;
DROP TABLE IF EXISTS Tbl_ordenes_compra;

CREATE TABLE IF NOT EXISTS Tbl_vendedores (
    Pk_id_vendedor int (11) NOT NULL,
    vendedores_nombre VARCHAR(100)NOT NULL ,
    vendedores_apellido VARCHAR(100)NOT NULL ,
    vendedores_sueldo DECIMAL(10,2)NOT NULL ,
    vendedores_direccion VARCHAR(255)NOT NULL ,
    vendedores_telefono VARCHAR(20)NOT NULL ,
	Fk_id_empleado INT,
    estado tinyint(1) DEFAULT 1,
    PRIMARY KEY (Pk_id_vendedor)
);
ALTER TABLE Tbl_clientes 
CHANGE Clientes_estado estado TINYINT(1) DEFAULT 1;

 ALTER TABLE Tbl_clientes 
ADD COLUMN Cliente_email VARCHAR(20) NOT NULL;
 
 ALTER TABLE Tbl_clientes 
ADD COLUMN Cliente_Tipo VARCHAR(20) NOT NULL;

ALTER TABLE Tbl_clientes
ADD COLUMN Cliente_lim_credito DECIMAL(10, 2) DEFAULT 0.00;

ALTER TABLE Tbl_clientes
ADD COLUMN Cliente_dias_credito int (5) NOT NULL ;

ALTER TABLE Tbl_clientes 
ADD COLUMN Fecha_Registro DATE NOT NULL;


ALTER TABLE Tbl_clientes
ADD COLUMN Clientes_deuda DECIMAL(10, 2) DEFAULT 0.00;

ALTER TABLE Tbl_clientes
DROP COLUMN Clientes_deuda;

ALTER TABLE Tbl_clientes 
ADD Fk_id_vendedor INT NOT NULL,
ADD CONSTRAINT FK_vendedor_cliente
FOREIGN KEY (Fk_id_vendedor) REFERENCES Tbl_vendedores(Pk_id_vendedor); 

ALTER TABLE Tbl_clientes 
DROP FOREIGN KEY FK_vendedor_cliente;
ALTER TABLE Tbl_clientes
DROP COLUMN Fk_id_vendedor;

ALTER TABLE Tbl_clientes 
ADD COLUMN Fk_id_lista_Encabezado INT NOT NULL;

ALTER TABLE Tbl_clientes 
ADD CONSTRAINT FK_id_lista_Encabezado
FOREIGN KEY (Fk_id_lista_Encabezado) REFERENCES Tbl_lista_encabezado(Pk_id_lista_Encabezado);

ALTER TABLE Tbl_clientes 
DROP FOREIGN KEY Fk_id_lista_Encabezado;
ALTER TABLE Tbl_clientes
DROP COLUMN FK_id_lista_Encabezado;

ALTER TABLE Tbl_proveedores
ADD COLUMN Proveedor_deuda DECIMAL(10, 2) DEFAULT 0.00;

ALTER TABLE Tbl_proveedores 
CHANGE Prov_estado estado TINYINT(1) DEFAULT 1;


CREATE TABLE IF NOT EXISTS Tbl_cotizacion_encabezado (
    Pk_id_cotizacionEnc VARCHAR(20) NOT NULL UNIQUE,
    Fk_id_vendedor INT,
    Fk_id_cliente INT,
    CotizacionEnc_fechaVenc DATE,
    CotizacionEnc_total DECIMAL(10,2),
    FOREIGN KEY (Fk_id_vendedor) REFERENCES Tbl_vendedores(Pk_id_vendedor),
    FOREIGN KEY (Fk_id_cliente) REFERENCES Tbl_clientes(Pk_id_cliente),
    PRIMARY KEY (Pk_id_cotizacionEnc)
);

CREATE TABLE IF NOT EXISTS Tbl_cotizacion_detalle (
    Fk_id_cotizacionEnc VARCHAR(20) NOT NULL,  
    Fk_id_producto INT,        
    CotizacionDet_cantidad INT,
    CotizacionDet_precio DECIMAL(10,2),
    CotizacionDet_subtotal decimal(10,2),
    FOREIGN KEY (Fk_id_cotizacionEnc) REFERENCES Tbl_cotizacion_encabezado(Pk_id_cotizacionEnc),
    FOREIGN KEY (Fk_id_producto) REFERENCES Tbl_Productos(Pk_id_Producto)
);

CREATE TABLE IF NOT EXISTS Tbl_pedido_encabezado (
    Pk_id_pedidoEnc VARCHAR(20) NOT NULL UNIQUE,
    Fk_id_cliente INT  NOT NULL,
    Fk_id_vendedor INT  NOT NULL,
    PedidoEncfecha DATE  NOT NULL,
    PedidoEnc_total DECIMAL(10,2),
    FOREIGN KEY (Fk_id_cliente) REFERENCES Tbl_clientes(Pk_id_cliente),
    FOREIGN KEY (Fk_id_vendedor) REFERENCES Tbl_vendedores(Pk_id_vendedor),
    PRIMARY KEY (Pk_id_PedidoEnc)
);


CREATE TABLE IF NOT EXISTS Tbl_pedido_detalle (
    Fk_id_pedidoEnc VARCHAR(20) NOT NULL,
    Fk_id_producto INT,
    Fk_id_cotizacionEnc VARCHAR(20) NOT NULL,
    PedidoDet_cantidad int,
    PedidoEnc_precio decimal(10,2),
    PedidoEnc_total DECIMAL(10,2),
    FOREIGN KEY (Fk_id_pedidoEnc) REFERENCES Tbl_pedido_encabezado(Pk_id_pedidoEnc),
    FOREIGN KEY (Fk_id_producto) REFERENCES Tbl_Productos(Pk_id_Producto),
    FOREIGN KEY (Fk_id_cotizacionEnc) REFERENCES Tbl_cotizacion_encabezado(Pk_id_cotizacionEnc),
    PRIMARY KEY (Fk_id_pedidoEnc, Fk_id_producto,Fk_id_cotizacionEnc)
);

SET foreign_key_checks = 0;
ALTER TABLE Tbl_pedido_encabezado 
    MODIFY Pk_id_PedidoEnc VARCHAR(20) NOT NULL UNIQUE;
SET foreign_key_checks = 1;


SET foreign_key_checks = 0;
ALTER TABLE Tbl_pedido_detalle 
    MODIFY Fk_id_pedidoEnc VARCHAR(20) NOT NULL,
    MODIFY Fk_id_cotizacionEnc VARCHAR(20),
    DROP PRIMARY KEY,
    ADD PRIMARY KEY (Fk_id_pedidoEnc, Fk_id_producto, Fk_id_cotizacionEnc);




DROP TABLE IF EXISTS Tbl_factura_detalle;
DROP TABLE IF EXISTS Tbl_factura_encabezado;

CREATE TABLE IF NOT EXISTS Tbl_factura_encabezado (
    Pk_id_facturaEnc VARCHAR(20) NOT NULL UNIQUE,
    Fk_id_vendedor INT,
    Fk_id_cliente INT,
    Fk_id_PeidoEnc INT,
    CotizacionEnc_fechaCrea DATE,
    CotizacionEnc_fechaVenc DATE,
    factura_formPago ENUM('al contado', 'al crédito') NOT NULL,
    factura_subtotal DECIMAL(10,2)  NOT NULL,
    factura_iva DECIMAL(4, 2) NOT NULL DEFAULT 0.12,
	facturaEnc_total DECIMAL(10,2),
    FOREIGN KEY (Fk_id_vendedor) REFERENCES Tbl_vendedores(Pk_id_vendedor),
    FOREIGN KEY (Fk_id_cliente) REFERENCES Tbl_clientes(Pk_id_cliente),
    PRIMARY KEY (Pk_id_facturaEnc)
);

-- Tabla factura Detalle
CREATE TABLE IF NOT EXISTS Tbl_factura_detalle (
    fk_id_facturaEnc VARCHAR(20) NOT NULL,  
    Fk_id_producto INT,        
    facturaDet_cantidad INT,
    facturaDet_precio DECIMAL(10,2),
    facturaDet_subtotal decimal(10,2),
    FOREIGN KEY (fk_id_facturaEnc) REFERENCES Tbl_factura_encabezado(Pk_id_facturaEnc),
    FOREIGN KEY (Fk_id_producto) REFERENCES Tbl_Productos(Pk_id_Producto)
);


CREATE TABLE IF NOT EXISTS Tbl_comisiones_encabezado (
    Pk_id_comisionEnc INT(11) NOT NULL,
    Fk_id_vendedor INT NOT NULL,
    Comisiones_fecha_ DATE NOT NULL,
    Comisiones_total_venta DECIMAL(10,2) NOT NULL,
    Comisiones_total_comision DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Fk_id_vendedor) REFERENCES Tbl_vendedores(Pk_id_vendedor),
    PRIMARY KEY (Pk_id_comisionEnc)
);

CREATE TABLE IF NOT EXISTS Tbl_detalle_comisiones (
    Pk_id_detalle_comision INT(11) NOT NULL,
    Fk_id_comisionEnc INT NOT NULL,
    Fk_id_facturaEnc VARCHAR(20) NOT NULL,
    Comisiones_porcentaje DECIMAL(5,2) NOT NULL,
    Comisiones_monto_venta DECIMAL(10,2) NOT NULL,
    Comisiones_monto_comision DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Fk_id_comisionEnc) REFERENCES Tbl_comisiones_encabezado(Pk_id_comisionEnc),
    FOREIGN KEY (Fk_id_facturaEnc) REFERENCES Tbl_factura_encabezado(Pk_id_facturaEnc),
    PRIMARY KEY (Pk_id_detalle_comision)
);

CREATE TABLE IF NOT EXISTS Tbl_EncabezadoOrdenCompra(
    PK_encOrCom_numeroOC VARCHAR(20) NOT NULL UNIQUE,
    Fk_prov_id INT,
	EncOrCom_fechaEntrega DATE,
	total DECIMAL(10, 2),
    FOREIGN KEY (Fk_prov_id) REFERENCES Tbl_proveedores(Pk_prov_id),
    PRIMARY KEY (PK_encOrCom_numeroOC)
);
CREATE TABLE IF NOT EXISTS Tbl_DetalleOrdenesCompra (
    FK_encOrCom_numeroOC VARCHAR(20) NOT NULL,
    FK_codigoProducto INT,
    DetOrCom_precioU DECIMAL(10,2),
    DetOrCom_cantidad INT NOT NULL,
    DetOrCom_total DECIMAL(10,2),
    FOREIGN KEY (FK_encOrCom_numeroOC) REFERENCES Tbl_EncabezadoOrdenCompra(PK_encOrCom_numeroOC),
    FOREIGN KEY (FK_codigoProducto) REFERENCES Tbl_Productos(codigoProducto),
    PRIMARY KEY ( FK_encOrCom_numeroOC, FK_codigoProducto)
);



-- CREACION DE TABLAS DEL MODULO DE PRODUCCION  06/11/2024
CREATE TABLE IF NOT EXISTS tbl_implosion ( 
    pk_id_implosion INT(11) NOT NULL AUTO_INCREMENT,
    fk_id_orden INT(11) DEFAULT NULL, -- Relacionado con la orden de producción
    fk_id_producto_final INT(11) DEFAULT NULL, -- Producto final que se construye
    id_componente VARCHAR(50) DEFAULT NULL, -- Componente utilizado en la consolidación, ahora como string
    cantidad_componente INT(11) DEFAULT NULL, -- Cantidad de cada componente
    costo_componente INT(11) DEFAULT NULL, -- Costo de cada componente
    duracion_horas INT(11) DEFAULT NULL, -- Duración en horas para consolidar el componente
    fk_id_proceso INT(11) DEFAULT NULL, -- Relación con el proceso de producción
    fecha_implosion DATETIME DEFAULT NULL, -- Fecha de la implosión
    PRIMARY KEY (pk_id_implosion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS tbl_explosion (
pk_id_explosion INT(11) NOT NULL AUTO_INCREMENT,
fk_id_orden INT(11) DEFAULT NULL, -- Relacionado con la orden de producción
fk_id_producto INT(11) DEFAULT NULL, -- Producto que se descompone
cantidad INT(11) DEFAULT NULL, -- Cantidad de producto a descomponer
costo_total DECIMAL(10,2) DEFAULT NULL, -- Costo total de la descomposición
duracion_horas INT(11) DEFAULT NULL, -- Duración en horas
fk_id_proceso INT(11) DEFAULT NULL, -- Relación con el proceso
fecha_explosion DATE DEFAULT NULL, -- Fecha de la explosión
PRIMARY KEY (pk_id_explosion),
FOREIGN KEY (fk_id_producto) REFERENCES tbl_productos(pk_id_producto),
FOREIGN KEY (fk_id_proceso) REFERENCES tbl_proceso_produccion_encabezado(pk_id_proceso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- CUENTAS CORRIENTES 07/11/2024

DROP TABLE Tbl_paises;
Drop table Tbl_Formadepago;

-- PRODUCCION 08/11/024
ALTER TABLE tbl_recetas
ADD COLUMN `dias` INT(11) NULL,
ADD COLUMN `horas` DECIMAL(10,2) NULL;

-- COMERCIAL 10/11/2024
CREATE TABLE IF NOT EXISTS Tbl_ComprasRealizadas (
    PK_noCompra VARCHAR(20) NOT NULL UNIQUE, 
    Fk_prov_id INT,                             
    CR_FechaCompra DATETIME,                       
    CR_TotalCompra DECIMAL(18,2),                 
    CR_CodigoProducto INT,                         
    CR_PrecioU DECIMAL(18,2),                    
    CR_Cantidad INT,                               
    CR_TotalDetalle DECIMAL(18,2),  
     PRIMARY KEY (PK_noCompra),
    FOREIGN KEY (Fk_prov_id) REFERENCES Tbl_proveedores(Pk_prov_id)
);

-- LOGISTICA 29/04/2025

CREATE TABLE Tbl_movimiento_de_inventario (
	Pk_id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    Fk_id_producto INT NOT NULL,
    stock INT NOT NULL,
    Fk_id_traslado INT,
    Fk_ID_BODEGA INT NOT NULL,
    Cantidad_almacen INT NOT NULL,
    Fk_id_compra INT,
	tipo_movimiento varchar (30) NOT NULL,
    FOREIGN KEY (Fk_id_producto) REFERENCES Tbl_Productos(Pk_id_Producto),
    CONSTRAINT FK_EXISTENCIA_LOCAL FOREIGN KEY (Fk_ID_BODEGA) REFERENCES TBL_BODEGAS(Pk_ID_BODEGA)
);

-- ALTERs Parla la tabla Tbl_TrasladoProductos
ALTER TABLE Tbl_TrasladoProductos
ADD COLUMN bodega_origen VARCHAR(100),
ADD COLUMN bodega_destino VARCHAR(100);

-- Para que no se creen duplicidad de productos
ALTER TABLE TBL_EXISTENCIAS_BODEGA
ADD CONSTRAINT unique_bodega_producto UNIQUE (Fk_ID_BODEGA, Fk_ID_PRODUCTO);

CREATE TABLE Tbl_EntradaProductos (
    Pk_id_EntradaProductos INT PRIMARY KEY AUTO_INCREMENT,
    documento VARCHAR(50),
    fecha DATE,
    costoTotal DECIMAL(10,2),
    costoTotalGeneral DECIMAL(10,2),
    precioTotal DECIMAL(10,2),
    codigoProducto INT,
    Fk_id_guia INT,
    bodega_origen VARCHAR(100),
    bodega_destino VARCHAR(100)
);
ALTER TABLE Tbl_EntradaProductos
ADD COLUMN estado VARCHAR(20) NOT NULL DEFAULT 'activo';


CREATE TABLE Tbl_DetalleTrasladoProductos (
    Pk_id_DetalleTrasladoProductos INT AUTO_INCREMENT PRIMARY KEY,
    Fk_id_TrasladoProductos INT,
    codigoProducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2),
    costoTotal DECIMAL(10,2),
    FOREIGN KEY (Fk_id_TrasladoProductos) REFERENCES Tbl_TrasladoProductos(Pk_id_TrasladoProductos),
    FOREIGN KEY (codigoProducto) REFERENCES Tbl_Productos(codigoProducto)
);

CREATE TABLE Tbl_DetalleEntradaProductos (
    Pk_id_DetalleEntrada INT PRIMARY KEY AUTO_INCREMENT,
    Fk_id_EntradaProductos INT,
    codigoProducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2),
    costoTotal DECIMAL(10,2)
);

-- Se agrego el campo FK_ID_LOCAL a la tabla tbl_bodegas para realizar el insert ala tabla tbl_movimiento_de_inventario
ALTER TABLE tbl_bodegas
ADD COLUMN Fk_ID_LOCAL INT(11) NOT NULL;


-- NUEVAS TABLAS DEL MODULO COMERCIAL
-- Tabla de Ventas Encabezado
CREATE TABLE IF NOT EXISTS `tbl_ventas_encabezado` (
  `Pk_id_venta` INT(11) NOT NULL AUTO_INCREMENT,
  `Fk_id_cliente` INT(11) NOT NULL,
  `Fk_id_vendedor` INT(11) NOT NULL,
  `Fk_id_factura` INT(11) NULL,
  `venta_fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `venta_subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `venta_descuento` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `venta_iva` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `venta_total` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `venta_estado` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=Pendiente, 2=Finalizada, 3=Anulada',
  `venta_forma_pago` VARCHAR(50) NOT NULL COMMENT 'Efectivo, Tarjeta, Transferencia',
  `venta_observaciones` TEXT NULL,
  PRIMARY KEY (`Pk_id_venta`),
  FOREIGN KEY (`Fk_id_cliente`) REFERENCES `Tbl_clientes`(`Pk_id_cliente`),
  FOREIGN KEY (`Fk_id_vendedor`) REFERENCES `Tbl_vendedores`(`Pk_id_vendedor`),
  FOREIGN KEY (`Fk_id_factura`) REFERENCES `Tbl_factura`(`Pk_id_factura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de Ventas Detalle
CREATE TABLE IF NOT EXISTS `tbl_ventas_detalle` (
  `Pk_id_venta_detalle` INT(11) NOT NULL AUTO_INCREMENT,
  `Fk_id_venta` INT(11) NOT NULL,
  `Fk_id_producto` INT(11) NOT NULL,
  `detalle_cantidad` INT(11) NOT NULL,
  `detalle_precio_unitario` DECIMAL(12,2) NOT NULL,
  `detalle_descuento` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `detalle_subtotal` DECIMAL(12,2) NOT NULL,
  `detalle_iva` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `detalle_total` DECIMAL(12,2) NOT NULL,
  `detalle_estado` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=Activo, 0=Anulado',
  PRIMARY KEY (`Pk_id_venta_detalle`),
  FOREIGN KEY (`Fk_id_venta`) REFERENCES `tbl_ventas_encabezado`(`Pk_id_venta`),
  FOREIGN KEY (`Fk_id_producto`) REFERENCES `Tbl_Productos`(`Pk_id_Producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de Pagos de Ventas
CREATE TABLE IF NOT EXISTS `tbl_ventas_pagos` (
  `Pk_id_pago` INT(11) NOT NULL AUTO_INCREMENT,
  `Fk_id_venta` INT(11) NOT NULL,
  `Fk_id_cuenta_bancaria` INT(11) NULL,
  `pago_monto` DECIMAL(12,2) NOT NULL,
  `pago_fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pago_forma` VARCHAR(50) NOT NULL COMMENT 'Efectivo, Tarjeta, Transferencia, Cheque',
  `pago_referencia` VARCHAR(100) NULL,
  `pago_estado` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=Activo, 0=Anulado',
  PRIMARY KEY (`Pk_id_pago`),
  FOREIGN KEY (`Fk_id_venta`) REFERENCES `tbl_ventas_encabezado`(`Pk_id_venta`),
  FOREIGN KEY (`Fk_id_cuenta_bancaria`) REFERENCES `tbl_cuentabancaria`(`pk_cuenta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- TERMINA LAS TABLAS CREADAS

-- Deudas clientes
-- 1.1 Eliminar la FK existente hacia tbl_factura
ALTER TABLE tbl_factura_cliente
DROP FOREIGN KEY tbl_factura_cliente_ibfk_2;

-- 1.2 Convertir los campos a columnas normales
ALTER TABLE tbl_factura_cliente
MODIFY COLUMN Fk_id_venta INT(11) NOT NULL,
MODIFY COLUMN Fk_No_serie INT(11) NOT NULL,
MODIFY COLUMN Fk_No_de_facV INT(11) DEFAULT NULL;

-- ===============================================
-- 2) tbl_deudas_clientes: Redireccionar Fk_id_factura a tbl_factura_cliente
-- ===============================================

-- 2.1 Eliminar FK incorrecta a tbl_factura
ALTER TABLE tbl_deudas_clientes
DROP FOREIGN KEY fk_id_factura;

-- 2.2 Crear nueva FK a tbl_factura_cliente
ALTER TABLE tbl_deudas_clientes
ADD CONSTRAINT fk_deudascli_facturacli
  FOREIGN KEY (Fk_id_factura)
  REFERENCES tbl_factura_cliente(Pk_id_FacturaCli);

-- ===============================================
-- 3) tbl_deudas_clientes: Redireccionar Fk_id_pago a tbl_transaccion_cuentas
-- ===============================================
-- NOTA: Aunque la columna Fk_id_pago aún no existe en esta estructura, deberás crearla primero si deseas agregarla.
-- Aquí tienes el código completo con la columna incluida (si no existe aún):

ALTER TABLE tbl_deudas_clientes
ADD COLUMN Fk_id_pago VARCHAR(150) NOT NULL;

ALTER TABLE tbl_deudas_clientes
DROP COLUMN deuda_mora;
ALTER TABLE tbl_clientes
MODIFY COLUMN Cliente_email VARCHAR(50);

ALTER TABLE tbl_factura_cliente
MODIFY COLUMN Fk_No_serie VARCHAR(20);

SELECT *FROM tbl_deudas_proveedores;


-- -----------------------------------------------------
-- Table `educativo`.`Alumnos`
-- -----------------------------------------------------
CREATE TABLE alumnos
 (
  carnet_alumno VARCHAR(15),
  nombre_alumno VARCHAR(45),
  direccion_alumno VARCHAR(45),
  telefono_alumno VARCHAR(45),
  email_alumno VARCHAR(20),
  estatus_alumno VARCHAR(1),
  PRIMARY KEY (carnet_alumno)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Table `educativo`.`Maestros`
-- -----------------------------------------------------
CREATE TABLE maestros
(
  codigo_maestro VARCHAR(5),
  nombre_maestro VARCHAR(45),
  direccion_maestro VARCHAR(45),
  telefono_maetro VARCHAR(45),
  email_maestro VARCHAR(20),
  estatus_maestro VARCHAR(1),
  PRIMARY KEY (codigo_maestro)
 ) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Facultades`
-- -----------------------------------------------------
CREATE TABLE facultades
(
  codigo_facultad VARCHAR(5),
  nombre_facultad VARCHAR(45),
  estatus_facultad VARCHAR(1),
  PRIMARY KEY (codigo_facultad)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Carreras`
-- -----------------------------------------------------
CREATE TABLE carreras
(
  codigo_carrera VARCHAR(5),
  nombre_carrera VARCHAR(45),
  codigo_facultad VARCHAR(5),
  estatus_carrera VARCHAR(1),
  PRIMARY KEY (codigo_carrera),
  FOREIGN KEY (codigo_facultad) REFERENCES facultades(codigo_facultad)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Cursos`
-- -----------------------------------------------------
CREATE TABLE cursos
(
  codigo_curso VARCHAR(5),
  nombre_curso VARCHAR(45),
  estatus_curso VARCHAR(1),
  PRIMARY KEY (codigo_curso)
 ) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Secciones`
-- -----------------------------------------------------
CREATE TABLE secciones
(
  codigo_seccion VARCHAR(5),
  nombre_seccion VARCHAR(45),
  estatus_seccion VARCHAR(1),
  PRIMARY KEY (codigo_seccion)
 ) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Sedes`
-- -----------------------------------------------------
CREATE TABLE sedes
(
  codigo_sede VARCHAR(5),
  nombre_sede VARCHAR(45),
  estatus_sede VARCHAR(1),
  PRIMARY KEY (codigo_sede)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Aulas`
-- -----------------------------------------------------
CREATE TABLE aulas
(
  codigo_aula VARCHAR(5),
  nombre_aula VARCHAR(45),
  estatus_aula VARCHAR(1),
  PRIMARY KEY (codigo_aula)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE jornadas
(
	codigo_jornada VARCHAR(5),
    nombre_jornada VARCHAR(45),
    estatus_jornada VARCHAR(1),
    PRIMARY KEY (codigo_jornada)
) ENGINE=INNODB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Asignacion_cursos_alumnos`
-- -----------------------------------------------------
CREATE TABLE asignacioncursosalumnos
(
  codigo_carrera VARCHAR(5),
  codigo_sede VARCHAR(5),
  codigo_jornada VARCHAR(5),
  codigo_seccion VARCHAR(5),
  codigo_aula VARCHAR(5),
  codigo_curso VARCHAR(5),
  carnet_alumno VARCHAR(15),
  nota_asignacioncursoalumnos FLOAT(10,2), 
  PRIMARY KEY (codigo_carrera, codigo_sede, codigo_jornada, codigo_seccion, codigo_aula, codigo_curso, carnet_alumno),
  FOREIGN KEY (codigo_carrera) REFERENCES carreras(codigo_carrera),
  FOREIGN KEY (codigo_sede) REFERENCES sedes(codigo_sede),
  FOREIGN KEY (codigo_jornada) REFERENCES jornadas(codigo_jornada),
  FOREIGN KEY (codigo_seccion) REFERENCES secciones(codigo_seccion),
  FOREIGN KEY (codigo_aula) REFERENCES aulas(codigo_aula),
  FOREIGN KEY (codigo_curso) REFERENCES cursos(codigo_curso),
  FOREIGN KEY (carnet_alumno) REFERENCES alumnos(carnet_alumno)
  ) ENGINE = InnoDB DEFAULT CHARSET=latin1;
-- -----------------------------------------------------
-- Table `educativo`.`Asignacion_cursos_maestros`
-- -----------------------------------------------------
CREATE TABLE asignacioncursosmastros
(
  codigo_carrera VARCHAR(5),
  codigo_sede VARCHAR(5),
  codigo_jornada VARCHAR(5),
  codigo_seccion VARCHAR(5),
  codigo_aula VARCHAR(5),
  codigo_curso VARCHAR(5),
  codigo_maestro VARCHAR(5),
  PRIMARY KEY (codigo_carrera, codigo_sede, codigo_jornada, codigo_seccion, codigo_aula, codigo_curso),
  FOREIGN KEY (codigo_carrera) REFERENCES carreras(codigo_carrera),
  FOREIGN KEY (codigo_sede) REFERENCES sedes(codigo_sede),
  FOREIGN KEY (codigo_jornada) REFERENCES jornadas(codigo_jornada),
  FOREIGN KEY (codigo_seccion) REFERENCES secciones(codigo_seccion),
  FOREIGN KEY (codigo_aula) REFERENCES aulas(codigo_aula),
  FOREIGN KEY (codigo_curso) REFERENCES cursos(codigo_curso),
  FOREIGN KEY (codigo_maestro) REFERENCES maestros(codigo_maestro)
  ) ENGINE = InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE aulas
ADD COLUMN `estado` tinyint(4) DEFAULT 0;
ALTER TABLE aulas
DROP COLUMN estatus_aula;