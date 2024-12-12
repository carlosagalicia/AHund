CREATE DATABASE AHUND;
USE AHUND;

CREATE TABLE Cliente (
  IDCliente INT NOT NULL AUTO_INCREMENT,
  CorreoElectronico VARCHAR(255) NOT NULL,
  Telefono VARCHAR(20) NOT NULL,
  Tipo INT(1) NOT NULL,
  PRIMARY KEY (IDCliente)
);

CREATE TABLE PersonaFisica (
  IDCliente INT NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(40) NOT NULL,
  ApellidoPaterno VARCHAR(40) NOT NULL,
  AppellidoMaterno VARCHAR(40) NOT NULL,
  PRIMARY KEY (IDCliente),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);

CREATE TABLE PersonaMoral (
  IDCliente INT NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(40) NOT NULL,
  RazonSocial VARCHAR(80) NOT NULL,
  PRIMARY KEY (IDCliente),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);

CREATE TABLE Administrador (
  IDColaborador INT NOT NULL AUTO_INCREMENT,
  Usuario VARCHAR(32) NOT NULL,
  Contrasena VARCHAR(255) NOT NULL,
  Nombre VARCHAR(40) NOT NULL,
  ApellidoPaterno VARCHAR(40) NOT NULL,
  ApellidoMaterno VARCHAR(40) NOT NULL,
  CorreoElectronico VARCHAR(32) NOT NULL,
  PermisoAdmin BOOLEAN NOT NULL,
  PRIMARY KEY (IDColaborador)
);

CREATE TABLE Colaborador (
  IDColaborador INT NOT NULL AUTO_INCREMENT,
  Usuario VARCHAR(32) NOT NULL,
  Contrasena VARCHAR(255) NOT NULL,
  Nombre VARCHAR(40) NOT NULL,
  ApellidoPaterno VARCHAR(40) NOT NULL,
  ApellidoMaterno VARCHAR(40) NOT NULL,
  CorreoElectronico VARCHAR(32) NOT NULL,
  PermisoAdmin BOOLEAN NOT NULL,
  PRIMARY KEY (IDColaborador)
);

CREATE TABLE Proyecto(
	IDProyecto INT NOT NULL AUTO_INCREMENT,
    IDCliente INT NOT NULL,
    IDAdministrador INT NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    FechaInicio DATETIME NOT NULL,
    FechaFinal DATETIME NOT NULL,
    Tipo INT NOT NULL ,
    Estado BOOLEAN NOT NULL ,
    PRIMARY KEY (IDProyecto),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
    FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDColaborador)
);

CREATE TABLE Trabaja(
    IDProyecto INT NOT NULL,
    IDColaborador INT NOT NULL,
    PRIMARY KEY (IDProyecto, IDColaborador),
    FOREIGN KEY (IDProyecto) REFERENCES Proyecto(IDProyecto),
    FOREIGN KEY (IDColaborador) REFERENCES Colaborador(IDColaborador)
);

CREATE TABLE Administra(
    IDColaborador INT NOT NULL,
    IDAdministrador INT NOT NULL,
    Fecha DATETIME NOT NULL,
    PRIMARY KEY (IDColaborador, IDAdministrador),
    FOREIGN KEY (IDColaborador) REFERENCES Colaborador(IDColaborador),
    FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDColaborador)
);

CREATE TABLE Riesgo(
    IDRiesgo INT NOT NULL AUTO_INCREMENT,
    IDMedida INT NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    Fecha DATETIME NOT NULL,
    Descripcion VARCHAR(512) NOT NULL ,
    Puntaje INT NOT NULL,
    Estatus BOOLEAN NOT NULL,
    Tipo INT NOT NULL,
    PRIMARY KEY (IDRiesgo)
);

CREATE TABLE Medida(
    IDMedida INT NOT NULL AUTO_INCREMENT,
    IDRiesgo INT NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    Descripcion VARCHAR(512) NOT NULL ,
    Tipo INT NOT NULL,
    PRIMARY KEY (IDMedida)
);

ALTER TABLE Medida
ADD FOREIGN KEY (IDRiesgo) REFERENCES Riesgo(IDRiesgo);


