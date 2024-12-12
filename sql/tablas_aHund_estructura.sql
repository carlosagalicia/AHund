-- Actualizaciones de las combinaciones de teclas … El jueves, 1 de agosto de 2024, se actualizarán las combinaciones de teclas de Drive para que puedas navegar con las primeras letras.Más información
CREATE DATABASE AHUND;
USE AHUND;

# drop database AHUND;

CREATE TABLE Cliente (
  IDCliente INT NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(64) NOT NULL,
  CorreoElectronico VARCHAR(255) NOT NULL UNIQUE,
  Telefono BIGINT NOT NULL,
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
    Nombre VARCHAR(80) NOT NULL,
    Descripcion VARCHAR(512) NOT NULL,
    Tipo VARCHAR(32) NOT NULL,
    PRIMARY KEY (IDRiesgo)
);

CREATE TABLE Presenta(
    IDRiesgo INT NOT NULL,
    IDProyecto INT NOT NULL,
    FechaAsignacion DATETIME NOT NULL,
    PonderacionRelativa INT NOT NULL,
    Medidas VARCHAR(255) NOT NULL,
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

CREATE TABLE proyectoslog(
    IDProyecto INT,
    PonderacionRelativaTotal INT,
    Fecha TIMESTAMP
);

CREATE TABLE proyectosriesgolog(
    IDProyecto INT,
    IDRiesgo INT,
    PonderacionRelativaTotal INT,
    Fecha TIMESTAMP,
    Nombre VARCHAR(80)
);

# ============================================Triggers, Procedures y Eventos=================================
# Procedure para INSERT de proyecto

CREATE PROCEDURE InsertProjectWithClientCheck(
    IN P_Nombre_Proyecto VARCHAR(80),
    IN P_FechaInicio DATETIME,
    IN P_FechaFinal DATETIME,
    IN P_Tipo VARCHAR(32),
    IN P_Estado BOOLEAN,
    IN P_Nombre_Cliente VARCHAR(64),
    IN P_CorreoElectronico VARCHAR(255),
    IN P_Telefono BIGINT,
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

CREATE PROCEDURE UpdateProjectWithClientCheck(
    in p_IDProyecto INT,
    in p_IDCliente INT,
    IN P_Nombre_Proyecto VARCHAR(80),
    IN P_FechaInicio DATETIME,
    IN P_FechaFinal DATETIME,
    IN P_Tipo VARCHAR(32),
    IN P_Estado BOOLEAN,
    IN P_Nombre_Cliente VARCHAR(64),
    IN P_CorreoElectronico VARCHAR(255),
    IN P_Telefono BIGINT,
    IN P_Descripcion VARCHAR(512)
)
BEGIN

    UPDATE Proyecto
    SET Nombre = P_Nombre_Proyecto, FechaInicio = P_FechaInicio, FechaFinal = P_FechaFinal, Tipo = P_Tipo, Estado = P_Estado
    WHERE IDProyecto = p_IDProyecto;

    UPDATE Cliente
    SET CorreoElectronico = P_CorreoElectronico, Nombre = P_Nombre_Cliente, Telefono = P_Telefono, Descripcion = P_Descripcion
    WHERE IDCliente = p_IDCliente;
END;

#Procedure para registrar colaborador
CREATE PROCEDURE InsertUser(
    IN idAdmin INT,
    IN username VARCHAR(32),
    IN password VARCHAR(255),
    IN name VARCHAR(40),
    IN APaterno VARCHAR(40),
    IN AMaterno VARCHAR(40),
    IN correo VARCHAR(32)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    BEGIN
        INSERT INTO Usuario (Usuario, Contrasena, Nombre, ApellidoPaterno, ApellidoMaterno, CorreoElectronico)
        VALUES(username,password, name, APaterno, AMaterno, correo);

        INSERT INTO administra (IDColaborador, IDAdministrador)
        VALUES ((SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo), idAdmin);

        INSERT INTO AdministraLog (IDUsuario, IDCorreoColab, IDAdministrador, Event)
        VALUES (
            (SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo),
            correo, idAdmin, 'INSERT');

        INSERT INTO posee (IDUsuario, IDRol)
        VALUES ((SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo), 2);

        COMMIT;
    END;
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
        DECLARE userID INT;

        -- Obtener el ID del usuario basado en el correo electrónico
        SELECT IDUsuario INTO userID FROM Usuario WHERE CorreoElectronico = correo;

        IF EXISTS (SELECT 1 FROM Administra WHERE IDColaborador = userID AND IDAdministrador = idAdmin) THEN
            -- Si existe, actualizar la fecha
            UPDATE Administra
            SET Fecha = CURRENT_TIMESTAMP
            WHERE IDColaborador = userID AND IDAdministrador = idAdmin;
        ELSE
            -- Si no existe, insertar un nuevo registro
            INSERT INTO Administra (IDColaborador, IDAdministrador)
            VALUES (userID, idAdmin);
        END IF;

        INSERT INTO AdministraLog (IDUsuario, IDCorreoColab, IDAdministrador, Event)
        VALUES (userID,correo, idAdmin, 'DELETE');

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
        DECLARE userID INT;

        -- Obtener el ID del usuario basado en el correo electrónico
        SELECT IDUsuario INTO userID FROM Usuario WHERE CorreoElectronico = correo;

        IF EXISTS (SELECT 1 FROM Administra WHERE IDColaborador = userID AND IDAdministrador = idAdmin) THEN
            -- Si existe, actualizar la fecha
            UPDATE Administra
            SET Fecha = CURRENT_TIMESTAMP
            WHERE IDColaborador = userID AND IDAdministrador = idAdmin;
        ELSE
            -- Si no existe, insertar un nuevo registro
            INSERT INTO Administra (IDColaborador, IDAdministrador)
            VALUES (userID, idAdmin);
        END IF;

        INSERT INTO AdministraLog (IDUsuario, IDCorreoColab, IDAdministrador, Event)
        VALUES (userID,correo, idAdmin, 'PUT');

        UPDATE posee
        SET IDRol = 1
        WHERE IDUsuario = (SELECT IDUsuario FROM Usuario WHERE CorreoElectronico = correo);

        COMMIT;
    END;
END;

# Procedure para Eliminar Proyecto
CREATE PROCEDURE DeleteProject(IN proyectoID INT)
BEGIN
 DELETE FROM Presenta WHERE  IDProyecto = proyectoID;
 DELETE FROM Trabaja WHERE  IDProyecto = proyectoID;
 DELETE FROM Proyecto WHERE IDProyecto = proyectoID;
END;

CREATE PROCEDURE GetProjects(
    IN estado_param INT,
    IN filtro_param VARCHAR(50),
    IN limite_param INT,
    IN offset_param INT,
    IN userId_param INT
)
BEGIN
    SELECT
        proyecto.IDProyecto,
        trabaja.IDColaborador,
        proyecto.IDCliente,
        proyecto.Nombre,
        proyecto.FechaInicio,
        proyecto.FechaFinal,
        proyecto.Tipo,
        proyecto.Estado,
        COALESCE(SUM(presenta.PonderacionRelativa), 0) AS PonderacionRelativaTotal
    FROM
        proyecto
    LEFT JOIN
        presenta ON proyecto.IDProyecto = presenta.IDProyecto
    LEFT JOIN
        trabaja ON proyecto.IDProyecto = trabaja.IDProyecto AND trabaja.IDColaborador = userId_param
    WHERE
        proyecto.Estado = estado_param
    GROUP BY
        proyecto.IDProyecto,
        proyecto.IDCliente,
        proyecto.Nombre,
        proyecto.FechaInicio,
        proyecto.FechaFinal,
        proyecto.Tipo,
        proyecto.Estado,
        trabaja.IDColaborador
    ORDER BY
        CASE
            WHEN filtro_param = 'recent' THEN proyecto.FechaInicio
            ELSE NULL
        END DESC,
        CASE
            WHEN filtro_param = 'older' THEN proyecto.FechaInicio
            ELSE NULL
        END ASC,
        CASE
            WHEN filtro_param = 'higher' THEN COALESCE(SUM(presenta.PonderacionRelativa), 0)
            ELSE NULL
        END DESC,
        CASE
            WHEN filtro_param = 'assigned' THEN trabaja.IDColaborador
            ELSE NULL
        END DESC,
        proyecto.IDProyecto ASC
    LIMIT limite_param OFFSET offset_param;
END;


CREATE PROCEDURE HighlightProject(
    IN P_IDProyecto INT,
    IN U_IDUsuario INT
)
BEGIN
    DECLARE usuarioID INT;

    -- Verificar si el usuario ya existe en la tabla Trabaja
    SELECT IDColaborador INTO usuarioID FROM Trabaja WHERE IDColaborador = U_IDUsuario AND IDProyecto = P_IDProyecto;

    IF usuarioID IS NOT NULL THEN
        -- Si el usuario existe, eliminar el registro correspondiente
        DELETE FROM Trabaja WHERE IDColaborador = U_IDUsuario AND IDProyecto = P_IDProyecto;
    ELSE
        INSERT INTO Trabaja (IDProyecto, IDColaborador)
        VALUES (P_IDProyecto, U_IDUsuario);
    END IF;
END;

CREATE PROCEDURE InsertRisk(
    IN R_Nombre VARCHAR(80),
    IN R_Descripcion VARCHAR(512),
    IN R_Tipo VARCHAR(32)
)
BEGIN
    DECLARE riskID INT;

    -- Verificar si el riesgo ya existe
    SELECT IDRiesgo INTO riskID FROM RIESGO WHERE Nombre = R_Nombre;

    -- Si el riesgo no existe
    IF riskID IS NULL THEN
        INSERT INTO Riesgo (Nombre, Descripcion, Tipo)
        VALUES (R_Nombre, R_Descripcion, R_Tipo);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Risk with the same ID already exists';
    END IF;
END;

CREATE PROCEDURE InsertRiskProyect()
BEGIN
    DECLARE riskID INT;
    DECLARE projectID INT;
    DECLARE pondVal INT;
    DECLARE name VARCHAR(80);
    DECLARE dateReg DATETIME;
    DECLARE done BOOLEAN DEFAULT FALSE;

    -- Declare the cursor for selecting risk information
    DECLARE riskInfo CURSOR FOR
        SELECT
            Presenta.IDRiesgo,
            Presenta.IDProyecto,
            Presenta.PonderacionRelativa,
            R.Nombre
        FROM Presenta
        JOIN Riesgo R ON Presenta.IDRiesgo = R.IDRiesgo;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN riskInfo;

    read_loop: LOOP
        -- Fetch the first row from the cursor
        FETCH riskInfo INTO riskID, projectID, pondVal, name;

        IF done IS TRUE THEN LEAVE read_loop;
        END IF;

        -- Get the current date and time for the "Fecha" field
        SET dateReg = CONCAT(CURRENT_DATE(), ' 23:59:00');

        -- Insert the first fetched row into the proyectoriesgolog table
        INSERT INTO proyectosriesgolog(IDProyecto, IDRiesgo, PonderacionRelativaTotal, Fecha, Nombre)
        VALUES (projectID, riskID, pondVal, dateReg, name);
    end LOOP;

    -- Close the cursor
    CLOSE riskInfo;
END;

# Evento para registrar la ponderacion diaria de los proyectos
CREATE EVENT IF NOT EXISTS ActualizarBitacoraPonderacion
ON SCHEDULE EVERY 1 DAY STARTS '2024-05-25 23:59:00'
DO
BEGIN
    INSERT INTO proyectoslog (IDProyecto, PonderacionRelativaTotal, Fecha)
    SELECT
        SelectAll.IDProyecto,
        COALESCE(SUM(presenta.PonderacionRelativa), 0) AS PonderacionRelativaTotal,
        CONCAT(CURRENT_DATE(), ' 23:59:00') AS Fecha
    FROM (
        SELECT *
        FROM proyecto
        WHERE Estado = 1  -- Sustituye con el estado que corresponda
    ) AS SelectAll
    LEFT JOIN presenta ON SelectAll.IDProyecto = presenta.IDProyecto
    GROUP BY SelectAll.IDProyecto;
END;

# Evento para registrar la ponderacion diaria de los proyectos
CREATE EVENT IF NOT EXISTS ActualizarBitacoraRiesgos
ON SCHEDULE EVERY 1 DAY STARTS '2024-05-25 23:59:00'
DO
CALL InsertRiskProyect();

# Procedure Editar Perfil
CREATE PROCEDURE EditProfile(
	in P_IDUsuario INT,
    IN P_CorreoElectronico VARCHAR(32),
    IN P_Nombre VARCHAR(40),
    IN P_ApellidoPaterno VARCHAR(40),
    IN P_ApellidoMaterno VARCHAR(40),
    in P_Contrasena VARCHAR(255)
)
begin
    -- Si esta la contraseña
    IF P_Contrasena IS NULL or P_Contrasena = '' THEN
        update usuario
        set CorreoElectronico = P_CorreoElectronico,
	        Nombre = P_Nombre,
	        ApellidoPaterno = P_ApellidoPaterno,
	        ApellidoMaterno = P_ApellidoMaterno
        where IDUsuario = P_IDUsuario;
    ELSE
        update usuario
        set CorreoElectronico = P_CorreoElectronico,
	        Nombre = P_Nombre,
	        ApellidoPaterno = P_ApellidoPaterno,
	        ApellidoMaterno = P_ApellidoMaterno,
	        Contrasena = P_Contrasena
        where IDUsuario = P_IDUsuario;
    END IF;
END;

# ===========================================================================================

INSERT INTO Usuario (Usuario, Contrasena, Nombre, ApellidoPaterno, ApellidoMaterno, CorreoElectronico) VALUES
('admin', '$2a$12$3lNHRPH2w.rb6KHaD3cj1elQL9PbVbr6VMbaI9Rp3HmMPIsEenSJW', 'admin', 'admin', 'admin', 'admin@appix.mx'),
('colab', '$2a$12$iUu4FfihSdUWKOdtwnwSP.EiyZZYSYEOIjb/pZGMCxSeOIzybPLYG', 'colab', 'colab', 'colab', 'colab@appix.mx');

INSERT INTO Rol (IDRol, Nombre) VALUES
(1, 'Administrador'),
(2, 'Colaborador');

INSERT INTO Posee (IDUsuario, IDRol) VALUES
(1,1),
(2,2);