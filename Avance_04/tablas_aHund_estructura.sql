CREATE DATABASE AHUND;
USE AHUND;

# drop database AHUND;

CREATE TABLE Cliente (
  IDCliente INT NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(64) NOT NULL,
  CorreoElectronico VARCHAR(255) NOT NULL UNIQUE,
  Telefono VARCHAR(20) NOT NULL,
  Descripcion VARCHAR(512) NOT NULL,
  PRIMARY KEY (IDCliente)
);

CREATE TABLE Usuario (
  IDUsuario INT NOT NULL AUTO_INCREMENT,
  Usuario VARCHAR(32) NOT NULL,
  Contrasena VARCHAR(255) NOT NULL,
  Nombre VARCHAR(40) NOT NULL,
  ApellidoPaterno VARCHAR(40) NOT NULL,
  ApellidoMaterno VARCHAR(40) NOT NULL,
  CorreoElectronico VARCHAR(32) NOT NULL UNIQUE,
  PRIMARY KEY (IDUsuario)
);

CREATE TABLE Proyecto(
	IDProyecto INT NOT NULL AUTO_INCREMENT,
    IDCliente INT NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    FechaInicio DATETIME NOT NULL,
    FechaFinal DATETIME NOT NULL,
    Tipo VARCHAR(32) NOT NULL ,
    Estado BOOLEAN NOT NULL ,
    PRIMARY KEY (IDProyecto),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);

CREATE TABLE Trabaja(
    IDProyecto INT NOT NULL,
    IDColaborador INT NOT NULL,
    PRIMARY KEY (IDProyecto, IDColaborador),
    FOREIGN KEY (IDProyecto) REFERENCES Proyecto(IDProyecto),
    FOREIGN KEY (IDColaborador) REFERENCES Usuario(IDUsuario) ON DELETE CASCADE
);

CREATE TABLE Administra(
    IDColaborador INT NOT NULL,
    IDAdministrador INT NOT NULL,
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (IDColaborador, IDAdministrador),
    FOREIGN KEY (IDColaborador) REFERENCES Usuario(IDUsuario) ON DELETE CASCADE ,
    FOREIGN KEY (IDAdministrador) REFERENCES Usuario(IDUsuario)
);