CREATE TABLE Presenta(
    IDRiesgo INT NOT NULL,
    IDProyecto INT NOT NULL,
    FechaAsignacion DATETIME NOT NULL,
    PonderacionRelativa INT NOT NULL,
    PRIMARY KEY (IDProyecto, IDRiesgo),
    FOREIGN KEY (IDProyecto) REFERENCES Proyecto(IDProyecto),
    FOREIGN KEY (IDRiesgo) REFERENCES Riesgo(IDRiesgo)
);

INSERT INTO Cliente (CorreoElectronico, Telefono, Tipo) VALUES
('juan_perez@gmail.com', '1234567890', 1),
('maria_garcia@gmail.com', '2345678901', 2),
('carlos_martinez@gmail.com', '3456789012',1),
('ana_lopez@gmail.com', '4567890123',2),
('pedro_sanchez@gmail.com', '5678901234',1),
('laura_rodriguez@gmail.com', '6789012345',2),
('miguel_gomez@gmail.com', '7890123456',1),
('elena_hernandez@gmail.com', '8901234567',2),
('david_fernandez@gmail.com', '9012345678',1),
('sofia_diaz@gmail.com', '1234567890',2),
('diego_martinez@gmail.com', '2345678901',1),
('lucia_gonzalez@gmail.com', '3456789012',2),
('javier_gomez@gmail.com', '4567890123',1),
('paula_perez@gmail.com', '5678901234',2),
('alejandro_lopez@gmail.com', '6789012345',1),
('marta_hernandez@gmail.com', '7890123456',2),
('raul_diaz@gmail.com', '8901234567',1),
('carmen_rodriguez@gmail.com', '9012345678',2),
('roberto_garcia@gmail.com', '1234567890',1),
('isabel_sanchez@gmail.com', '2345678901',2);


INSERT INTO PersonaFisica (Nombre, ApellidoPaterno, AppellidoMaterno) VALUES
('Juan', 'Pérez', 'Gómez'),
('María', 'García', 'López'),
('Carlos', 'Martínez', 'Hernández'),
('Ana', 'López', 'Fernández'),
('Pedro', 'Sánchez', 'Díaz'),
('Laura', 'Rodríguez', 'Martínez'),
('Miguel', 'Gómez', 'Pérez'),
('Elena', 'Hernández', 'Sánchez'),
('David', 'Fernández', 'González'),
('Sofía', 'Díaz', 'García'),
('Diego', 'Martínez', 'López'),
('Lucía', 'González', 'Hernández'),
('Javier', 'Gómez', 'Rodríguez'),
('Paula', 'Pérez', 'Sánchez'),
('Alejandro', 'López', 'Fernández'),
('Marta', 'Hernández', 'Martínez'),
('Raul', 'Díaz', 'Gómez'),
('Carmen', 'Rodríguez', 'Pérez'),
('Roberto', 'García', 'López'),
('Isabel', 'Sánchez', 'Martínez');

INSERT INTO PersonaMoral (Nombre, RazonSocial) VALUES
('ACME Inc.', 'ACME - Soluciones Tecnológicas'),
('WidgetCorp', 'WidgetCorp - Innovación en Productos'),
('Eagle Enterprises', 'Eagle Enterprises - Líder en Servicios'),
('Omega Solutions', 'Omega Solutions - Soluciones Empresariales'),
('Apex Innovations', 'Apex Innovations - Innovación en Desarrollo'),
('Zenith Industries', 'Zenith Industries - Excelencia en Manufactura'),
('Prime Ventures', 'Prime Ventures - Impulsando el Futuro'),
('Spectra Group', 'Spectra Group - Conectando el Mundo'),
('Summit Enterprises', 'Summit Enterprises - Elevando Estándares'),
('Vertex Solutions', 'Vertex Solutions - Transformando Negocios'),
('Horizon Technologies', 'Horizon Technologies - Tecnología del Mañana'),
('Infinite Innovations', 'Infinite Innovations - Innovación Infinita'),
('Global Industries', 'Global Industries - Líder en Mercados Globales'),
('Meridian Solutions', 'Meridian Solutions - Navegando el Éxito'),
('Pinnacle Enterprises', 'Pinnacle Enterprises - Cima de la Excelencia'),
('Frontier Group', 'Frontier Group - Explorando Nuevos Horizontes'),
('United Ventures', 'United Ventures - Uniendo Fuerzas'),
('Strategic Solutions', 'Strategic Solutions - Soluciones Estratégicas'),
('Apex Innovations', 'Apex Innovations - Innovación en Desarrollo'),
('Empire Enterprises', 'Empire Enterprises - Imperio de Oportunidades');

