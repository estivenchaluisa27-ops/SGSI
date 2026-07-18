// 01-init.js — Datos semilla nómina (IF-10)
// Base de datos: nomina

db = db.getSiblingDB('nomina');

db.createCollection('empleados');
db.createCollection('nomina');
db.createCollection('cuentas_bancarias');

// Empleados con datos personales y bancarios
db.empleados.insertMany([
    {
        _id: 1,
        nombre: 'Juan Pérez',
        cedula: '1712345678',
        cargo: 'Gerente General',
        departamento: 'Gerencia',
        salario_mensual: 4500.00,
        fecha_ingreso: ISODate('2018-03-15'),
        email: 'jperez@tecnoglobal.ec',
        telefono: '0991234567',
        direccion: 'Av. Amazonas N35-100, Quito'
    },
    {
        _id: 2,
        nombre: 'Laura Rodríguez',
        cedula: '1723456789',
        cargo: 'Directora de TI',
        departamento: 'Tecnología',
        salario_mensual: 3800.00,
        fecha_ingreso: ISODate('2019-06-01'),
        email: 'lrodriguez@tecnoglobal.ec',
        telefono: '0992345678',
        direccion: 'Calle Elia Liut N52-50, Quito'
    },
    {
        _id: 3,
        nombre: 'Carlos Martínez',
        cedula: '1734567890',
        cargo: 'SysAdmin Senior',
        departamento: 'Tecnología',
        salario_mensual: 3200.00,
        fecha_ingreso: ISODate('2020-01-10'),
        email: 'cmartinez@tecnoglobal.ec',
        telefono: '0993456789',
        direccion: 'Av. 6 de Diciembre N30-80, Quito'
    },
    {
        _id: 4,
        nombre: 'Diana Torres',
        cedula: '1745678901',
        cargo: 'SysAdmin Junior',
        departamento: 'Tecnología',
        salario_mensual: 2200.00,
        fecha_ingreso: ISODate('2022-04-20'),
        email: 'dtorres@tecnoglobal.ec',
        telefono: '0994567890',
        direccion: 'Calle Ramón Chiriboga Oe3-20, Quito'
    },
    {
        _id: 5,
        nombre: 'Roberto Ramírez',
        cedula: '1756789012',
        cargo: 'Contador General',
        departamento: 'Contabilidad',
        salario_mensual: 3500.00,
        fecha_ingreso: ISODate('2019-09-05'),
        email: 'rramirez@tecnoglobal.ec',
        telefono: '0995678901',
        direccion: 'Av. República E7-50, Quito'
    },
    {
        _id: 6,
        nombre: 'Gustavo Vega',
        cedula: '1767890123',
        cargo: 'Jefe de Bodega',
        departamento: 'Logística',
        salario_mensual: 2800.00,
        fecha_ingreso: ISODate('2020-07-15'),
        email: 'gvega@tecnoglobal.ec',
        telefono: '0996789012',
        direccion: 'Av. Boyacá Oe4-12, Quito'
    },
    {
        _id: 7,
        nombre: 'Andrea Ruiz',
        cedula: '1778901234',
        cargo: 'Ejecutiva de Ventas',
        departamento: 'Ventas',
        salario_mensual: 2600.00,
        fecha_ingreso: ISODate('2021-02-28'),
        email: 'aruiz@tecnoglobal.ec',
        telefono: '0997890123',
        direccion: 'Calle Panamá 450, Guayaquil'
    },
    {
        _id: 8,
        nombre: 'Miguel Sánchez',
        cedula: '1789012345',
        cargo: 'Supervisor Soporte Técnico',
        departamento: 'Soporte',
        salario_mensual: 2400.00,
        fecha_ingreso: ISODate('2021-08-10'),
        email: 'msanchez@tecnoglobal.ec',
        telefono: '0998901234',
        direccion: 'Av. Quito 220, Cuenca'
    },
    {
        _id: 9,
        nombre: 'Ana Vargas',
        cedula: '1790123456',
        cargo: 'Recepcionista',
        departamento: 'Administración',
        salario_mensual: 1200.00,
        fecha_ingreso: ISODate('2022-11-01'),
        email: 'avargas@tecnoglobal.ec',
        telefono: '0999012345',
        direccion: 'Calle Sucre 5-78, Ambato'
    },
    {
        _id: 10,
        nombre: 'Pedro Mora',
        cedula: '1701234567',
        cargo: 'Técnico Instalador',
        departamento: 'Soporte',
        salario_mensual: 1400.00,
        fecha_ingreso: ISODate('2023-03-20'),
        email: 'pmora@tecnoglobal.ec',
        telefono: '0990123456',
        direccion: 'Av. 9 de Octubre 1120, Guayaquil'
    },
    {
        _id: 11,
        nombre: 'Sofía Narváez',
        cedula: '1712345679',
        cargo: 'Ingeniera de Desarrollo',
        departamento: 'Tecnología',
        salario_mensual: 3000.00,
        fecha_ingreso: ISODate('2021-05-15'),
        email: 'snarvaeez@tecnoglobal.ec',
        telefono: '0991234568',
        direccion: 'Av. Amazonas N35-100, Quito'
    },
    {
        _id: 12,
        nombre: 'Fernando Castro',
        cedula: '1723456780',
        cargo: 'Jefe Sucursal Guayaquil',
        departamento: 'Operaciones',
        salario_mensual: 2900.00,
        fecha_ingreso: ISODate('2020-10-01'),
        email: 'fcastro@tecnoglobal.ec',
        telefono: '0992345679',
        direccion: 'Calle Panamá 450, Guayaquil'
    },
    {
        _id: 13,
        nombre: 'Mario Reyes',
        cedula: '1734567891',
        cargo: 'Chofer Repartidor',
        departamento: 'Logística',
        salario_mensual: 1100.00,
        fecha_ingreso: ISODate('2023-07-10'),
        email: 'mreyes@tecnoglobal.ec',
        telefono: '0993456780',
        direccion: 'Av. 9 de Octubre 1120, Guayaquil'
    },
    {
        _id: 14,
        nombre: 'Omar Jiménez',
        cedula: '1745678902',
        cargo: 'Guardia de Seguridad',
        departamento: 'Seguridad',
        salario_mensual: 1000.00,
        fecha_ingreso: ISODate('2024-01-05'),
        email: 'ojimenez@tecnoglobal.ec',
        telefono: '0994567891',
        direccion: 'Calle Elia Liut N52-50, Quito'
    },
    {
        _id: 15,
        nombre: 'María Contreras',
        cedula: '1756789013',
        cargo: 'Auxiliar Contable',
        departamento: 'Contabilidad',
        salario_mensual: 1500.00,
        fecha_ingreso: ISODate('2023-09-20'),
        email: 'mcontreras@tecnoglobal.ec',
        telefono: '0995678902',
        direccion: 'Av. República E7-50, Quito'
    }
]);

