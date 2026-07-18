-- 01-init.sql — Datos semilla ERP Odoo (SW-01, SW-03, IF-04)
-- Base de datos: odoo_db
\connect odoo_db

CREATE SCHEMA IF NOT EXISTS public;

-- Tabla: clientes
CREATE TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ruc VARCHAR(13) UNIQUE NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO clientes (nombre, ruc, direccion, telefono, email) VALUES
    ('Seguridad Total Cía. Ltda.', '1792837465001', 'Av. Amazonas N35-100, Quito', '022345678', 'info@seguridadtotal.ec'),
    ('Control de Acceso SA', '1793847562001', 'Calle Elia Liut N52-50, Quito', '023456789', 'admin@controacceso.ec'),
    ('Vigilancia Proactiva Cía.', '1794857364001', 'Av. Boyacá Oe4-12, Quito', '025678901', 'contacto@vigilanciapro.ec'),
    ('Cámaras y Sensores SA', '1795868273001', 'Av. 6 de Diciembre N30-80, Quito', '027890123', 'ventas@camarasysensores.ec'),
    ('Automatización Inteligente', '1796879382001', 'Av. República E7-50, Quito', '028901234', 'soporte@autointeligente.ec'),
    ('Sistemas de Seguridad Integrados', '1797890491001', 'Calle Ramón Chiriboga Oe3-20, Quito', '029012345', 'gerencia@sisintegrados.ec'),
    ('Electrodomésticos del Sur', '0192837465001', 'Av. 9 de Octubre 1120, Guayaquil', '042345678', 'info@electrosur.ec'),
    ('Distribuidora de Tecnología', '0293847562001', 'Calle Panamá 450, Guayaquil', '043456789', 'ventas@distecnologia.ec'),
    ('Comercializadora Global', '0394857461001', 'Av. Quito 220, Cuenca', '072345678', 'admin@comercialglobal.ec'),
    ('Importadora Andina', '0495868372001', 'Calle Sucre 5-78, Ambato', '032345678', 'contacto@importadoraandina.ec');

-- Tabla: productos
CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT DEFAULT 0,
    categoria VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO productos (codigo, nombre, descripcion, precio_compra, precio_venta, stock_actual, categoria) VALUES
    ('CAM-DS2CD2', 'Cámara IP Hikvision DS-2CD2T47G2-L', 'Cámara domo 4MP, visión nocturna, PoE', 85.00, 145.00, 120, 'Cámaras'),
    ('CAM-DS2CD8', 'Cámara IP Hikvision DS-2CD2386G2-I', 'Cámara domo 8MP, colorvu, PoE', 120.00, 210.00, 85, 'Cámaras'),
    ('CAM-TUR4MP', 'Cámara IP Dahua Turret 4MP', 'Cámara bala 4MP, IR, IP67', 65.00, 110.00, 200, 'Cámaras'),
    ('NVR-HIK32', 'NVR Hikvision DS-7632NI', 'Grabador 32 canales, PoE, 4K', 350.00, 590.00, 45, 'Grabadores'),
    ('NVR-DAHUA16', 'NVR Dahua 16 canales', 'Grabador 16 canales, ePoE', 280.00, 470.00, 30, 'Grabadores'),
    ('DVR-HIK8', 'DVR Hikvision 8 canales', 'Grabador 8 canales, HD-TVI', 150.00, 250.00, 60, 'Grabadores'),
    ('HDD-4TB', 'Disco Duro WD Purple 4TB', 'HDD 4TB, vigilancia, 256MB', 95.00, 160.00, 300, 'Accesorios'),
    ('HDD-8TB', 'Disco Duro WD Purple 8TB', 'HDD 8TB, vigilancia, 256MB', 175.00, 290.00, 150, 'Accesorios'),
    ('POE-8P', 'Switch PoE 8 puertos', 'Switch 8 puertos PoE+, 100W', 90.00, 155.00, 100, 'Redes'),
    ('POE-24P', 'Switch PoE 24 puertos', 'Switch 24 puertos PoE+, 250W', 250.00, 420.00, 55, 'Redes'),
    ('FIBRA-1KM', 'Kit Fibra Óptica 1km', 'Cable fibra óptica monomodo 1km + conectores', 180.00, 300.00, 40, 'Redes'),
    ('ALAR-INT', 'Panel de alarma interior', 'Panel alarma inalámbrica, 8 zonas', 45.00, 85.00, 250, 'Alarmas'),
    ('ALAR-EXT', 'Sirena exterior con strobe', 'Sirena electrónica 110dB con luz estroboscópica', 25.00, 50.00, 400, 'Alarmas'),
    ('SENS-MOV', 'Sensor de movimiento', 'Sensor PIR, 12m alcance, 90°', 12.00, 25.00, 500, 'Alarmas'),
    ('CONT-ACC', 'Control de acceso biométrico', 'Lector huella + tarjeta, 1000 usuarios', 120.00, 210.00, 75, 'Control Acceso'),
    ('TARJ-PROX', 'Tarjeta proximidad 125kHz', 'Tarjeta RFID para control acceso', 1.50, 4.50, 2000, 'Control Acceso'),
    ('CERR-ELEC', 'Cerradora eléctrica', 'Cerradora electromagnética 600lbs', 35.00, 68.00, 300, 'Control Acceso'),
    ('UPS-1KVA', 'UPS APC 1000VA', 'UPS 1000VA, 8 tomas, gestión red', 180.00, 310.00, 65, 'Infraestructura'),
    ('UPS-2KVA', 'UPS APC 2000VA', 'UPS 2000VA, rackeable, doble conversión', 350.00, 580.00, 35, 'Infraestructura'),
    ('CABLE-UTP', 'Cable UTP Cat6 305m', 'Cobre sólido 24AWG, LSZH', 85.00, 140.00, 180, 'Redes'),
    ('CABLE-COAX', 'Cable coaxial RG59 100m', 'Cable coaxial con alimentación', 40.00, 70.00, 150, 'Accesorios'),
    ('FUENTE-12V', 'Fuente Poder 12V 10A', 'Fuente switching 12V DC 10A', 18.00, 35.00, 600, 'Accesorios'),
    ('SOPORTE-PAR', 'Soporte pared metálico', 'Soporte acero inoxidable para cámara', 8.00, 18.00, 800, 'Accesorios'),
    ('KIT-TOOLS', 'Kit herramientas instalación', 'Crimpeadora, pelacable, probador, conectores', 35.00, 65.00, 100, 'Accesorios'),
    ('LEC-HUELLA', 'Lector biométrico huella', 'Lector independiente IP65, 5000 usuarios', 95.00, 170.00, 90, 'Control Acceso'),
    ('CAB-VIDEO', 'Cable video balun 100m', 'Cable UTP + balunes video para CCTV', 30.00, 55.00, 250, 'Accesorios'),
    ('ANT-ALARM', 'Antena alarma GSM', 'Antena 4G para panel de alarma', 15.00, 30.00, 350, 'Alarmas'),
    ('JOY-CAM', 'Joystick control cámaras PTZ', 'Joystick para control de cámaras PTZ', 120.00, 220.00, 25, 'Control Acceso'),
    ('MONI-22', 'Monitor 22 pulgadas CCTV', 'Monitor LED 22" HDMI/VGA', 140.00, 240.00, 40, 'Accesorios'),
    ('CAJA-EMPOT', 'Caja empotrar pared', 'Caja metálica para instalación empotrada', 4.00, 10.00, 1000, 'Accesorios');