INSERT INTO Administrador (Usuario, Contrasena, Nombre, ApellidoPaterno, ApellidoMaterno, CorreoElectronico, PermisoAdmin) VALUES
('maverick', 'claveM4v3r1ck', 'Maverick', 'Smith', 'Jones', 'maverick@appix.mx', 1),
('scarlet', 'c0ntr4s3ñaS@r1et', 'Scarlet', 'Johnson', 'Williams', 'scarlet@appix.mx', 1),
('shadow', 'p@ssw0rdSh@d0w', 'Shadow', 'Brown', 'Davis', 'shadow@appix.mx', 1),
('blaze', 'bl4zeP@ssw0rd', 'Blaze', 'Miller', 'Taylor', 'blaze@appix.mx', 1),
('phoenix', 'ph03n1xK3y', 'Phoenix', 'Wilson', 'Anderson', 'phoenix@appix.mx', 1),
('thunder', 'T@z3rB0lt', 'Thunder', 'Martinez', 'Thomas', 'thunder@appix.mx', 1),
('storm', 'Str0m@cc3ss', 'Storm', 'Lee', 'Hernandez', 'storm@appix.mx', 1),
('blitz', 'Bl1tzKrieg!', 'Blitz', 'Taylor', 'Clark', 'blitz@appix.mx', 1),
('raven', 'R@v3nCl@w', 'Raven', 'Garcia', 'Lewis', 'raven@appix.mx', 1),
('viper', 'V1p3rP@ss', 'Viper', 'Rodriguez', 'Walker', 'viper@appix.mx', 1),
('echo', 'EchoP@ssw0rd', 'Echo', 'Harris', 'King', 'echo@appix.mx', 1),
('jinx', 'J1nxP@ss', 'Jinx', 'Young', 'Scott', 'jinx@appix.mx', 1),
('blade', 'Bl@d3P@ss', 'Blade', 'Allen', 'Green', 'blade@appix.mx', 1),
('mystic', 'Myst1cK3y', 'Mystic', 'Wright', 'Adams', 'mystic@appix.mx', 1),
('phantom', 'Ph@nt0mP@ss', 'Phantom', 'Phillips', 'Evans', 'phantom@appix.mx', 1),
('specter', 'Sp3ct3rP@ss', 'Specter', 'Carter', 'Baker', 'specter@appix.mx', 1),
('nova', 'N0v@P@ss', 'Nova', 'Perez', 'Rivera', 'nova@appix.mx', 1),
('blizzard', 'Bl1zz@rdP@ss', 'Blizzard', 'Sanchez', 'Torres', 'blizzard@appix.mx', 1),
('zenith', 'Z3n1thK3y!', 'Zenith', 'Scott', 'Ramirez', 'zenith@appix.mx', 1),
('luna', 'Lun@P@ssw0rd', 'Luna', 'Gomez', 'Parker', 'luna@appix.mx', 1);