CREATE TABLE AdministraLog (
    IDBitacora INT AUTO_INCREMENT PRIMARY KEY,
    IDUsuario INT NOT NULL ,
    IDCorreoColab VARCHAR(32) NOT NULL,
    IDAdministrador INT NOT NULL,
    Event VARCHAR(32) NOT NULL,
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Modifica(
    IDProyecto INT NOT NULL,
    IDAdministrador INT NOT NULL,
    Fecha DATETIME NOT NULL,
    PRIMARY KEY (IDProyecto, IDAdministrador),
    FOREIGN KEY (IDProyecto) REFERENCES Proyecto(IDProyecto) ON DELETE CASCADE,
    FOREIGN KEY (IDAdministrador) REFERENCES Usuario(IDUsuario)
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
ADD FOREIGN KEY (IDRiesgo) REFERENCES Riesgo(IDRiesgo) ON DELETE CASCADE;


CREATE TABLE Presenta(
    IDRiesgo INT NOT NULL,
    IDProyecto INT NOT NULL,
    FechaAsignacion DATETIME NOT NULL,
    PonderacionRelativa INT NOT NULL,
    PRIMARY KEY (IDProyecto, IDRiesgo),
    FOREIGN KEY (IDProyecto) REFERENCES Proyecto(IDProyecto),
    FOREIGN KEY (IDRiesgo) REFERENCES Riesgo(IDRiesgo) ON DELETE CASCADE
);

CREATE TABLE Rol(
    IDRol INT NOT NULL,
    Nombre VARCHAR(32) NOT NULL,
    PRIMARY KEY (IDRol)
);

CREATE TABLE Privilegio(
    IDPrivilegio INT NOT NULL,
    Nombre VARCHAR(32) NOT NULL,
    PRIMARY KEY (IDPrivilegio)
);

CREATE TABLE Posee(
    IDUsuario INT NOT NULL,
    IDRol INT NOT NULL,
    PRIMARY KEY (IDUsuario, IDRol),
    FOREIGN KEY (IDRol) REFERENCES Rol(IDRol),
    FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario) ON DELETE CASCADE
);

CREATE TABLE Asocia(
    IDPrivilegio INT NOT NULL,
    IDRol INT NOT NULL,
    PRIMARY KEY (IDPrivilegio, IDRol),
    FOREIGN KEY (IDRol) REFERENCES Rol(IDRol),
    FOREIGN KEY (IDPrivilegio) REFERENCES Privilegio(IDPrivilegio) ON DELETE CASCADE
);

# ================================================Triggers y Procedures=====================================
# Procedure para INSERT de proyecto

CREATE PROCEDURE InsertProjectWithClientCheck(
    IN P_Nombre_Proyecto VARCHAR(80),
    IN P_FechaInicio DATETIME,
    IN P_FechaFinal DATETIME,
    IN P_Tipo VARCHAR(32),
    IN P_Estado BOOLEAN,
    IN P_Nombre_Cliente VARCHAR(64),
    IN P_CorreoElectronico VARCHAR(255),
    IN P_Telefono VARCHAR(20),
    IN P_Descripcion VARCHAR(512)
)
BEGIN
    DECLARE clienteID INT;

    -- Verificar si el cliente ya existe
    SELECT IDCliente INTO clienteID FROM Cliente WHERE CorreoElectronico = P_CorreoElectronico;

    -- Si el cliente existe, asignar su IDCliente al proyecto
    IF clienteID IS NOT NULL THEN
        INSERT INTO Proyecto (IDCliente, Nombre, FechaInicio, FechaFinal, Tipo, Estado)
        VALUES (clienteID, P_Nombre_Proyecto, P_FechaInicio, P_FechaFinal, P_Tipo, P_Estado);
    ELSE
        -- Si el cliente no existe, insertarlo en la tabla Cliente y obtener su nuevo IDCliente
        INSERT INTO Cliente (Nombre, CorreoElectronico, Telefono, Descripcion)
        VALUES (P_Nombre_Cliente, P_CorreoElectronico, P_Telefono, P_Descripcion);
        SET clienteID = LAST_INSERT_ID();

        -- Insertar el proyecto con el nuevo IDCliente
        INSERT INTO Proyecto (IDCliente, Nombre, FechaInicio, FechaFinal, Tipo, Estado)
        VALUES (clienteID, P_Nombre_Proyecto, P_FechaInicio, P_FechaFinal, P_Tipo, P_Estado);
    END IF;
END;

# Procedure para Eliminacion de Colaborador
CREATE PROCEDURE DeleteUsuario(IN idAdmin INT, IN correo VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    BEGIN
        INSERT INTO administra (IDColaborador, IDAdministrador)
        VALUES ((SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo), idAdmin);

        INSERT INTO AdministraLog (IDUsuario, IDCorreoColab, IDAdministrador, Event)
        VALUES (
            (SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo),
            correo, idAdmin, 'DELETE');

        DELETE FROM Usuario WHERE CorreoElectronico = correo;

        COMMIT;
    END;
END;

CREATE PROCEDURE AddAdmin(IN idAdmin INT, IN correo VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    BEGIN
        INSERT INTO administra (IDColaborador, IDAdministrador)
        VALUES ((SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo), idAdmin);

        INSERT INTO AdministraLog (IDUsuario, IDCorreoColab, IDAdministrador, Event)
        VALUES (
            (SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo),
            correo, idAdmin, 'PUT');

        UPDATE posee
        SET IDRol = 1
        WHERE IDUsuario = (SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo);

        COMMIT;
    END;
END;

# ===========================================================================================

INSERT INTO Cliente (Nombre, CorreoElectronico, Telefono, Descripcion) VALUES
('Juan Perez', 'juan_perez@gmail.com', '1234567890', 'Descripción cliente 1'),
('Maria Garcia', 'maria_garcia@gmail.com', '2345678901', 'Descripción cliente 2'),
('Carlos Martinez', 'carlos_martinez@gmail.com', '3456789012', 'Descripción cliente 3'),
('Ana Lopez', 'ana_lopez@gmail.com', '4567890123', 'Descripción cliente 4'),
('Pedro Sanchez', 'pedro_sanchez@gmail.com', '5678901234', 'Descripción cliente 5'),
('Laura Rodriguez', 'laura_rodriguez@gmail.com', '6789012345', 'Descripción cliente 6'),
('Miguel Gomez', 'miguel_gomez@gmail.com', '7890123456', 'Descripción cliente 7'),
('Elena Hernandez', 'elena_hernandez@gmail.com', '8901234567', 'Descripción cliente 8'),
('David Fernandez', 'david_fernandez@gmail.com', '9012345678', 'Descripción cliente 9'),
('Sofia Diaz', 'sofia_diaz@gmail.com', '1234567890', 'Descripción cliente 10'),
('Diego Martinez', 'diego_martinez@gmail.com', '2345678901', 'Descripción cliente 11'),
('Lucia Gonzalez', 'lucia_gonzalez@gmail.com', '3456789012', 'Descripción cliente 12'),
('Javier Gomez', 'javier_gomez@gmail.com', '4567890123', 'Descripción cliente 13'),
('Paula Perez', 'paula_perez@gmail.com', '5678901234', 'Descripción cliente 14'),
('Alejandro Lopez', 'alejandro_lopez@gmail.com', '6789012345', 'Descripción cliente 15'),
('Marta Hernandez', 'marta_hernandez@gmail.com', '7890123456', 'Descripción cliente 16'),
('Raul Diaz', 'raul_diaz@gmail.com', '8901234567', 'Descripción cliente 17'),
('Carmen Rodriguez', 'carmen_rodriguez@gmail.com', '9012345678', 'Descripción cliente 18'),
('Roberto Garcia', 'roberto_garcia@gmail.com', '1234567890', 'Descripción cliente 19'),
('Isabel Sanchez', 'isabel_sanchez@gmail.com', '2345678901', 'Descripción cliente 20');

INSERT INTO Usuario (Usuario, Contrasena, Nombre, ApellidoPaterno, ApellidoMaterno, CorreoElectronico) VALUES
('jdoe', 'contrasena123', 'John', 'Doe', 'González', 'john.doe@appix.mx'),
('lsmith', 'password321', 'Linda', 'Smith', 'Martínez', 'linda.smith@appix.mx'),
( 'mgonzalez', 'pass1234', 'Mario', 'González', 'López', 'mario.gonzalez@appix.mx'),
( 'jrodriguez', 'secretword', 'Julia', 'Rodríguez', 'Sánchez', 'julia.rodriguez@appix.mx'),
('rwilliams', 'securepass', 'Robert', 'Williams', 'Fernández', 'robert.williams@appix.mx'),
( 'slee', 'password123', 'Sophia', 'Lee', 'Hernández', 'sophia.lee@appix.mx'),
( 'jjones', 'adminpass', 'Jennifer', 'Jones', 'García', 'jennifer.jones@appix.mx'),
( 'mlopez', 'pass12345', 'Miguel', 'López', 'Rodríguez', 'miguel.lopez@appix.mx'),
( 'ppatel', 'patelpass', 'Priya', 'Patel', 'Fernández', 'priya.patel@appix.mx'),
( 'jgarcia', 'garcia123', 'Jorge', 'García', 'Martínez', 'jorge.garcia@appix.mx'),
( 'afernandez', 'fernandez123', 'Ana', 'Fernández', 'López', 'ana.fernandez@appix.mx'),
( 'cjackson', 'jacksonpass', 'Christopher', 'Jackson', 'Sánchez', 'christopher.jackson@appix.mx'),
( 'krodriguez', 'rodriguezpass', 'Karen', 'Rodríguez', 'Hernández', 'karen.rodriguez@appix.mx'),
( 'tmiller', 'millerpass', 'Taylor', 'Miller', 'Martínez', 'taylor.miller@appix.mx'),
( 'asanchez', 'passsanchez', 'Alicia', 'Sánchez', 'Fernández', 'alicia.sanchez@appix.mx'),
( 'wlee', 'leepass', 'William', 'Lee', 'González', 'william.lee@appix.mx'),
( 'rlopez', 'rlopezpass', 'Rebecca', 'López', 'Hernández', 'rebecca.lopez@appix.mx'),
( 'ksmith', 'smith123', 'Kevin', 'Smith', 'García', 'kevin.smith@appix.mx'),
( 'vfernandez', 'vfernandezpass', 'Victoria', 'Fernández', 'Martínez', 'victoria.fernandez@appix.mx'),
( 'mgonzalez2', 'gonzalezpass', 'María', 'González', 'López', 'maria.gonzalez@appix.mx'),
('maverick', 'claveM4v3r1ck', 'Maverick', 'Smith', 'Jones', 'maverick@appix.mx'),
('scarlet', 'c0ntr4s3ñaS@r1et', 'Scarlet', 'Johnson', 'Williams', 'scarlet@appix.mx'),
('shadow', 'p@ssw0rdSh@d0w', 'Shadow', 'Brown', 'Davis', 'shadow@appix.mx'),
('blaze', 'bl4zeP@ssw0rd', 'Blaze', 'Miller', 'Taylor', 'blaze@appix.mx'),
('phoenix', 'ph03n1xK3y', 'Phoenix', 'Wilson', 'Anderson', 'phoenix@appix.mx'),
('thunder', 'T@z3rB0lt', 'Thunder', 'Martinez', 'Thomas', 'thunder@appix.mx'),
('storm', 'Str0m@cc3ss', 'Storm', 'Lee', 'Hernandez', 'storm@appix.mx'),
('blitz', 'Bl1tzKrieg!', 'Blitz', 'Taylor', 'Clark', 'blitz@appix.mx'),
('raven', 'R@v3nCl@w', 'Raven', 'Garcia', 'Lewis', 'raven@appix.mx'),
('viper', 'V1p3rP@ss', 'Viper', 'Rodriguez', 'Walker', 'viper@appix.mx'),
('echo', 'EchoP@ssw0rd', 'Echo', 'Harris', 'King', 'echo@appix.mx'),
('jinx', 'J1nxP@ss', 'Jinx', 'Young', 'Scott', 'jinx@appix.mx'),
('blade', 'Bl@d3P@ss', 'Blade', 'Allen', 'Green', 'blade@appix.mx'),
('mystic', 'Myst1cK3y', 'Mystic', 'Wright', 'Adams', 'mystic@appix.mx'),
('phantom', 'Ph@nt0mP@ss', 'Phantom', 'Phillips', 'Evans', 'phantom@appix.mx'),
('specter', 'Sp3ct3rP@ss', 'Specter', 'Carter', 'Baker', 'specter@appix.mx'),
('nova', 'N0v@P@ss', 'Nova', 'Perez', 'Rivera', 'nova@appix.mx'),
('blizzard', 'Bl1zz@rdP@ss', 'Blizzard', 'Sanchez', 'Torres', 'blizzard@appix.mx'),
('zenith', 'Z3n1thK3y!', 'Zenith', 'Scott', 'Ramirez', 'zenith@appix.mx'),
('luna', 'Lun@P@ssw0rd', 'Luna', 'Gomez', 'Parker', 'luna@appix.mx');

INSERT INTO Proyecto (IDCliente, Nombre, FechaInicio, FechaFinal, Tipo, Estado) VALUES
(1, 'Desarrollo de Aplicación Móvil', '2024-01-15 09:00:00', '2024-07-15 18:00:00', 'Aplicación Móvil', 1),
(2, 'Implementación de Sistema de Gestión', '2024-02-01 08:30:00', '2024-08-01 17:30:00', 'Diseño', 1),
(3, 'Diseño de Campaña Publicitaria', '2024-03-10 10:00:00', '2024-09-10 19:00:00', 'Aplicación Móvil', 0),
(4, 'Desarrollo de Plataforma E-Commerce', '2024-04-05 09:30:00', '2024-10-05 18:30:00', 'Diseño', 0),
(5, 'Consultoría en Estrategia de Marketing', '2024-05-20 10:00:00', '2024-11-20 19:00:00', 'Aplicación Web', 1),
(6, 'Diseño de Identidad Corporativa', '2024-06-02 08:00:00', '2024-12-02 17:00:00', 'Diseño', 1),
(7, 'Desarrollo de Software a Medida', '2024-07-12 09:30:00', '2025-01-12 18:30:00', 'Aplicación Móvil', 0),
(8, 'Implementación de Sistema ERP', '2024-08-25 08:00:00', '2025-02-25 17:00:00', 'Diseño', 0),
(9, 'Asesoría en Gestión de Recursos Humanos', '2024-09-14 10:00:00', '2025-03-14 19:00:00', 'Aplicación Web', 1),
(10, 'Desarrollo de Sitio Web Corporativo', '2024-10-30 08:30:00', '2025-04-30 17:30:00', 'Diseño', 1),
(11, 'Consultoría en Finanzas Empresariales', '2024-11-18 09:00:00', '2025-05-18 18:00:00', 'Aplicación Móvil', 0),
(12, 'Desarrollo de Aplicación de Gestión de Proyectos', '2024-12-07 08:00:00', '2025-06-07 17:00:00', 'Diseño', 0),
(13, 'Evaluación de Riesgos Ambientales', '2025-01-22 09:30:00', '2025-07-22 18:30:00', 'Aplicación Web', 1),
(14, 'Implementación de Soluciones de Seguridad Informática', '2025-02-11 08:45:00', '2025-08-11 17:45:00', 'Diseño', 1),
(15, 'Desarrollo de Aplicación de Realidad Aumentada', '2025-03-03 09:15:00', '2025-09-03 18:15:00', 'Aplicación Móvil', 0),
(16, 'Diseño de Experiencia de Usuario (UX)', '2025-04-18 10:30:00', '2025-10-18 19:30:00', 'Diseño', 0),
(17, 'Implementación de Plataforma de E-Learning', '2025-05-09 08:00:00', '2025-11-09 17:00:00', 'Aplicación Web', 1),
(18, 'Desarrollo de Sistema de Gestión de Contenidos (CMS)', '2025-06-24 09:30:00', '2025-12-24 18:30:00', 'Diseño', 1),
(19, 'Consultoría en Optimización de Procesos', '2025-07-17 10:15:00', '2026-01-17 19:15:00', 'Aplicación Móvil', 0),
(20, 'Desarrollo de Aplicación de Monitoreo Remoto', '2025-08-05 08:45:00', '2026-02-05 17:45:00', 'Diseño', 0);

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

INSERT INTO Modifica (IDProyecto, IDAdministrador, Fecha) VALUES
(1, 25, '2024-01-15 09:00:00'),
(2, 30, '2024-02-01 08:30:00'),
(3, 22, '2024-03-10 10:00:00'),
(4, 26, '2024-04-05 09:30:00'),
(5, 21, '2024-05-20 10:00:00'),
(6, 28, '2024-06-02 08:00:00'),
(7, 35, '2024-07-12 09:30:00'),
(8, 31, '2024-08-25 08:00:00'),
(9, 27, '2024-09-14 10:00:00'),
(10, 29, '2024-10-30 08:30:00'),
(11, 34, '2024-11-18 09:00:00'),
(12, 32, '2024-12-07 08:00:00'),
(13, 36, '2025-01-22 09:30:00'),
(14, 38, '2025-02-11 08:45:00'),
(15, 37, '2025-03-03 09:15:00'),
(16, 33, '2025-04-18 10:30:00'),
(17, 24, '2025-05-09 08:00:00'),
(18, 23, '2025-06-24 09:30:00'),
(19, 39, '2025-07-17 10:15:00'),
(20, 40, '2025-08-05 08:45:00');

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
ADD FOREIGN KEY (IDMedida) REFERENCES Medida(IDMedida) ON DELETE CASCADE ;

INSERT INTO Presenta (IDRiesgo, IDProyecto, FechaAsignacion, PonderacionRelativa) VALUES
(1, 1, '2024-01-01', 3),
(2, 2, '2024-02-01', 2),
(3, 1, '2024-01-03', 1),
(1, 2, '2024-04-01', 4),
(5, 3, '2024-05-01', 2),
(6, 3, '2024-06-01', 3),
(7, 3, '2024-07-01', 1),
(8, 1, '2024-01-05', 4),
(9, 1, '2024-01-06', 2),
(10, 2, '2024-10-01', 3),
(2, 3, '2024-11-01', 1),
(2, 4, '2024-12-01', 4),
(2, 1, '2024-01-02', 2),
(1, 3, '2025-02-01', 3),
(3, 2, '2025-03-01', 1),
(7, 2, '2025-04-01', 4),
(9, 4, '2025-05-01', 2),
(8, 4, '2025-06-01', 3),
(6, 4, '2025-07-01', 1),
(7, 1, '2024-01-04', 4);

INSERT INTO Rol (IDRol, Nombre) VALUES
(1, 'Administrador'),
(2, 'Colaborador');

INSERT INTO Privilegio (IDPrivilegio, Nombre) VALUES
(1, 'Consultar'),
(2, 'Registrar'),
(3, 'Modificar'),
(4, 'Eliminar');

INSERT INTO Posee (IDUsuario, IDRol) VALUES
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1);

INSERT INTO Asocia (IDPrivilegio, IDRol) VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 1);

