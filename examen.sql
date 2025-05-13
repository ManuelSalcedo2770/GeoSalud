-- Habilitar la extensión PostGIS
CREATE EXTENSION postgis;

-- Crear tabla de zonas sanitarias (polígonos)
CREATE TABLE zona_sanitaria (
    id_zona SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    autoridad_sanitaria VARCHAR(100) NOT NULL,
    fecha_establecimiento DATE,
    superficie_km2 NUMERIC(10, 2),
    poblacion_estimada INTEGER,
    nivel_riesgo VARCHAR(20), -- (Bajo, Medio, Alto, Crítico)
    presupuesto_anual_millones NUMERIC(10, 2),
    indice_desarrollo_sanitario NUMERIC(5, 2),
    numero_emergencias VARCHAR(20),
    sitio_web VARCHAR(200),
    telefono VARCHAR(20),
    pais VARCHAR(50),
    region VARCHAR(50),
    codigo_postal VARCHAR(15),
    descripcion TEXT,
    geom GEOMETRY(POLYGON, 4326)
);

SELECT * FROM zona_sanitaria;

-- Crear tabla de centros de salud (puntos)
CREATE TABLE centro_salud (
    id_centro SERIAL PRIMARY KEY,
    id_zona INTEGER REFERENCES zona_sanitaria(id_zona),
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL, -- (Hospital, Clínica, Centro de Salud Primaria, Farmacia, etc.)
    nivel_atencion INTEGER, -- 1, 2 o 3 (primaria, secundaria, terciaria)
    capacidad_camas INTEGER,
    especialidades VARCHAR(200), -- lista de especialidades principales
    personal_medico INTEGER,
    horario_atencion VARCHAR(50), -- ej. "24/7" o "8:00-20:00"
    ano_fundacion INTEGER,
    es_publico BOOLEAN,
    estado VARCHAR(20), -- (Operativo, En renovación, Cerrado temporalmente)
    telefono_emergencias VARCHAR(20),
    email_contacto VARCHAR(100),
    descripcion TEXT,
    geom GEOMETRY(POINT, 4326)
);

SELECT * FROM centro_salud;


-- Crear índices espaciales
CREATE INDEX idx_zona_geom ON zona_sanitaria USING GIST(geom);
CREATE INDEX idx_centro_geom ON centro_salud USING GIST(geom);

-- Insertar 10 zonas sanitarias (polígonos)
INSERT INTO zona_sanitaria (nombre, autoridad_sanitaria, fecha_establecimiento, superficie_km2, poblacion_estimada, 
                        nivel_riesgo, presupuesto_anual_millones, indice_desarrollo_sanitario, numero_emergencias, 
                        sitio_web, telefono, pais, region, codigo_postal, descripcion, geom)
VALUES
-- Zona 1: Distrito Sanitario Centro (Madrid, España)
('Distrito Sanitario Centro', 'Consejería de Sanidad de Madrid', '1986-05-12', 5.23, 132000, 
 'Medio', 45.7, 7.8, '112', 
 'www.comunidad.madrid/servicios/salud', '+34-91-370-0000',
 'España', 'Madrid', '28001', 
 'Distrito sanitario que cubre el centro histórico de Madrid', 
 ST_GeomFromText('POLYGON((-3.711 40.412, -3.711 40.425, -3.695 40.425, -3.695 40.412, -3.711 40.412))', 4326)),

-- Zona 2: Zona Norte de Salud (Barcelona, España)
('Zona Norte de Salud', 'Departament de Salut de Catalunya', '1990-03-15', 8.75, 198000, 
 'Bajo', 56.3, 8.2, '112', 
 'www.gencat.cat/salut', '+34-93-403-5300',
 'España', 'Barcelona', '08001', 
 'Zona sanitaria que abarca los distritos del norte de Barcelona', 
 ST_GeomFromText('POLYGON((2.165 41.400, 2.165 41.415, 2.180 41.415, 2.180 41.400, 2.165 41.400))', 4326)),

-- Zona 3: Manhattan Health District (Nueva York, USA)
('Manhattan Health District', 'NYC Department of Health', '1969-07-22', 59.13, 1650000, 
 'Alto', 320.5, 8.7, '911', 
 'www.nyc.gov/health', '+1-212-639-9675',
 'Estados Unidos', 'Nueva York', '10001', 
 'Distrito sanitario que cubre la isla de Manhattan', 
 ST_GeomFromText('POLYGON((-74.020 40.700, -74.020 40.820, -73.930 40.820, -73.930 40.700, -74.020 40.700))', 4326)),