INSERT INTO Colaborador (Usuario, Contrasena, Nombre, ApellidoPaterno, ApellidoMaterno, CorreoElectronico, PermisoAdmin) VALUES
('jdoe', 'contrasena123', 'John', 'Doe', 'González', 'john.doe@appix.mx', 0),
('lsmith', 'password321', 'Linda', 'Smith', 'Martínez', 'linda.smith@appix.mx', 0),
( 'mgonzalez', 'pass1234', 'Mario', 'González', 'López', 'mario.gonzalez@appix.mx', 0),
( 'jrodriguez', 'secretword', 'Julia', 'Rodríguez', 'Sánchez', 'julia.rodriguez@appix.mx', 0),
('rwilliams', 'securepass', 'Robert', 'Williams', 'Fernández', 'robert.williams@appix.mx', 0),
( 'slee', 'password123', 'Sophia', 'Lee', 'Hernández', 'sophia.lee@appix.mx', 0),
( 'jjones', 'adminpass', 'Jennifer', 'Jones', 'García', 'jennifer.jones@appix.mx', 0),
( 'mlopez', 'pass12345', 'Miguel', 'López', 'Rodríguez', 'miguel.lopez@appix.mx', 0),
( 'ppatel', 'patelpass', 'Priya', 'Patel', 'Fernández', 'priya.patel@appix.mx', 0),
( 'jgarcia', 'garcia123', 'Jorge', 'García', 'Martínez', 'jorge.garcia@appix.mx', 0),
( 'afernandez', 'fernandez123', 'Ana', 'Fernández', 'López', 'ana.fernandez@appix.mx', 0),
( 'cjackson', 'jacksonpass', 'Christopher', 'Jackson', 'Sánchez', 'christopher.jackson@appix.mx', 0),
( 'krodriguez', 'rodriguezpass', 'Karen', 'Rodríguez', 'Hernández', 'karen.rodriguez@appix.mx', 0),
( 'tmiller', 'millerpass', 'Taylor', 'Miller', 'Martínez', 'taylor.miller@appix.mx', 0),
( 'asanchez', 'passsanchez', 'Alicia', 'Sánchez', 'Fernández', 'alicia.sanchez@appix.mx', 0),
( 'wlee', 'leepass', 'William', 'Lee', 'González', 'william.lee@appix.mx', 0),
( 'rlopez', 'rlopezpass', 'Rebecca', 'López', 'Hernández', 'rebecca.lopez@appix.mx', 0),
( 'ksmith', 'smith123', 'Kevin', 'Smith', 'García', 'kevin.smith@appix.mx', 0),
( 'vfernandez', 'vfernandezpass', 'Victoria', 'Fernández', 'Martínez', 'victoria.fernandez@appix.mx', 0),
( 'mgonzalez2', 'gonzalezpass', 'María', 'González', 'López', 'maria.gonzalez@appix.mx', 0);

INSERT INTO Proyecto (IDCliente, IDAdministrador, Nombre, FechaInicio, FechaFinal, Tipo, Estado) VALUES
(1, 3, 'Desarrollo de Aplicación Móvil', '2024-01-15 09:00:00', '2024-07-15 18:00:00', 1, 1),
(2, 3, 'Implementación de Sistema de Gestión', '2024-02-01 08:30:00', '2024-08-01 17:30:00', 2, 1),
(3, 2, 'Diseño de Campaña Publicitaria', '2024-03-10 10:00:00', '2024-09-10 19:00:00', 1, 0),
(4, 2, 'Desarrollo de Plataforma E-Commerce', '2024-04-05 09:30:00', '2024-10-05 18:30:00', 2, 0),
(5, 1, 'Consultoría en Estrategia de Marketing', '2024-05-20 10:00:00', '2024-11-20 19:00:00', 1, 1),
(6, 1, 'Diseño de Identidad Corporativa', '2024-06-02 08:00:00', '2024-12-02 17:00:00', 2, 1),
(7, 1, 'Desarrollo de Software a Medida', '2024-07-12 09:30:00', '2025-01-12 18:30:00', 1, 0),
(8, 1, 'Implementación de Sistema ERP', '2024-08-25 08:00:00', '2025-02-25 17:00:00', 2, 0),
(9, 1, 'Asesoría en Gestión de Recursos Humanos', '2024-09-14 10:00:00', '2025-03-14 19:00:00', 1, 1),
(10, 2, 'Desarrollo de Sitio Web Corporativo', '2024-10-30 08:30:00', '2025-04-30 17:30:00', 2, 1),
(11, 2, 'Consultoría en Finanzas Empresariales', '2024-11-18 09:00:00', '2025-05-18 18:00:00', 1, 0),
(12, 2, 'Desarrollo de Aplicación de Gestión de Proyectos', '2024-12-07 08:00:00', '2025-06-07 17:00:00', 2, 0),
(13, 2, 'Evaluación de Riesgos Ambientales', '2025-01-22 09:30:00', '2025-07-22 18:30:00', 1, 1),
(14, 3, 'Implementación de Soluciones de Seguridad Informática', '2025-02-11 08:45:00', '2025-08-11 17:45:00', 2, 1),
(15, 3, 'Desarrollo de Aplicación de Realidad Aumentada', '2025-03-03 09:15:00', '2025-09-03 18:15:00', 1, 0),
(16, 3, 'Diseño de Experiencia de Usuario (UX)', '2025-04-18 10:30:00', '2025-10-18 19:30:00', 2, 0),
(17, 1, 'Implementación de Plataforma de E-Learning', '2025-05-09 08:00:00', '2025-11-09 17:00:00', 1, 1),
(18, 2, 'Desarrollo de Sistema de Gestión de Contenidos (CMS)', '2025-06-24 09:30:00', '2025-12-24 18:30:00', 2, 1),
(19, 3, 'Consultoría en Optimización de Procesos', '2025-07-17 10:15:00', '2026-01-17 19:15:00', 1, 0),
(20, 2, 'Desarrollo de Aplicación de Monitoreo Remoto', '2025-08-05 08:45:00', '2026-02-05 17:45:00', 2, 0);

