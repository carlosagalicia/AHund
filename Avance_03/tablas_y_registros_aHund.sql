-- MySQL dump 10.13  Distrib 8.3.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: ahund
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administra`
--

DROP TABLE IF EXISTS `administra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administra` (
  `IDColaborador` int NOT NULL,
  `IDAdministrador` int NOT NULL,
  `Fecha` datetime NOT NULL,
  PRIMARY KEY (`IDColaborador`,`IDAdministrador`),
  KEY `IDAdministrador` (`IDAdministrador`),
  CONSTRAINT `administra_ibfk_1` FOREIGN KEY (`IDColaborador`) REFERENCES `colaborador` (`IDColaborador`),
  CONSTRAINT `administra_ibfk_2` FOREIGN KEY (`IDAdministrador`) REFERENCES `administrador` (`IDColaborador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administra`
--

LOCK TABLES `administra` WRITE;
/*!40000 ALTER TABLE `administra` DISABLE KEYS */;
INSERT INTO `administra` VALUES (1,3,'2024-04-25 08:00:00'),(2,2,'2024-04-25 09:30:00'),(3,3,'2024-04-25 10:45:00'),(4,4,'2024-04-25 11:20:00'),(5,9,'2024-04-25 13:15:00'),(6,7,'2024-04-25 14:00:00'),(7,2,'2024-04-25 15:30:00'),(8,4,'2024-04-25 16:45:00'),(9,8,'2024-04-25 17:20:00'),(10,8,'2024-04-25 18:00:00');
/*!40000 ALTER TABLE `administra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `IDColaborador` int NOT NULL AUTO_INCREMENT,
  `Usuario` varchar(32) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `Nombre` varchar(40) NOT NULL,
  `ApellidoPaterno` varchar(40) NOT NULL,
  `ApellidoMaterno` varchar(40) NOT NULL,
  `CorreoElectronico` varchar(32) NOT NULL,
  `PermisoAdmin` tinyint(1) NOT NULL,
  PRIMARY KEY (`IDColaborador`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES (1,'maverick','claveM4v3r1ck','Maverick','Smith','Jones','maverick@appix.mx',1),(2,'scarlet','c0ntr4s3ñaS@r1et','Scarlet','Johnson','Williams','scarlet@appix.mx',1),(3,'shadow','p@ssw0rdSh@d0w','Shadow','Brown','Davis','shadow@appix.mx',1),(4,'blaze','bl4zeP@ssw0rd','Blaze','Miller','Taylor','blaze@appix.mx',1),(5,'phoenix','ph03n1xK3y','Phoenix','Wilson','Anderson','phoenix@appix.mx',1),(6,'thunder','T@z3rB0lt','Thunder','Martinez','Thomas','thunder@appix.mx',1),(7,'storm','Str0m@cc3ss','Storm','Lee','Hernandez','storm@appix.mx',1),(8,'blitz','Bl1tzKrieg!','Blitz','Taylor','Clark','blitz@appix.mx',1),(9,'raven','R@v3nCl@w','Raven','Garcia','Lewis','raven@appix.mx',1),(10,'viper','V1p3rP@ss','Viper','Rodriguez','Walker','viper@appix.mx',1),(11,'echo','EchoP@ssw0rd','Echo','Harris','King','echo@appix.mx',1),(12,'jinx','J1nxP@ss','Jinx','Young','Scott','jinx@appix.mx',1),(13,'blade','Bl@d3P@ss','Blade','Allen','Green','blade@appix.mx',1),(14,'mystic','Myst1cK3y','Mystic','Wright','Adams','mystic@appix.mx',1),(15,'phantom','Ph@nt0mP@ss','Phantom','Phillips','Evans','phantom@appix.mx',1),(16,'specter','Sp3ct3rP@ss','Specter','Carter','Baker','specter@appix.mx',1),(17,'nova','N0v@P@ss','Nova','Perez','Rivera','nova@appix.mx',1),(18,'blizzard','Bl1zz@rdP@ss','Blizzard','Sanchez','Torres','blizzard@appix.mx',1),(19,'zenith','Z3n1thK3y!','Zenith','Scott','Ramirez','zenith@appix.mx',1),(20,'luna','Lun@P@ssw0rd','Luna','Gomez','Parker','luna@appix.mx',1);
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `IDCliente` int NOT NULL AUTO_INCREMENT,
  `CorreoElectronico` varchar(255) NOT NULL,
  `Telefono` varchar(20) NOT NULL,
  `Tipo` int NOT NULL,
  PRIMARY KEY (`IDCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'juan_perez@gmail.com','1234567890',1),(2,'maria_garcia@gmail.com','2345678901',2),(3,'carlos_martinez@gmail.com','3456789012',1),(4,'ana_lopez@gmail.com','4567890123',2),(5,'pedro_sanchez@gmail.com','5678901234',1),(6,'laura_rodriguez@gmail.com','6789012345',2),(7,'miguel_gomez@gmail.com','7890123456',1),(8,'elena_hernandez@gmail.com','8901234567',2),(9,'david_fernandez@gmail.com','9012345678',1),(10,'sofia_diaz@gmail.com','1234567890',2),(11,'diego_martinez@gmail.com','2345678901',1),(12,'lucia_gonzalez@gmail.com','3456789012',2),(13,'javier_gomez@gmail.com','4567890123',1),(14,'paula_perez@gmail.com','5678901234',2),(15,'alejandro_lopez@gmail.com','6789012345',1),(16,'marta_hernandez@gmail.com','7890123456',2),(17,'raul_diaz@gmail.com','8901234567',1),(18,'carmen_rodriguez@gmail.com','9012345678',2),(19,'roberto_garcia@gmail.com','1234567890',1),(20,'isabel_sanchez@gmail.com','2345678901',2);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colaborador`
--

DROP TABLE IF EXISTS `colaborador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colaborador` (
  `IDColaborador` int NOT NULL AUTO_INCREMENT,
  `Usuario` varchar(32) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `Nombre` varchar(40) NOT NULL,
  `ApellidoPaterno` varchar(40) NOT NULL,
  `ApellidoMaterno` varchar(40) NOT NULL,
  `CorreoElectronico` varchar(32) NOT NULL,
  `PermisoAdmin` tinyint(1) NOT NULL,
  PRIMARY KEY (`IDColaborador`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colaborador`
--

LOCK TABLES `colaborador` WRITE;
/*!40000 ALTER TABLE `colaborador` DISABLE KEYS */;
INSERT INTO `colaborador` VALUES (1,'jdoe','contrasena123','John','Doe','González','john.doe@appix.mx',0),(2,'lsmith','password321','Linda','Smith','Martínez','linda.smith@appix.mx',0),(3,'mgonzalez','pass1234','Mario','González','López','mario.gonzalez@appix.mx',0),(4,'jrodriguez','secretword','Julia','Rodríguez','Sánchez','julia.rodriguez@appix.mx',0),(5,'rwilliams','securepass','Robert','Williams','Fernández','robert.williams@appix.mx',0),(6,'slee','password123','Sophia','Lee','Hernández','sophia.lee@appix.mx',0),(7,'jjones','adminpass','Jennifer','Jones','García','jennifer.jones@appix.mx',0),(8,'mlopez','pass12345','Miguel','López','Rodríguez','miguel.lopez@appix.mx',0),(9,'ppatel','patelpass','Priya','Patel','Fernández','priya.patel@appix.mx',0),(10,'jgarcia','garcia123','Jorge','García','Martínez','jorge.garcia@appix.mx',0),(11,'afernandez','fernandez123','Ana','Fernández','López','ana.fernandez@appix.mx',0),(12,'cjackson','jacksonpass','Christopher','Jackson','Sánchez','christopher.jackson@appix.mx',0),(13,'krodriguez','rodriguezpass','Karen','Rodríguez','Hernández','karen.rodriguez@appix.mx',0),(14,'tmiller','millerpass','Taylor','Miller','Martínez','taylor.miller@appix.mx',0),(15,'asanchez','passsanchez','Alicia','Sánchez','Fernández','alicia.sanchez@appix.mx',0),(16,'wlee','leepass','William','Lee','González','william.lee@appix.mx',0),(17,'rlopez','rlopezpass','Rebecca','López','Hernández','rebecca.lopez@appix.mx',0),(18,'ksmith','smith123','Kevin','Smith','García','kevin.smith@appix.mx',0),(19,'vfernandez','vfernandezpass','Victoria','Fernández','Martínez','victoria.fernandez@appix.mx',0),(20,'mgonzalez2','gonzalezpass','María','González','López','maria.gonzalez@appix.mx',0);
/*!40000 ALTER TABLE `colaborador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medida`
--

DROP TABLE IF EXISTS `medida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medida` (
  `IDMedida` int NOT NULL AUTO_INCREMENT,
  `IDRiesgo` int NOT NULL,
  `Nombre` varchar(80) NOT NULL,
  `Descripcion` varchar(512) NOT NULL,
  `Tipo` int NOT NULL,
  PRIMARY KEY (`IDMedida`),
  KEY `IDRiesgo` (`IDRiesgo`),
  CONSTRAINT `medida_ibfk_1` FOREIGN KEY (`IDRiesgo`) REFERENCES `riesgo` (`IDRiesgo`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medida`
--

LOCK TABLES `medida` WRITE;
/*!40000 ALTER TABLE `medida` DISABLE KEYS */;
INSERT INTO `medida` VALUES (1,1,'M1- Reuniones detalladas con el cliente','Realizar reuniones detalladas y periódicas con el cliente para comprender a fondo sus necesidades, expectativas y objetivos. Esto ayudará a prevenir malentendidos y a garantizar que el proyecto se alinee con las expectativas del cliente.',4),(2,2,'M2- Establecer plazos claros y roles para entrega de contenido','Establecer plazos claros y roles bien definidos para la entrega de contenido, incluyendo fechas límite, responsabilidades y procesos de aprobación. Esto ayudará a garantizar que el contenido se entregue a tiempo y de acuerdo con las especificaciones del proyecto.',4),(3,3,'M3- Definir un alcance claro y limitar las revisiones del diseño','Definir un alcance claro y bien definido para el proyecto y limitar las revisiones del diseño a cambios esenciales. Esto ayudará a evitar retrasos y costos adicionales debido a cambios frecuentes en los requisitos.',4),(4,4,'M4- Realizar pruebas de compatibilidad al inicio','Realizar pruebas de compatibilidad exhaustivas al inicio del proyecto para identificar y abordar cualquier problema de compatibilidad potencial entre los sistemas, software y hardware utilizados. Esto ayudará a prevenir problemas de integración y garantizar el correcto funcionamiento del proyecto.',4),(5,5,'M5- Aplicar estándares de seguridad y realizar actualizaciones','Implementar y aplicar estándares de seguridad estrictos para proteger los datos del cliente y la información confidencial. Realizar actualizaciones de seguridad regulares para mantener el software y los sistemas protegidos contra las últimas amenazas.',4),(6,6,'M6- Validar integraciones y tener proveedores de respaldo','Validar rigurosamente todas las integraciones con sistemas externos y tener proveedores de respaldo en caso de que un proveedor principal no pueda cumplir con sus obligaciones. Esto ayudará a garantizar la continuidad del proyecto y a minimizar el impacto de cualquier problema con los proveedores.',4),(7,7,'M7- Monitorear y ajustar el presupuesto continuamente','Monitorear el presupuesto del proyecto de cerca y realizar ajustes según sea necesario para garantizar que el proyecto se mantenga dentro del presupuesto. Esto ayudará a evitar sorpresas en el futuro y a garantizar que los recursos se utilicen de manera eficiente.',4),(8,8,'M8- Implementar estrategias de respaldo y recuperación ante desastres','Implementar estrategias de respaldo y recuperación ante desastres para proteger los datos del proyecto y garantizar la continuidad del negocio en caso de un desastre natural o falla del sistema. Esto ayudará a minimizar el tiempo de inactividad y el impacto negativo en el negocio.',4),(9,9,'M9- Establecer expectativas y procesos claros de aprobación','Establecer expectativas claras y procesos de aprobación bien definidos para cambios en el proyecto, incluyendo documentación, revisión y aprobación por parte de las partes interesadas relevantes. Esto ayudará a evitar retrasos y garantizar que todos los cambios se implementen de manera controlada.',4),(10,10,'M10- Mantenerse actualizado con las últimas versiones y soporte','Mantenerse actualizado con las últimas versiones del software y las plataformas utilizadas en el proyecto, y garantizar que se tenga acceso a soporte técnico adecuado. Esto ayudará a prevenir problemas de seguridad y a garantizar que el proyecto funcione correctamente.',4);
/*!40000 ALTER TABLE `medida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personafisica`
--

DROP TABLE IF EXISTS `personafisica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personafisica` (
  `IDCliente` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(40) NOT NULL,
  `ApellidoPaterno` varchar(40) NOT NULL,
  `AppellidoMaterno` varchar(40) NOT NULL,
  PRIMARY KEY (`IDCliente`),
  CONSTRAINT `personafisica_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personafisica`
--

LOCK TABLES `personafisica` WRITE;
/*!40000 ALTER TABLE `personafisica` DISABLE KEYS */;
INSERT INTO `personafisica` VALUES (1,'Juan','Pérez','Gómez'),(2,'María','García','López'),(3,'Carlos','Martínez','Hernández'),(4,'Ana','López','Fernández'),(5,'Pedro','Sánchez','Díaz'),(6,'Laura','Rodríguez','Martínez'),(7,'Miguel','Gómez','Pérez'),(8,'Elena','Hernández','Sánchez'),(9,'David','Fernández','González'),(10,'Sofía','Díaz','García'),(11,'Diego','Martínez','López'),(12,'Lucía','González','Hernández'),(13,'Javier','Gómez','Rodríguez'),(14,'Paula','Pérez','Sánchez'),(15,'Alejandro','López','Fernández'),(16,'Marta','Hernández','Martínez'),(17,'Raul','Díaz','Gómez'),(18,'Carmen','Rodríguez','Pérez'),(19,'Roberto','García','López'),(20,'Isabel','Sánchez','Martínez');
/*!40000 ALTER TABLE `personafisica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personamoral`
--

DROP TABLE IF EXISTS `personamoral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personamoral` (
  `IDCliente` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(40) NOT NULL,
  `RazonSocial` varchar(80) NOT NULL,
  PRIMARY KEY (`IDCliente`),
  CONSTRAINT `personamoral_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personamoral`
--

LOCK TABLES `personamoral` WRITE;
/*!40000 ALTER TABLE `personamoral` DISABLE KEYS */;
INSERT INTO `personamoral` VALUES (1,'ACME Inc.','ACME - Soluciones Tecnológicas'),(2,'WidgetCorp','WidgetCorp - Innovación en Productos'),(3,'Eagle Enterprises','Eagle Enterprises - Líder en Servicios'),(4,'Omega Solutions','Omega Solutions - Soluciones Empresariales'),(5,'Apex Innovations','Apex Innovations - Innovación en Desarrollo'),(6,'Zenith Industries','Zenith Industries - Excelencia en Manufactura'),(7,'Prime Ventures','Prime Ventures - Impulsando el Futuro'),(8,'Spectra Group','Spectra Group - Conectando el Mundo'),(9,'Summit Enterprises','Summit Enterprises - Elevando Estándares'),(10,'Vertex Solutions','Vertex Solutions - Transformando Negocios'),(11,'Horizon Technologies','Horizon Technologies - Tecnología del Mañana'),(12,'Infinite Innovations','Infinite Innovations - Innovación Infinita'),(13,'Global Industries','Global Industries - Líder en Mercados Globales'),(14,'Meridian Solutions','Meridian Solutions - Navegando el Éxito'),(15,'Pinnacle Enterprises','Pinnacle Enterprises - Cima de la Excelencia'),(16,'Frontier Group','Frontier Group - Explorando Nuevos Horizontes'),(17,'United Ventures','United Ventures - Uniendo Fuerzas'),(18,'Strategic Solutions','Strategic Solutions - Soluciones Estratégicas'),(19,'Apex Innovations','Apex Innovations - Innovación en Desarrollo'),(20,'Empire Enterprises','Empire Enterprises - Imperio de Oportunidades');
/*!40000 ALTER TABLE `personamoral` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presenta`
--

DROP TABLE IF EXISTS `presenta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presenta` (
  `IDRiesgo` int NOT NULL,
  `IDProyecto` int NOT NULL,
  `FechaAsignacion` datetime NOT NULL,
  `PonderacionRelativa` int NOT NULL,
  PRIMARY KEY (`IDProyecto`,`IDRiesgo`),
  KEY `IDRiesgo` (`IDRiesgo`),
  CONSTRAINT `presenta_ibfk_1` FOREIGN KEY (`IDProyecto`) REFERENCES `proyecto` (`IDProyecto`),
  CONSTRAINT `presenta_ibfk_2` FOREIGN KEY (`IDRiesgo`) REFERENCES `riesgo` (`IDRiesgo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presenta`
--

LOCK TABLES `presenta` WRITE;
/*!40000 ALTER TABLE `presenta` DISABLE KEYS */;
INSERT INTO `presenta` VALUES (1,1,'2024-01-01 00:00:00',3),(2,1,'2025-01-01 00:00:00',2),(3,1,'2024-03-01 00:00:00',1),(7,1,'2025-08-01 00:00:00',4),(8,1,'2024-08-01 00:00:00',4),(9,1,'2024-09-01 00:00:00',2),(1,2,'2024-04-01 00:00:00',4),(2,2,'2024-02-01 00:00:00',2),(3,2,'2025-03-01 00:00:00',1),(7,2,'2025-04-01 00:00:00',4),(10,2,'2024-10-01 00:00:00',3),(1,3,'2025-02-01 00:00:00',3),(2,3,'2024-11-01 00:00:00',1),(5,3,'2024-05-01 00:00:00',2),(6,3,'2024-06-01 00:00:00',3),(7,3,'2024-07-01 00:00:00',1),(2,4,'2024-12-01 00:00:00',4),(6,4,'2025-07-01 00:00:00',1),(8,4,'2025-06-01 00:00:00',3),(9,4,'2025-05-01 00:00:00',2);
/*!40000 ALTER TABLE `presenta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyecto`
--

DROP TABLE IF EXISTS `proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyecto` (
  `IDProyecto` int NOT NULL AUTO_INCREMENT,
  `IDCliente` int NOT NULL,
  `IDAdministrador` int NOT NULL,
  `Nombre` varchar(80) NOT NULL,
  `FechaInicio` datetime NOT NULL,
  `FechaFinal` datetime NOT NULL,
  `Tipo` int NOT NULL,
  `Estado` tinyint(1) NOT NULL,
  PRIMARY KEY (`IDProyecto`),
  KEY `IDCliente` (`IDCliente`),
  KEY `IDAdministrador` (`IDAdministrador`),
  CONSTRAINT `proyecto_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`),
  CONSTRAINT `proyecto_ibfk_2` FOREIGN KEY (`IDAdministrador`) REFERENCES `administrador` (`IDColaborador`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyecto`
--

LOCK TABLES `proyecto` WRITE;
/*!40000 ALTER TABLE `proyecto` DISABLE KEYS */;
INSERT INTO `proyecto` VALUES (1,1,3,'Desarrollo de Aplicación Móvil','2024-01-15 09:00:00','2024-07-15 18:00:00',1,1),(2,2,3,'Implementación de Sistema de Gestión','2024-02-01 08:30:00','2024-08-01 17:30:00',2,1),(3,3,2,'Diseño de Campaña Publicitaria','2024-03-10 10:00:00','2024-09-10 19:00:00',1,0),(4,4,2,'Desarrollo de Plataforma E-Commerce','2024-04-05 09:30:00','2024-10-05 18:30:00',2,0),(5,5,1,'Consultoría en Estrategia de Marketing','2024-05-20 10:00:00','2024-11-20 19:00:00',1,1),(6,6,1,'Diseño de Identidad Corporativa','2024-06-02 08:00:00','2024-12-02 17:00:00',2,1),(7,7,1,'Desarrollo de Software a Medida','2024-07-12 09:30:00','2025-01-12 18:30:00',1,0),(8,8,1,'Implementación de Sistema ERP','2024-08-25 08:00:00','2025-02-25 17:00:00',2,0),(9,9,1,'Asesoría en Gestión de Recursos Humanos','2024-09-14 10:00:00','2025-03-14 19:00:00',1,1),(10,10,2,'Desarrollo de Sitio Web Corporativo','2024-10-30 08:30:00','2025-04-30 17:30:00',2,1),(11,11,2,'Consultoría en Finanzas Empresariales','2024-11-18 09:00:00','2025-05-18 18:00:00',1,0),(12,12,2,'Desarrollo de Aplicación de Gestión de Proyectos','2024-12-07 08:00:00','2025-06-07 17:00:00',2,0),(13,13,2,'Evaluación de Riesgos Ambientales','2025-01-22 09:30:00','2025-07-22 18:30:00',1,1),(14,14,3,'Implementación de Soluciones de Seguridad Informática','2025-02-11 08:45:00','2025-08-11 17:45:00',2,1),(15,15,3,'Desarrollo de Aplicación de Realidad Aumentada','2025-03-03 09:15:00','2025-09-03 18:15:00',1,0),(16,16,3,'Diseño de Experiencia de Usuario (UX)','2025-04-18 10:30:00','2025-10-18 19:30:00',2,0),(17,17,1,'Implementación de Plataforma de E-Learning','2025-05-09 08:00:00','2025-11-09 17:00:00',1,1),(18,18,2,'Desarrollo de Sistema de Gestión de Contenidos (CMS)','2025-06-24 09:30:00','2025-12-24 18:30:00',2,1),(19,19,3,'Consultoría en Optimización de Procesos','2025-07-17 10:15:00','2026-01-17 19:15:00',1,0),(20,20,2,'Desarrollo de Aplicación de Monitoreo Remoto','2025-08-05 08:45:00','2026-02-05 17:45:00',2,0);
/*!40000 ALTER TABLE `proyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `riesgo`
--

DROP TABLE IF EXISTS `riesgo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `riesgo` (
  `IDRiesgo` int NOT NULL AUTO_INCREMENT,
  `IDMedida` int NOT NULL,
  `Nombre` varchar(80) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Descripcion` varchar(512) NOT NULL,
  `Puntaje` int NOT NULL,
  `Estatus` tinyint(1) NOT NULL,
  `Tipo` int NOT NULL,
  PRIMARY KEY (`IDRiesgo`),
  KEY `IDMedida` (`IDMedida`),
  CONSTRAINT `riesgo_ibfk_1` FOREIGN KEY (`IDMedida`) REFERENCES `medida` (`IDMedida`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `riesgo`
--

LOCK TABLES `riesgo` WRITE;
/*!40000 ALTER TABLE `riesgo` DISABLE KEYS */;
INSERT INTO `riesgo` VALUES (1,1,'Incomprensión de los requisitos del cliente','2024-04-26 00:00:00','El cliente no ha proporcionado información clara y precisa sobre sus necesidades, lo que puede generar retrasos y/o errores en el proyecto.',8,1,3),(2,2,'Retrasos en la entrega del contenido','2024-04-26 00:00:00','Se han producido retrasos en la entrega de contenido por parte de los proveedores o el equipo interno, lo que puede afectar el cronograma del proyecto.',5,1,5),(3,3,'Cambios frecuentes en el diseño','2024-04-26 00:00:00','Se han realizado cambios frecuentes en el diseño del proyecto, lo que puede generar costos adicionales y retrasar la entrega del producto final.',6,1,2),(4,4,'Problemas de compatibilidad de plugins','2024-04-26 00:00:00','Se han encontrado problemas de compatibilidad entre los plugins utilizados en el proyecto, lo que puede afectar el funcionamiento del sitio web o la aplicación.',8,1,4),(5,5,'Problemas de seguridad en el sitio web','2024-04-26 00:00:00','Se han detectado vulnerabilidades de seguridad en el sitio web, lo que puede poner en riesgo los datos de los usuarios.',9,1,6),(6,6,'Fallos en la integración de pasarelas de pago','2024-04-26 00:00:00','Se han producido fallos en la integración de las pasarelas de pago, lo que puede afectar las ventas del negocio.',6,1,1),(7,7,'Aumento inesperado en los costos del proyecto','2024-04-26 00:00:00','Se han producido gastos inesperados en el proyecto, lo que puede afectar la rentabilidad del mismo.',7,1,5),(8,8,'Pérdida de datos o fallo de hosting','2024-04-26 00:00:00','Se ha producido una pérdida de datos o un fallo en el servicio de hosting, lo que puede afectar el funcionamiento del sitio web o la aplicación.',8,0,4),(9,9,'Retrasos en la aprobación del cliente','2024-04-26 00:00:00','Se han producido retrasos en la aprobación del cliente por parte del cliente, lo que puede afectar el cronograma del proyecto.',7,1,2),(10,10,'Dificultades técnicas con WordPress o WooCommerce','2024-04-26 00:00:00','Se han encontrado dificultades técnicas con WordPress o WooCommerce, lo que puede afectar el funcionamiento del sitio web o la tienda online.',10,1,3);
/*!40000 ALTER TABLE `riesgo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trabaja`
--

DROP TABLE IF EXISTS `trabaja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trabaja` (
  `IDProyecto` int NOT NULL,
  `IDColaborador` int NOT NULL,
  PRIMARY KEY (`IDProyecto`,`IDColaborador`),
  KEY `IDColaborador` (`IDColaborador`),
  CONSTRAINT `trabaja_ibfk_1` FOREIGN KEY (`IDProyecto`) REFERENCES `proyecto` (`IDProyecto`),
  CONSTRAINT `trabaja_ibfk_2` FOREIGN KEY (`IDColaborador`) REFERENCES `colaborador` (`IDColaborador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trabaja`
--

LOCK TABLES `trabaja` WRITE;
/*!40000 ALTER TABLE `trabaja` DISABLE KEYS */;
INSERT INTO `trabaja` VALUES (1,1),(2,1),(3,1),(4,2),(5,2),(6,2),(7,3),(8,3),(9,3),(10,4),(11,4),(12,4),(13,5),(14,5),(15,5),(16,6),(17,6),(18,6),(19,7),(20,7);
/*!40000 ALTER TABLE `trabaja` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-26 13:49:24