// Cuentas bancarias por empleado
db.cuentas_bancarias.insertMany([
    { empleado_id: 1, banco: 'Banco Pichincha', tipo: 'ahorros', numero: '2201234567' },
    { empleado_id: 2, banco: 'Banco de Guayaquil', tipo: 'corriente', numero: '2301234567' },
    { empleado_id: 3, banco: 'Banco Internacional', tipo: 'ahorros', numero: '2401234567' },
    { empleado_id: 4, banco: 'Banco Pichincha', tipo: 'ahorros', numero: '2202345678' },
    { empleado_id: 5, banco: 'Produbanco', tipo: 'corriente', numero: '2501234567' },
    { empleado_id: 6, banco: 'Banco de Guayaquil', tipo: 'ahorros', numero: '2302345678' },
    { empleado_id: 7, banco: 'Banco Pichincha', tipo: 'corriente', numero: '2203456789' },
    { empleado_id: 8, banco: 'Banco del Austro', tipo: 'ahorros', numero: '2601234567' },
    { empleado_id: 9, banco: 'Banco Pichincha', tipo: 'ahorros', numero: '2204567890' },
    { empleado_id: 10, banco: 'Banco de Guayaquil', tipo: 'ahorros', numero: '2303456789' },
    { empleado_id: 11, banco: 'Produbanco', tipo: 'ahorros', numero: '2502345678' },
    { empleado_id: 12, banco: 'Banco de Guayaquil', tipo: 'corriente', numero: '2304567890' },
    { empleado_id: 13, banco: 'Banco Pichincha', tipo: 'ahorros', numero: '2205678901' },
    { empleado_id: 14, banco: 'Banco Internacional', tipo: 'ahorros', numero: '2402345678' },
    { empleado_id: 15, banco: 'Produbanco', tipo: 'ahorros', numero: '2503456789' }
]);

// Nómina del mes
db.nomina.insertMany([
    { empleado_id: 1, periodo: '2026-07', salario_base: 4500.00, comisiones: 500.00, descuentos: 450.00, liquido: 4550.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 2, periodo: '2026-07', salario_base: 3800.00, comisiones: 0.00, descuentos: 380.00, liquido: 3420.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 3, periodo: '2026-07', salario_base: 3200.00, comisiones: 0.00, descuentos: 320.00, liquido: 2880.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 4, periodo: '2026-07', salario_base: 2200.00, comisiones: 0.00, descuentos: 220.00, liquido: 1980.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 5, periodo: '2026-07', salario_base: 3500.00, comisiones: 0.00, descuentos: 350.00, liquido: 3150.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 6, periodo: '2026-07', salario_base: 2800.00, comisiones: 200.00, descuentos: 280.00, liquido: 2720.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 7, periodo: '2026-07', salario_base: 2600.00, comisiones: 800.00, descuentos: 260.00, liquido: 3140.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 8, periodo: '2026-07', salario_base: 2400.00, comisiones: 100.00, descuentos: 240.00, liquido: 2260.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 9, periodo: '2026-07', salario_base: 1200.00, comisiones: 0.00, descuentos: 120.00, liquido: 1080.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 10, periodo: '2026-07', salario_base: 1400.00, comisiones: 150.00, descuentos: 140.00, liquido: 1410.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 11, periodo: '2026-07', salario_base: 3000.00, comisiones: 0.00, descuentos: 300.00, liquido: 2700.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 12, periodo: '2026-07', salario_base: 2900.00, comisiones: 0.00, descuentos: 290.00, liquido: 2610.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 13, periodo: '2026-07', salario_base: 1100.00, comisiones: 0.00, descuentos: 110.00, liquido: 990.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 14, periodo: '2026-07', salario_base: 1000.00, comisiones: 0.00, descuentos: 100.00, liquido: 900.00, fecha_pago: ISODate('2026-07-15') },
    { empleado_id: 15, periodo: '2026-07', salario_base: 1500.00, comisiones: 0.00, descuentos: 150.00, liquido: 1350.00, fecha_pago: ISODate('2026-07-15') }
]);