INSERT INTO Trabaja (IDProyecto, IDColaborador) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3),
(9, 3),
(10, 4),
(11, 4),
(12, 4),
(13, 5),
(14, 5),
(15, 5),
(16, 6),
(17, 6),
(18, 6),
(19, 7),
(20, 7);

INSERT INTO Administra (IDColaborador, IDAdministrador, Fecha) VALUES
(1, 3, '2024-04-25 08:00:00'),
(2, 2, '2024-04-25 09:30:00'),
(3, 3, '2024-04-25 10:45:00'),
(4, 4, '2024-04-25 11:20:00'),
(5, 9, '2024-04-25 13:15:00'),
(6, 7, '2024-04-25 14:00:00'),
(7, 2, '2024-04-25 15:30:00'),
(8, 4, '2024-04-25 16:45:00'),
(9, 8, '2024-04-25 17:20:00'),
(10, 8, '2024-04-25 18:00:00');

INSERT INTO Riesgo (IDMedida, Nombre, Fecha, Descripcion, Puntaje, Estatus, Tipo) VALUES
(1, 'Incomprensión de los requisitos del cliente', '2024-04-26', 'El cliente no ha proporcionado información clara y precisa sobre sus necesidades, lo que puede generar retrasos y/o errores en el proyecto.', 8, 1, 3),
(2, 'Retrasos en la entrega del contenido', '2024-04-26', 'Se han producido retrasos en la entrega de contenido por parte de los proveedores o el equipo interno, lo que puede afectar el cronograma del proyecto.', 5, 1, 5),
(3, 'Cambios frecuentes en el diseño', '2024-04-26', 'Se han realizado cambios frecuentes en el diseño del proyecto, lo que puede generar costos adicionales y retrasar la entrega del producto final.', 6, 1, 2),
(4, 'Problemas de compatibilidad de plugins', '2024-04-26', 'Se han encontrado problemas de compatibilidad entre los plugins utilizados en el proyecto, lo que puede afectar el funcionamiento del sitio web o la aplicación.', 8, 1, 4),
(5, 'Problemas de seguridad en el sitio web', '2024-04-26', 'Se han detectado vulnerabilidades de seguridad en el sitio web, lo que puede poner en riesgo los datos de los usuarios.', 9, 1, 6),
(6, 'Fallos en la integración de pasarelas de pago', '2024-04-26', 'Se han producido fallos en la integración de las pasarelas de pago, lo que puede afectar las ventas del negocio.', 6, 1, 1),
(7, 'Aumento inesperado en los costos del proyecto', '2024-04-26', 'Se han producido gastos inesperados en el proyecto, lo que puede afectar la rentabilidad del mismo.', 7, 1, 5),
(8, 'Pérdida de datos o fallo de hosting', '2024-04-26', 'Se ha producido una pérdida de datos o un fallo en el servicio de hosting, lo que puede afectar el funcionamiento del sitio web o la aplicación.', 8, 0, 4),
(9, 'Retrasos en la aprobación del cliente', '2024-04-26', 'Se han producido retrasos en la aprobación del cliente por parte del cliente, lo que puede afectar el cronograma del proyecto.', 7, 1, 2),
(10, 'Dificultades técnicas con WordPress o WooCommerce', '2024-04-26', 'Se han encontrado dificultades técnicas con WordPress o WooCommerce, lo que puede afectar el funcionamiento del sitio web o la tienda online.', 10, 1, 3);