-- Zona 4: Distrito Sanitario Sur (Ciudad de México)
('Distrito Sanitario Sur', 'Secretaría de Salud de CDMX', '1985-09-19', 122.00, 2200000, 
 'Alto', 175.8, 6.5, '911', 
 'www.salud.cdmx.gob.mx', '+52-55-5132-0900',
 'México', 'Ciudad de México', '04100', 
 'Zona sanitaria del sur de la Ciudad de México, con alta densidad poblacional', 
 ST_GeomFromText('POLYGON((-99.200 19.250, -99.200 19.350, -99.050 19.350, -99.050 19.250, -99.200 19.250))', 4326)),

-- Zona 5: West London Health Area (Londres, UK)
('West London Health Area', 'NHS England', '1948-07-05', 45.62, 980000, 
 'Medio', 290.5, 8.9, '999', 
 'www.nhs.uk/service-search', '+44-20-3456-7890',
 'Reino Unido', 'Londres', 'W1 1AA', 
 'Área sanitaria que cubre el oeste de Londres, incluyendo zonas como Kensington y Chelsea', 
 ST_GeomFromText('POLYGON((-0.225 51.485, -0.225 51.520, -0.155 51.520, -0.155 51.485, -0.225 51.485))', 4326)),

-- Zona 6: Region Sanitaria XIII (Buenos Aires, Argentina)
('Region Sanitaria XIII', 'Ministerio de Salud de Buenos Aires', '1983-12-10', 203.00, 1350000, 
 'Medio', 98.7, 6.8, '107', 
 'www.ms.gba.gov.ar', '+54-11-4383-9000',
 'Argentina', 'Buenos Aires', 'C1001', 
 'Región sanitaria que abarca el centro-norte de la provincia de Buenos Aires', 
 ST_GeomFromText('POLYGON((-58.490 -34.650, -58.490 -34.550, -58.350 -34.550, -58.350 -34.650, -58.490 -34.650))', 4326)),

-- Zona 7: Região Centro-Oeste (São Paulo, Brasil)
('Região Centro-Oeste', 'Secretaria Municipal de Saúde', '1990-05-22', 85.00, 1750000, 
 'Alto', 125.3, 6.7, '192', 
 'www.prefeitura.sp.gov.br/saude', '+55-11-3397-2000',
 'Brasil', 'São Paulo', '01001-000', 
 'Región sanitaria que cubre el centro y oeste de la ciudad de São Paulo', 
 ST_GeomFromText('POLYGON((-46.700 -23.580, -46.700 -23.500, -46.600 -23.500, -46.600 -23.580, -46.700 -23.580))', 4326)),

-- Zona 8: Distrito Sanitario Eixample (Barcelona, España)
('Distrito Sanitario Eixample', 'Departament de Salut de Catalunya', '1985-06-30', 7.48, 267000, 
 'Bajo', 62.4, 8.5, '112', 
 'www.gencat.cat/salut', '+34-93-403-5700',
 'España', 'Barcelona', '08029', 
 'Distrito sanitario que cubre la zona del Eixample en Barcelona', 
 ST_GeomFromText('POLYGON((2.145 41.380, 2.145 41.397, 2.175 41.397, 2.175 41.380, 2.145 41.380))', 4326)),

-- Zona 9: Distrito Norte de Salud (Santiago, Chile)
('Distrito Norte de Salud', 'Ministerio de Salud de Chile', '1980-03-27', 92.00, 850000, 
 'Medio', 87.5, 7.3, '131', 
 'www.minsal.cl', '+56-2-2574-0100',
 'Chile', 'Santiago', '8320000', 
 'Distrito sanitario que abarca la zona norte del Gran Santiago', 
 ST_GeomFromText('POLYGON((-70.670 -33.360, -70.670 -33.310, -70.610 -33.310, -70.610 -33.360, -70.670 -33.360))', 4326)),

-- Zona 10: Distrito Sanitario Centro (Sevilla, España)
('Distrito Sanitario Centro', 'Consejería de Salud de Andalucía', '1988-11-12', 4.23, 108000, 
 'Bajo', 38.5, 7.9, '112', 
 'www.juntadeandalucia.es/salud', '+34-95-501-2000',
 'España', 'Sevilla', '41001', 
 'Distrito sanitario que cubre el casco histórico de Sevilla', 
 ST_GeomFromText('POLYGON((-5.995 37.382, -5.995 37.402, -5.980 37.402, -5.980 37.382, -5.995 37.382))', 4326));