-- Tabla: facturas (IF-04)
CREATE TABLE IF NOT EXISTS facturas (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    numero VARCHAR(20) UNIQUE NOT NULL,
    fecha_emision DATE NOT NULL DEFAULT CURRENT_DATE,
    subtotal DECIMAL(12,2) NOT NULL,
    iva DECIMAL(12,2) NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'pendiente',
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO facturas (cliente_id, numero, fecha_emision, subtotal, iva, total, estado) VALUES
    (1, 'FAC-2026-0001', '2026-07-01', 4500.00, 540.00, 5040.00, 'pagada'),
    (2, 'FAC-2026-0002', '2026-07-02', 2300.00, 276.00, 2576.00, 'pendiente'),
    (3, 'FAC-2026-0003', '2026-07-03', 1250.00, 150.00, 1400.00, 'vencida'),
    (4, 'FAC-2026-0004', '2026-07-05', 7800.00, 936.00, 8736.00, 'pagada'),
    (5, 'FAC-2026-0005', '2026-07-07', 3200.00, 384.00, 3584.00, 'pendiente'),
    (6, 'FAC-2026-0006', '2026-07-10', 11000.00, 1320.00, 12320.00, 'pagada'),
    (7, 'FAC-2026-0007', '2026-07-12', 670.00, 80.40, 750.40, 'pendiente'),
    (8, 'FAC-2026-0008', '2026-07-14', 5400.00, 648.00, 6048.00, 'pagada'),
    (9, 'FAC-2026-0009', '2026-07-15', 1800.00, 216.00, 2016.00, 'pendiente'),
    (10, 'FAC-2026-0010', '2026-07-16', 9200.00, 1104.00, 10304.00, 'pendiente');

CREATE TABLE IF NOT EXISTS detalle_factura (
    id SERIAL PRIMARY KEY,
    factura_id INT REFERENCES facturas(id),
    producto_id INT REFERENCES productos(id),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total DECIMAL(12,2) NOT NULL
);

INSERT INTO detalle_factura (factura_id, producto_id, cantidad, precio_unitario, total) VALUES
    (1, 1, 20, 145.00, 2900.00),
    (1, 15, 10, 210.00, 2100.00),
    (2, 4, 5, 590.00, 2950.00),
    (2, 7, 10, 160.00, 1600.00);
