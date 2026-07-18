-- 01-init.sql — Datos semilla inventario stock (IF-09)
-- Base de datos: inventario_stock

CREATE TABLE IF NOT EXISTS stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    categoria VARCHAR(50),
    cantidad INT NOT NULL DEFAULT 0,
    precio_unitario DECIMAL(10,2) NOT NULL,
    ubicacion VARCHAR(100),
    proveedor VARCHAR(100),
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO stock (codigo, nombre, categoria, cantidad, precio_unitario, ubicacion, proveedor) VALUES
    ('CAM-DS2CD2', 'Cámara IP Hikvision DS-2CD2T47G2-L', 'Cámaras', 120, 85.00, 'Bodega A-E1', 'Hikvision Ecuador SA'),
    ('CAM-DS2CD8', 'Cámara IP Hikvision DS-2CD2386G2-I', 'Cámaras', 85, 120.00, 'Bodega A-E2', 'Hikvision Ecuador SA'),
    ('CAM-TUR4MP', 'Cámara IP Dahua Turret 4MP', 'Cámaras', 200, 65.00, 'Bodega A-E3', 'Dahua Technology Ecuador'),
    ('NVR-HIK32', 'NVR Hikvision DS-7632NI', 'Grabadores', 45, 350.00, 'Bodega B-E1', 'Hikvision Ecuador SA'),
    ('NVR-DAHUA16', 'NVR Dahua 16 canales', 'Grabadores', 30, 280.00, 'Bodega B-E2', 'Dahua Technology Ecuador'),
    ('DVR-HIK8', 'DVR Hikvision 8 canales', 'Grabadores', 60, 150.00, 'Bodega B-E3', 'Hikvision Ecuador SA'),
    ('HDD-4TB', 'Disco Duro WD Purple 4TB', 'Accesorios', 300, 95.00, 'Bodega C-E1', 'Western Digital Ecuador'),
    ('HDD-8TB', 'Disco Duro WD Purple 8TB', 'Accesorios', 150, 175.00, 'Bodega C-E2', 'Western Digital Ecuador'),
    ('POE-8P', 'Switch PoE 8 puertos', 'Redes', 100, 90.00, 'Bodega D-E1', 'TP-Link Ecuador'),
    ('POE-24P', 'Switch PoE 24 puertos', 'Redes', 55, 250.00, 'Bodega D-E2', 'TP-Link Ecuador'),
    ('FIBRA-1KM', 'Kit Fibra Óptica 1km', 'Redes', 40, 180.00, 'Bodega D-E3', 'Fibraóptica SA'),
    ('ALAR-INT', 'Panel de alarma interior', 'Alarmas', 250, 45.00, 'Bodega E-E1', 'Paradox Ecuador'),
    ('ALAR-EXT', 'Sirena exterior con strobe', 'Alarmas', 400, 25.00, 'Bodega E-E2', 'Paradox Ecuador'),
    ('SENS-MOV', 'Sensor de movimiento', 'Alarmas', 500, 12.00, 'Bodega E-E3', 'Paradox Ecuador'),
    ('CONT-ACC', 'Control de acceso biométrico', 'Control Acceso', 75, 120.00, 'Bodega F-E1', 'ZKTeco Ecuador'),
    ('TARJ-PROX', 'Tarjeta proximidad 125kHz', 'Control Acceso', 2000, 1.50, 'Bodega F-E2', 'ZKTeco Ecuador'),
    ('CERR-ELEC', 'Cerradora eléctrica', 'Control Acceso', 300, 35.00, 'Bodega F-E3', 'ZKTeco Ecuador'),
    ('UPS-1KVA', 'UPS APC 1000VA', 'Infraestructura', 65, 180.00, 'Bodega G-E1', 'APC Ecuador'),
    ('UPS-2KVA', 'UPS APC 2000VA', 'Infraestructura', 35, 350.00, 'Bodega G-E2', 'APC Ecuador'),
    ('CABLE-UTP', 'Cable UTP Cat6 305m', 'Redes', 180, 85.00, 'Bodega D-E4', 'Molex Ecuador'),
    ('CABLE-COAX', 'Cable coaxial RG59 100m', 'Accesorios', 150, 40.00, 'Bodega C-E3', 'Belden Ecuador'),
    ('FUENTE-12V', 'Fuente Poder 12V 10A', 'Accesorios', 600, 18.00, 'Bodega C-E4', 'Meanwell Ecuador'),
    ('SOPORTE-PAR', 'Soporte pared metálico', 'Accesorios', 800, 8.00, 'Bodega C-E5', 'Fabricación Nacional'),
    ('KIT-TOOLS', 'Kit herramientas instalación', 'Accesorios', 100, 35.00, 'Bodega C-E6', 'Stanley Ecuador'),
    ('LEC-HUELLA', 'Lector biométrico huella', 'Control Acceso', 90, 95.00, 'Bodega F-E4', 'ZKTeco Ecuador'),
    ('CAB-VIDEO', 'Cable video balun 100m', 'Accesorios', 250, 30.00, 'Bodega C-E7', 'Molex Ecuador'),
    ('ANT-ALARM', 'Antena alarma GSM', 'Alarmas', 350, 15.00, 'Bodega E-E4', 'Paradox Ecuador'),
    ('JOY-CAM', 'Joystick control cámaras PTZ', 'Control Acceso', 25, 120.00, 'Bodega F-E5', 'Hikvision Ecuador SA'),
    ('MONI-22', 'Monitor 22 pulgadas CCTV', 'Accesorios', 40, 140.00, 'Bodega C-E8', 'Samsung Ecuador'),
    ('CAJA-EMPOT', 'Caja empotrar pared', 'Accesorios', 1000, 4.00, 'Bodega C-E9', 'Fabricación Nacional');

CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    tipo ENUM('entrada', 'salida', 'ajuste') NOT NULL,
    cantidad INT NOT NULL,
    motivo VARCHAR(200),
    usuario VARCHAR(100),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO movimientos_inventario (producto_id, tipo, cantidad, motivo, usuario) VALUES
    (1, 'entrada', 120, 'Compra inicial julio 2026', 'gvega'),
    (2, 'entrada', 85, 'Compra inicial julio 2026', 'gvega'),
    (3, 'entrada', 200, 'Compra inicial julio 2026', 'gvega'),
    (15, 'salida', 5, 'Venta a cliente Seguridad Total', 'gvega'),
    (7, 'salida', 10, 'Venta a cliente Control Acceso', 'gvega');