-- Insertar 30 centros de salud (puntos georreferenciados)
INSERT INTO centro_salud (id_zona, nombre, tipo, nivel_atencion, capacidad_camas, 
                     especialidades, personal_medico, horario_atencion, 
                     ano_fundacion, es_publico, estado, telefono_emergencias, email_contacto, descripcion, geom)
VALUES
-- Distrito Sanitario Centro (Madrid, España) (id_zona: 1)
(1, 'Hospital Clínico San Carlos', 'Hospital', 3, 750, 
 'Cardiología, Neurología, Oncología, Traumatología, Pediatría', 1250, '24/7', 
 1787, true, 'Operativo', '112', 'info@hcsc.es', 
 'Hospital universitario de referencia en la Comunidad de Madrid', 
 ST_GeomFromText('POINT(-3.708 40.420)', 4326)),

(1, 'Centro de Salud Lavapiés', 'Centro de Salud Primaria', 1, 0, 
 'Medicina General, Pediatría, Enfermería', 35, '08:00-21:00', 
 1995, true, 'Operativo', '112', 'cslavapies@salud.madrid.org', 
 'Centro de atención primaria que atiende al barrio de Lavapiés', 
 ST_GeomFromText('POINT(-3.702 40.415)', 4326)),

(1, 'Farmacia 24h Chueca', 'Farmacia', 1, 0, 
 'Dispensación de medicamentos, Asesoramiento farmacéutico', 8, '24/7', 
 1982, false, 'Operativo', '+34-91-522-4867', 'farmacia24hchueca@gmail.com', 
 'Farmacia abierta 24 horas todos los días del año', 
 ST_GeomFromText('POINT(-3.698 40.418)', 4326)),

-- Zona Norte de Salud (Barcelona, España) (id_zona: 2)
(2, 'Hospital del Mar', 'Hospital', 3, 420, 
 'Medicina Interna, Cirugía, Psiquiatría, Rehabilitación, Ginecología', 850, '24/7', 
 1905, true, 'Operativo', '112', 'info@hospitaldelmar.cat', 
 'Hospital situado junto a la playa de la Barceloneta con especialidad en investigación médica', 
 ST_GeomFromText('POINT(2.173 41.410)', 4326)),

(2, 'CAP Vila Olímpica', 'Centro de Salud Primaria', 1, 0, 
 'Medicina Familiar, Pediatría, Enfermería, Trabajo Social', 45, '08:00-20:00', 
 1992, true, 'Operativo', '112', 'capvilaolimpica@gencat.cat', 
 'Centro de atención primaria construido tras los Juegos Olímpicos de 1992', 
 ST_GeomFromText('POINT(2.175 41.405)', 4326)),

(2, 'Clínica Teknon', 'Clínica Privada', 2, 285, 
 'Cirugía Estética, Medicina Deportiva, Traumatología', 320, '24/7', 
 1994, false, 'Operativo', '+34-93-290-6200', 'info@teknon.es', 
 'Uno de los centros médicos privados más prestigiosos de Barcelona', 
 ST_GeomFromText('POINT(2.170 41.408)', 4326)),

-- Manhattan Health District (Nueva York, USA) (id_zona: 3)
(3, 'NewYork-Presbyterian Hospital', 'Hospital', 3, 2600, 
 'Cardiología, Neurología, Oncología, Traumatología, Trasplantes', 5000, '24/7', 
 1771, false, 'Operativo', '911', 'info@nyp.org', 
 'Uno de los hospitales más grandes y prestigiosos de Estados Unidos', 
 ST_GeomFromText('POINT(-73.940 40.770)', 4326)),

(3, 'Bellevue Hospital Center', 'Hospital', 3, 850, 
 'Psiquiatría, Traumatología, Emergencias, Pediatría', 2200, '24/7', 
 1736, true, 'Operativo', '911', 'info@bellevue.org', 
 'El hospital público más antiguo de Estados Unidos', 
 ST_GeomFromText('POINT(-73.975 40.740)', 4326)),

(3, 'Urgent Care Manhattan', 'Centro de Urgencias', 2, 15, 
 'Medicina General, Traumatología Menor, Diagnóstico Rápido', 30, '07:00-23:00', 
 2010, false, 'Operativo', '+1-212-555-7000', 'info@ucmanhattan.com', 
 'Centro de atención urgente sin cita previa', 
 ST_GeomFromText('POINT(-73.980 40.750)', 4326)),