INSERT INTO Medida (IDRiesgo, Nombre, Descripcion, Tipo)
VALUES
(1, 'M1- Reuniones detalladas con el cliente', 'Realizar reuniones detalladas y periódicas con el cliente para comprender a fondo sus necesidades, expectativas y objetivos. Esto ayudará a prevenir malentendidos y a garantizar que el proyecto se alinee con las expectativas del cliente.', 4),
(2, 'M2- Establecer plazos claros y roles para entrega de contenido', 'Establecer plazos claros y roles bien definidos para la entrega de contenido, incluyendo fechas límite, responsabilidades y procesos de aprobación. Esto ayudará a garantizar que el contenido se entregue a tiempo y de acuerdo con las especificaciones del proyecto.', 4),
(3, 'M3- Definir un alcance claro y limitar las revisiones del diseño', 'Definir un alcance claro y bien definido para el proyecto y limitar las revisiones del diseño a cambios esenciales. Esto ayudará a evitar retrasos y costos adicionales debido a cambios frecuentes en los requisitos.', 4),
(4, 'M4- Realizar pruebas de compatibilidad al inicio', 'Realizar pruebas de compatibilidad exhaustivas al inicio del proyecto para identificar y abordar cualquier problema de compatibilidad potencial entre los sistemas, software y hardware utilizados. Esto ayudará a prevenir problemas de integración y garantizar el correcto funcionamiento del proyecto.', 4),
(5, 'M5- Aplicar estándares de seguridad y realizar actualizaciones', 'Implementar y aplicar estándares de seguridad estrictos para proteger los datos del cliente y la información confidencial. Realizar actualizaciones de seguridad regulares para mantener el software y los sistemas protegidos contra las últimas amenazas.', 4),
(6, 'M6- Validar integraciones y tener proveedores de respaldo', 'Validar rigurosamente todas las integraciones con sistemas externos y tener proveedores de respaldo en caso de que un proveedor principal no pueda cumplir con sus obligaciones. Esto ayudará a garantizar la continuidad del proyecto y a minimizar el impacto de cualquier problema con los proveedores.', 4),
(7, 'M7- Monitorear y ajustar el presupuesto continuamente', 'Monitorear el presupuesto del proyecto de cerca y realizar ajustes según sea necesario para garantizar que el proyecto se mantenga dentro del presupuesto. Esto ayudará a evitar sorpresas en el futuro y a garantizar que los recursos se utilicen de manera eficiente.', 4),
(8, 'M8- Implementar estrategias de respaldo y recuperación ante desastres', 'Implementar estrategias de respaldo y recuperación ante desastres para proteger los datos del proyecto y garantizar la continuidad del negocio en caso de un desastre natural o falla del sistema. Esto ayudará a minimizar el tiempo de inactividad y el impacto negativo en el negocio.', 4),
(9, 'M9- Establecer expectativas y procesos claros de aprobación', 'Establecer expectativas claras y procesos de aprobación bien definidos para cambios en el proyecto, incluyendo documentación, revisión y aprobación por parte de las partes interesadas relevantes. Esto ayudará a evitar retrasos y garantizar que todos los cambios se implementen de manera controlada.', 4),
(10, 'M10- Mantenerse actualizado con las últimas versiones y soporte', 'Mantenerse actualizado con las últimas versiones del software y las plataformas utilizadas en el proyecto, y garantizar que se tenga acceso a soporte técnico adecuado. Esto ayudará a prevenir problemas de seguridad y a garantizar que el proyecto funcione correctamente.',4);

ALTER TABLE Riesgo
ADD FOREIGN KEY (IDMedida) REFERENCES Medida(IDMedida);

INSERT INTO Presenta (IDRiesgo, IDProyecto, FechaAsignacion, PonderacionRelativa) VALUES
(1, 1, '2024-01-01', 3),
(2, 2, '2024-02-01', 2),
(3, 1, '2024-03-01', 1),
(1, 2, '2024-04-01', 4),
(5, 3, '2024-05-01', 2),
(6, 3, '2024-06-01', 3),
(7, 3, '2024-07-01', 1),
(8, 1, '2024-08-01', 4),
(9, 1, '2024-09-01', 2),
(10, 2, '2024-10-01', 3),
(2, 3, '2024-11-01', 1),
(2, 4, '2024-12-01', 4),
(2, 1, '2025-01-01', 2),
(1, 3, '2025-02-01', 3),
(3, 2, '2025-03-01', 1),
(7, 2, '2025-04-01', 4),
(9, 4, '2025-05-01', 2),
(8, 4, '2025-06-01', 3),
(6, 4, '2025-07-01', 1),
(7, 1, '2025-08-01', 4);
