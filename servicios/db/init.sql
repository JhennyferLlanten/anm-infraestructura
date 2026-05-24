-- Base de datos ANM: Sistema de Información Minero Colombiano

CREATE TABLE IF NOT EXISTS titulos_mineros (
    id SERIAL PRIMARY KEY,
    expediente VARCHAR(50) UNIQUE NOT NULL,
    titular VARCHAR(200) NOT NULL,
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    mineral VARCHAR(100),
    area_hectareas DECIMAL(10,2),
    fecha_inicio DATE,
    fecha_vencimiento DATE,
    estado VARCHAR(50) DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO titulos_mineros
    (expediente, titular, municipio, departamento, mineral, area_hectareas, fecha_inicio, fecha_vencimiento)
VALUES
    ('HED-001', 'Minería del Pacífico S.A.S', 'Istmina', 'Chocó', 'Oro', 1250.50, '2018-03-15', '2048-03-15'),
    ('GHJ-445', 'Carbones del Caribe Ltda', 'La Jagua de Ibirico', 'Cesar', 'Carbón', 8900.00, '2015-07-01', '2045-07-01'),
    ('KLM-789', 'Esmeraldas de Boyacá S.A', 'Muzo', 'Boyacá', 'Esmeraldas', 320.75, '2020-01-10', '2050-01-10')
ON CONFLICT (expediente) DO NOTHING;