-- Distrito Sanitario Sur (Ciudad de México) (id_zona: 4)
(4, 'Hospital General de México', 'Hospital', 3, 1020, 
 'Medicina Interna, Cirugía, Ginecología, Pediatría, Oncología', 2800, '24/7', 
 1905, true, 'Operativo', '911', 'direccion@hgm.salud.gob.mx', 
 'Hospital de alta especialidad y centro de formación médica', 
 ST_GeomFromText('POINT(-99.150 19.300)', 4326)),

(4, 'Centro de Salud T-III Tlalpan', 'Centro de Salud Primaria', 1, 0, 
 'Medicina Familiar, Pediatría, Vacunación, Salud Reproductiva', 40, '08:00-20:00', 
 1995, true, 'Operativo', '911', 'cstlalpan@salud.cdmx.gob.mx', 
 'Centro de atención primaria con enfoque en salud comunitaria', 
 ST_GeomFromText('POINT(-99.180 19.290)', 4326)),

(4, 'Clínica del Sur', 'Clínica Privada', 2, 80, 
 'Ginecología, Pediatría, Traumatología', 95, '24/7', 
 2005, false, 'Operativo', '+52-55-5606-6222', 'contacto@clinicadelsur.mx', 
 'Clínica especializada en salud materno-infantil', 
 ST_GeomFromText('POINT(-99.160 19.310)', 4326)),

-- West London Health Area (Londres, UK) (id_zona: 5)
(5, 'St Marys Hospital', 'Hospital', 3, 500, 
 'Cardiología, Emergencias, Neurología, Pediatría', 1200, '24/7', 
 1845, true, 'Operativo', '999', 'info@stmarys.nhs.uk', 
 'Hospital universitario asociado al Imperial College London', 
 ST_GeomFromText('POINT(-0.175 51.495)', 4326)),

(5, 'Chelsea and Westminster Hospital', 'Hospital', 3, 430, 
 'Quemados, Maternidad, VIH/SIDA, Pediatría', 1100, '24/7', 
 1993, true, 'Operativo', '999', 'enquiries@chelwest.nhs.uk', 
 'Hospital pionero en tratamiento de quemaduras y VIH', 
 ST_GeomFromText('POINT(-0.180 51.487)', 4326)),

(5, 'Kensington GP Surgery', 'Centro de Salud Primaria', 1, 0, 
 'Medicina General, Vacunación, Salud Mental Básica', 25, '08:00-18:30', 
 1998, true, 'Operativo', '111', 'admin@kensingtongp.nhs.uk', 
 'Consulta médica general del NHS para la zona de Kensington', 
 ST_GeomFromText('POINT(-0.190 51.500)', 4326)),

-- Region Sanitaria XIII (Buenos Aires, Argentina) (id_zona: 6)
(6, 'Hospital Fernández', 'Hospital', 3, 400, 
 'Medicina Interna, Cirugía, Emergencias, Psiquiatría', 980, '24/7', 
 1888, true, 'Operativo', '107', 'info@hospitalfernandez.org.ar', 
 'Hospital general de agudos con especialidad en atención de accidentados', 
 ST_GeomFromText('POINT(-58.400 -34.580)', 4326)),

(6, 'Centro de Salud N°15', 'Centro de Salud Primaria', 1, 0, 
 'Medicina Familiar, Pediatría, Enfermería, Trabajo Social', 30, '08:00-20:00', 
 1990, true, 'Operativo', '107', 'centrosalud15@buenosaires.gob.ar', 
 'Centro de atención primaria con programas de salud comunitaria', 
 ST_GeomFromText('POINT(-58.420 -34.600)', 4326)),

(6, 'Sanatorio Mater Dei', 'Clínica Privada', 2, 150, 
 'Maternidad, Pediatría, Cirugía', 200, '24/7', 
 1962, false, 'Operativo', '+54-11-4809-5555', 'info@maternidadmaterdei.com.ar', 
 'Centro médico especializado en maternidad y neonatología', 
 ST_GeomFromText('POINT(-58.380 -34.570)', 4326)),

-- Região Centro-Oeste (São Paulo, Brasil) (id_zona: 7)
(7, 'Hospital das Clínicas da FMUSP', 'Hospital', 3, 2200, 
 'Cardiología, Neurología, Oncología, Trasplantes, Quemados', 4500, '24/7', 
 1944, true, 'Operativo', '192', 'hc@hc.fm.usp.br', 
 'El complejo hospitalario más grande de Latinoamérica', 
 ST_GeomFromText('POINT(-46.670 -23.550)', 4326)),

