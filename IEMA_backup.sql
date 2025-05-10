-- MySQL dump 10.13  Distrib 9.3.0, for macos14.7 (x86_64)
--
-- Host: localhost    Database: IEMA
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `alocacao`
--

DROP TABLE IF EXISTS `alocacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alocacao` (
  `id_alocacao` int NOT NULL AUTO_INCREMENT,
  `id_turma` int NOT NULL,
  `id_disciplina` int NOT NULL,
  `id_professor` int DEFAULT NULL,
  `id_sala` int DEFAULT NULL,
  `id_horario` int NOT NULL,
  `dia_semana` enum('Segunda','Terça','Quarta','Quinta','Sexta','Sábado') DEFAULT NULL,
  PRIMARY KEY (`id_alocacao`),
  KEY `id_turma` (`id_turma`),
  KEY `id_disciplina` (`id_disciplina`),
  KEY `id_professor` (`id_professor`),
  KEY `id_sala` (`id_sala`),
  KEY `id_horario` (`id_horario`),
  CONSTRAINT `alocacao_ibfk_1` FOREIGN KEY (`id_turma`) REFERENCES `turma` (`id_turma`),
  CONSTRAINT `alocacao_ibfk_2` FOREIGN KEY (`id_disciplina`) REFERENCES `disciplina` (`id_disciplina`),
  CONSTRAINT `alocacao_ibfk_3` FOREIGN KEY (`id_professor`) REFERENCES `professor` (`id_professor`),
  CONSTRAINT `alocacao_ibfk_4` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`),
  CONSTRAINT `alocacao_ibfk_5` FOREIGN KEY (`id_horario`) REFERENCES `horario` (`id_horario`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alocacao`
--

LOCK TABLES `alocacao` WRITE;
/*!40000 ALTER TABLE `alocacao` DISABLE KEYS */;
INSERT INTO `alocacao` VALUES (1,1,1,1,1,1,'Segunda'),(2,1,1,1,1,1,'Terça'),(3,1,1,1,1,1,'Sábado'),(4,1,1,1,2,1,'Sexta'),(5,1,2,1,1,1,'Quinta'),(6,1,2,3,1,1,'Quarta'),(7,1,1,2,1,2,'Segunda');
/*!40000 ALTER TABLE `alocacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alocacao_professor`
--

DROP TABLE IF EXISTS `alocacao_professor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alocacao_professor` (
  `id_alocacao` int NOT NULL,
  `id_professor` int NOT NULL,
  PRIMARY KEY (`id_alocacao`,`id_professor`),
  KEY `id_professor` (`id_professor`),
  CONSTRAINT `alocacao_professor_ibfk_1` FOREIGN KEY (`id_alocacao`) REFERENCES `alocacao` (`id_alocacao`),
  CONSTRAINT `alocacao_professor_ibfk_2` FOREIGN KEY (`id_professor`) REFERENCES `professor` (`id_professor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alocacao_professor`
--

LOCK TABLES `alocacao_professor` WRITE;
/*!40000 ALTER TABLE `alocacao_professor` DISABLE KEYS */;
/*!40000 ALTER TABLE `alocacao_professor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disciplina`
--

DROP TABLE IF EXISTS `disciplina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disciplina` (
  `id_disciplina` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `carga_horaria` int NOT NULL DEFAULT '40',
  PRIMARY KEY (`id_disciplina`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disciplina`
--

LOCK TABLES `disciplina` WRITE;
/*!40000 ALTER TABLE `disciplina` DISABLE KEYS */;
INSERT INTO `disciplina` VALUES (1,'Matemática',60),(2,'Português',40),(3,'Programação',80),(4,'Banco de Dados',60);
/*!40000 ALTER TABLE `disciplina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario`
--

DROP TABLE IF EXISTS `horario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario` (
  `id_horario` int NOT NULL AUTO_INCREMENT,
  `inicio` time NOT NULL,
  `fim` time NOT NULL,
  PRIMARY KEY (`id_horario`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario`
--

LOCK TABLES `horario` WRITE;
/*!40000 ALTER TABLE `horario` DISABLE KEYS */;
INSERT INTO `horario` VALUES (1,'07:35:00','08:25:00'),(2,'08:25:00','09:05:00'),(3,'09:30:00','10:20:00'),(4,'10:20:00','11:10:00'),(5,'11:10:00','12:00:00'),(6,'13:30:00','14:20:00'),(7,'14:20:00','15:00:00'),(8,'15:25:00','16:10:00'),(9,'16:10:00','17:00:00');
/*!40000 ALTER TABLE `horario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professor`
--

DROP TABLE IF EXISTS `professor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `professor` (
  `id_professor` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id_professor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professor`
--

LOCK TABLES `professor` WRITE;
/*!40000 ALTER TABLE `professor` DISABLE KEYS */;
INSERT INTO `professor` VALUES (1,'Prof. João'),(2,'Profª. Maria'),(3,'Prof. Carlos');
/*!40000 ALTER TABLE `professor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sala`
--

DROP TABLE IF EXISTS `sala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala` (
  `id_sala` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`id_sala`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala`
--

LOCK TABLES `sala` WRITE;
/*!40000 ALTER TABLE `sala` DISABLE KEYS */;
INSERT INTO `sala` VALUES (1,'Laboratório'),(2,'Sala de Aula');
/*!40000 ALTER TABLE `sala` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turma`
--

DROP TABLE IF EXISTS `turma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turma` (
  `id_turma` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` varchar(90) DEFAULT NULL,
  PRIMARY KEY (`id_turma`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turma`
--

LOCK TABLES `turma` WRITE;
/*!40000 ALTER TABLE `turma` DISABLE KEYS */;
INSERT INTO `turma` VALUES (1,'101','Técnico em Administração'),(2,'102','Técnico em Farmácia'),(3,'103','Técnico em Informática'),(4,'104','Técnico em Segurança do Trabalho'),(5,'201','Técnico em Administração'),(6,'202','Técnico em Logística'),(7,'203','Técnico em Informática'),(8,'204','Técnico em Segurança do Trabalho'),(9,'301','Técnico em Administração'),(10,'302','Técnico em Serviço Jurídico'),(11,'303','Técnico em Informática'),(12,'304','Técnico em Enfermagem');
/*!40000 ALTER TABLE `turma` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-10 19:52:41
