-- 02-cctv.sql — Datos semilla CCTV (IF-02)
-- Base de datos: postgres_cctv
\connect postgres_cctv

CREATE SCHEMA IF NOT EXISTS public;

CREATE TABLE IF NOT EXISTS cameras (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200),
    ip_address VARCHAR(15) NOT NULL,
    puerto INT DEFAULT 554,
    usuario VARCHAR(50),
    contrasena VARCHAR(100),
    modelo VARCHAR(100),
    firmware VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO cameras (nombre, ubicacion, ip_address, puerto, usuario, contrasena, modelo, firmware) VALUES
    ('Camara Bodega Norte', 'Bodega principal, estantería A1', '192.168.1.101', 554, 'admin', 'cctv_pass_2026_bodega', 'DS-2CD2T47G2-L', 'V5.7.0'),
    ('Camara Bodega Sur', 'Bodega principal, estantería C3', '192.168.1.102', 554, 'admin', 'cctv_pass_2026_bodega', 'DS-2CD2T47G2-L', 'V5.7.0'),
    ('Camara Showroom', 'Showroom principal, entrada', '192.168.1.103', 554, 'admin', 'cctv_pass_2026_showroom', 'DS-2CD2386G2-I', 'V5.8.1'),
    ('Camara Caja', 'Showroom, punto de caja', '192.168.1.104', 554, 'admin', 'cctv_pass_2026_showroom', 'DS-2CD2386G2-I', 'V5.8.1'),
    ('Camara Data Center', 'Cuarto servidores, rack principal', '192.168.1.105', 554, 'admin', 'cctv_pass_2026_dc', 'DS-2CD2347G2-LU', 'V5.7.2'),
    ('Camara Recepcion', 'Oficinas administrativas, recepción', '192.168.1.106', 554, 'admin', 'cctv_pass_2026_oficinas', 'DS-2CD2T47G2-L', 'V5.7.0'),
    ('Camara Gerencia', 'Oficina gerencia general', '192.168.1.107', 554, 'admin', 'cctv_pass_2026_oficinas', 'DS-2CD2347G2-LU', 'V5.7.2'),
    ('Camara Estacionamiento', 'Estacionamiento exterior', '192.168.1.108', 554, 'admin', 'cctv_pass_2026_exterior', 'DS-2CD2T47G2-L', 'V5.7.0'),
    ('Camara Puerta Trasera', 'Salida emergencia bodega', '192.168.1.109', 554, 'admin', 'cctv_pass_2026_bodega', 'DS-2CD2T47G2-L', 'V5.7.0'),
    ('Camara Sucursal GYE', 'Sucursal Guayaquil, bodega', '192.168.5.101', 554, 'admin', 'cctv_pass_2026_gye', 'DS-2CD2T47G2-L', 'V5.7.1');

CREATE TABLE IF NOT EXISTS grabaciones (
    id SERIAL PRIMARY KEY,
    camera_id INT REFERENCES cameras(id),
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP,
    tamano_mb INT,
    archivo VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO grabaciones (camera_id, fecha_inicio, fecha_fin, tamano_mb, archivo) VALUES
    (1, '2026-07-17 08:00:00', '2026-07-17 09:00:00', 2048, '/mnt/storage/nvr/01/20260717-0800.mp4'),
    (1, '2026-07-17 09:00:00', '2026-07-17 10:00:00', 1980, '/mnt/storage/nvr/01/20260717-0900.mp4'),
    (2, '2026-07-17 08:00:00', '2026-07-17 09:00:00', 1850, '/mnt/storage/nvr/02/20260717-0800.mp4'),
    (3, '2026-07-17 08:00:00', '2026-07-17 09:00:00', 2100, '/mnt/storage/nvr/03/20260717-0800.mp4');