(7, 'UBS Barra Funda', 'Centro de Salud Primaria', 1, 0, 
 'Medicina Familiar, Vacunación, Programas Preventivos', 45, '07:00-19:00', 
 1988, true, 'Operativo', '192', 'ubs.barrafunda@prefeitura.sp.gov.br', 
 'Unidad básica de salud con enfoque en población vulnerable', 
 ST_GeomFromText('POINT(-46.650 -23.530)', 4326)),

(7, 'Hospital Sírio-Libanês', 'Hospital', 3, 450, 
 'Oncología, Cardiología, Neurología, Trasplantes', 1300, '24/7', 
 1921, false, 'Operativo', '+55-11-3394-0200', 'contato@hsl.org.br', 
 'Uno de los hospitales privados más avanzados de Brasil', 
 ST_GeomFromText('POINT(-46.660 -23.560)', 4326)),

-- Distrito Sanitario Eixample (Barcelona, España) (id_zona: 8)
(8, 'Hospital Clinic', 'Hospital', 3, 700, 
 'Medicina Interna, Hematología, Digestivo, Psiquiatría', 2000, '24/7', 
 1906, true, 'Operativo', '112', 'info@hospitalclinic.org', 
 'Hospital universitario de referencia internacional en investigación médica', 
 ST_GeomFromText('POINT(2.155 41.390)', 4326)),

(8, 'CAP Eixample', 'Centro de Salud Primaria', 1, 0, 
 'Medicina General, Pediatría, Enfermería', 50, '08:00-20:00', 
 1990, true, 'Operativo', '112', 'capeixample@gencat.cat', 
 'Centro de atención primaria que da servicio al distrito del Eixample', 
 ST_GeomFromText('POINT(2.160 41.385)', 4326)),

(8, 'Farmacia Bolos', 'Farmacia', 1, 0, 
 'Dispensación de medicamentos, Análisis clínicos básicos', 5, '09:00-21:00', 
 1978, false, 'Operativo', '+34-93-323-4578', 'info@farmaciabolos.com', 
 'Farmacia tradicional con servicios de análisis básicos', 
 ST_GeomFromText('POINT(2.158 41.392)', 4326)),

-- Distrito Norte de Salud (Santiago, Chile) (id_zona: 9)
(9, 'Hospital San José', 'Hospital', 3, 620, 
 'Medicina Interna, Traumatología, Ginecología, Pediatría', 1100, '24/7', 
 1872, true, 'Operativo', '131', 'contacto@hsj.cl', 
 'Hospital público con especialidad en traumatología y urgencias', 
 ST_GeomFromText('POINT(-70.650 -33.340)', 4326)),

(9, 'CESFAM Recoleta', 'Centro de Salud Familiar', 1, 0, 
 'Medicina Familiar, Pediatría, Salud Mental, Matrona', 40, '08:00-17:00', 
 1998, true, 'Operativo', '131', 'secretaria@cesfamrecoleta.cl', 
 'Centro de salud familiar con modelo de atención integral', 
 ST_GeomFromText('POINT(-70.640 -33.335)', 4326)),

(9, 'Clínica Indisa', 'Clínica Privada', 2, 350, 
 'Cardiología, Maternidad, Cirugía', 400, '24/7', 
 1961, false, 'Operativo', '+56-2-2362-5555', 'info@indisa.cl', 
 'Institución de salud privada con tecnología de punta', 
 ST_GeomFromText('POINT(-70.630 -33.330)', 4326)),

-- Distrito Sanitario Centro (Sevilla, España) (id_zona: 10)
(10, 'Hospital Virgen del Rocío', 'Hospital', 3, 1250, 
 'Cirugía, Cardiología, Oncología, Traumatología, Pediatría', 5000, '24/7', 
 1955, true, 'Operativo', '112', 'info@hvr.es', 
 'El complejo hospitalario más grande de Andalucía', 
 ST_GeomFromText('POINT(-5.985 37.390)', 4326)),

(10, 'Centro de Salud Alameda', 'Centro de Salud Primaria', 1, 0, 
 'Medicina General, Pediatría, Enfermería', 35, '08:00-20:00', 
 1992, true, 'Operativo', '112', 'csalameda@juntadeandalucia.es', 
 'Centro de atención primaria situado en el centro histórico', 
 ST_GeomFromText('POINT(-5.990 37.385)', 4326)),

(10, 'Farmacia Santa Ana', 'Farmacia', 1, 0, 
 'Dispensación de medicamentos, Formulación magistral', 6, '09:00-21:00', 
 1890, false, 'Operativo', '+34-95-421-3344', 'farmacia@santaana.es', 
 'Farmacia histórica con más de 130 años de antigüedad', 
 ST_GeomFromText('POINT(-5.992 37.387)', 4326));