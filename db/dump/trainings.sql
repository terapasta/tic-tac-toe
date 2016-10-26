-- MySQL dump 10.13  Distrib 5.5.52, for Linux (x86_64)
--
-- Host: app-myope.ccfwhx3hbmfs.ap-northeast-1.rds.amazonaws.com    Database: myope
-- ------------------------------------------------------
-- Server version	5.7.10-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `trainings`
--

DROP TABLE IF EXISTS `trainings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trainings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `bot_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainings`
--

LOCK TABLES `trainings` WRITE;
/*!40000 ALTER TABLE `trainings` DISABLE KEYS */;
INSERT INTO `trainings` VALUES (1,NULL,'2016-10-19 15:57:43','2016-10-19 15:57:43',1),(2,NULL,'2016-10-19 15:57:43','2016-10-19 15:57:43',1),(78,'normal','2016-09-16 15:26:24','2016-09-16 15:26:33',2),(79,'normal','2016-09-16 17:28:57','2016-09-16 17:29:08',2),(80,'normal','2016-09-16 17:33:27','2016-09-16 17:33:33',2),(81,'normal','2016-09-16 17:37:19','2016-09-16 17:37:27',2),(82,NULL,'2016-09-17 10:24:17','2016-09-17 10:24:17',1),(83,NULL,'2016-09-17 10:33:07','2016-09-17 10:33:07',1),(84,NULL,'2016-09-17 10:33:27','2016-09-17 10:33:27',1),(85,NULL,'2016-09-17 10:38:18','2016-09-17 10:38:18',1),(86,NULL,'2016-09-17 10:38:55','2016-09-17 10:38:55',1),(87,NULL,'2016-09-17 10:39:02','2016-09-17 10:39:02',1),(88,NULL,'2016-09-17 10:48:59','2016-09-17 10:48:59',1),(89,NULL,'2016-09-17 10:54:23','2016-09-17 10:54:23',1),(90,NULL,'2016-09-17 11:58:40','2016-09-17 11:58:40',1),(91,NULL,'2016-09-17 11:58:45','2016-09-17 11:58:45',1),(92,NULL,'2016-09-17 11:59:14','2016-09-17 11:59:14',1),(93,NULL,'2016-09-17 12:00:03','2016-09-17 12:00:03',1),(94,NULL,'2016-09-17 12:01:28','2016-09-17 12:01:28',1),(95,NULL,'2016-09-17 12:01:34','2016-09-17 12:01:34',1),(96,NULL,'2016-09-17 12:03:37','2016-09-17 12:03:37',1),(97,NULL,'2016-09-17 12:10:27','2016-09-17 12:10:27',1),(98,NULL,'2016-09-17 12:16:30','2016-09-17 12:16:30',1),(99,NULL,'2016-09-17 12:16:35','2016-09-17 12:16:35',1),(100,NULL,'2016-09-17 12:17:19','2016-09-17 12:17:19',1),(101,NULL,'2016-09-17 12:29:31','2016-09-17 12:29:31',1),(102,NULL,'2016-09-17 12:30:20','2016-09-17 12:30:20',1),(103,'normal','2016-09-17 12:32:19','2016-09-17 12:32:27',2),(104,'normal','2016-09-17 12:41:55','2016-09-17 12:41:59',2),(105,'normal','2016-09-17 12:42:52','2016-09-17 12:42:53',2),(106,'normal','2016-09-17 12:44:37','2016-09-17 12:44:45',2),(107,'normal','2016-09-17 12:47:39','2016-09-17 12:47:41',2),(108,'normal','2016-09-17 12:48:20','2016-09-17 12:48:22',2),(109,'normal','2016-09-17 12:50:25','2016-09-17 12:50:28',2),(110,'normal','2016-09-17 12:51:33','2016-09-17 13:42:29',2),(111,'normal','2016-09-17 13:50:00','2016-09-17 13:50:02',2),(112,'normal','2016-09-17 13:55:15','2016-09-17 13:55:22',2),(113,'normal','2016-09-17 15:40:40','2016-09-17 15:42:25',1),(114,'normal','2016-09-19 13:50:13','2016-09-19 13:50:17',2),(115,'normal','2016-09-19 13:50:51','2016-09-19 13:50:56',2),(116,'normal','2016-09-19 13:51:34','2016-09-19 13:51:39',2),(117,'normal','2016-09-19 13:52:19','2016-09-19 13:52:23',2),(118,'normal','2016-09-19 13:53:10','2016-09-19 13:53:14',2),(119,'normal','2016-09-19 13:53:40','2016-09-19 13:53:43',2),(120,'normal','2016-09-19 13:55:11','2016-09-19 13:55:16',2),(121,'normal','2016-09-19 13:55:27','2016-09-19 13:55:32',2),(122,'normal','2016-09-19 13:56:37','2016-09-19 13:56:42',2),(123,'normal','2016-09-19 13:57:09','2016-09-19 13:57:13',2),(124,'normal','2016-09-19 13:58:14','2016-09-19 13:58:18',2),(125,'normal','2016-09-19 13:58:36','2016-09-19 13:58:42',2),(126,'normal','2016-09-19 14:00:01','2016-09-19 14:00:06',2),(127,'normal','2016-09-19 14:21:59','2016-09-19 14:22:04',2),(128,'normal','2016-09-19 14:24:06','2016-09-19 14:24:09',2),(129,'normal','2016-09-19 14:24:18','2016-09-19 14:24:21',2),(130,'normal','2016-09-19 14:25:12','2016-09-19 14:25:18',2),(131,'normal','2016-09-19 14:25:52','2016-09-19 14:25:57',2),(132,'normal','2016-09-19 14:26:10','2016-09-19 14:26:23',2),(133,'normal','2016-09-19 14:27:04','2016-09-19 14:27:07',2),(134,'normal','2016-09-19 14:28:28','2016-09-19 14:28:34',2),(135,'normal','2016-09-19 14:29:18','2016-09-19 14:29:26',2),(136,'normal','2016-09-19 14:30:49','2016-09-19 14:30:55',2),(137,'normal','2016-09-19 14:38:16','2016-09-19 14:38:22',2),(138,'normal','2016-09-19 14:44:30','2016-09-19 14:44:35',2),(139,'normal','2016-09-19 14:46:36','2016-09-19 14:46:43',2),(140,'normal','2016-09-19 16:34:33','2016-09-19 16:35:12',2),(141,'normal','2016-09-19 16:36:22','2016-09-19 16:36:26',2),(142,'normal','2016-09-19 16:38:51','2016-09-19 16:39:01',2),(143,'normal','2016-09-19 16:40:48','2016-09-19 16:40:53',2),(144,'normal','2016-09-19 16:41:57','2016-09-19 16:42:04',2),(145,'normal','2016-09-19 16:42:57','2016-09-19 16:43:01',2),(146,'normal','2016-09-19 16:43:57','2016-09-19 16:44:03',2),(147,'normal','2016-09-19 16:45:54','2016-09-19 16:45:59',2),(148,'normal','2016-09-19 16:47:42','2016-09-19 16:47:48',2),(149,'normal','2016-09-19 16:48:50','2016-09-19 16:48:53',2),(150,'normal','2016-09-19 16:49:12','2016-09-19 16:49:16',2),(151,'normal','2016-09-19 16:50:45','2016-09-19 16:50:54',2),(152,'normal','2016-09-19 16:52:26','2016-09-19 16:52:31',2),(153,'normal','2016-09-19 17:12:57','2016-09-19 17:13:58',1),(154,'normal','2016-09-20 13:57:48','2016-09-20 13:57:55',2),(155,'normal','2016-09-20 14:03:09','2016-09-20 14:06:11',2),(156,'normal','2016-09-20 14:08:03','2016-09-20 14:08:09',2),(157,'normal','2016-09-20 14:13:04','2016-09-20 14:13:10',2),(158,'normal','2016-09-25 12:41:07','2016-09-25 12:41:31',2),(159,NULL,'2016-09-25 12:42:04','2016-09-25 12:42:04',2),(160,NULL,'2016-09-25 12:52:07','2016-09-25 12:52:39',2),(161,'normal','2016-09-26 14:27:18','2016-09-26 14:27:45',2),(162,'normal','2016-09-26 16:37:59','2016-09-26 16:38:19',1),(163,'normal','2016-09-26 20:21:20','2016-09-26 20:21:45',1),(164,'normal','2016-09-26 20:22:40','2016-09-26 20:22:52',1),(165,NULL,'2016-09-27 17:39:19','2016-09-27 17:39:19',1),(166,'normal','2016-09-28 18:24:56','2016-09-28 18:25:30',1),(167,'normal','2016-10-03 20:52:32','2016-10-03 20:52:39',2),(168,'normal','2016-10-03 20:53:18','2016-10-03 20:53:26',2),(169,NULL,'2016-10-03 21:33:06','2016-10-03 21:33:06',2),(170,'normal','2016-10-03 21:33:18','2016-10-03 21:33:41',2),(171,NULL,'2016-10-03 21:33:21','2016-10-03 21:33:21',2),(172,'normal','2016-10-03 21:33:24','2016-10-03 21:34:00',2),(173,'normal','2016-10-03 21:34:34','2016-10-03 21:36:37',2),(174,'normal','2016-10-03 21:34:58','2016-10-03 21:35:11',2),(175,NULL,'2016-10-03 21:36:10','2016-10-03 21:36:10',2),(176,'normal','2016-10-03 21:37:35','2016-10-03 21:37:44',2),(177,'normal','2016-10-03 21:41:08','2016-10-03 21:41:33',2),(178,'normal','2016-10-04 00:59:53','2016-10-04 01:02:01',2),(179,'normal','2016-10-04 01:05:41','2016-10-04 01:05:50',2),(180,'normal','2016-10-04 01:12:34','2016-10-04 01:12:43',2),(181,'normal','2016-10-04 01:16:11','2016-10-04 01:16:23',2),(182,'normal','2016-10-04 08:33:31','2016-10-04 08:33:41',2),(183,'normal','2016-10-04 08:37:19','2016-10-04 08:37:22',2),(184,'normal','2016-10-04 08:44:24','2016-10-04 08:44:33',2),(185,'normal','2016-10-04 08:52:38','2016-10-04 08:52:44',2),(186,'normal','2016-10-04 08:55:33','2016-10-04 08:55:52',2),(187,'normal','2016-10-04 08:59:19','2016-10-04 08:59:24',2),(188,'normal','2016-10-04 09:44:22','2016-10-04 09:45:18',2),(189,'normal','2016-10-04 09:47:25','2016-10-04 09:47:35',2),(190,'normal','2016-10-04 09:50:31','2016-10-04 09:50:40',2),(191,'normal','2016-10-04 09:54:41','2016-10-04 09:55:06',2),(192,NULL,'2016-10-04 09:56:53','2016-10-04 09:57:35',2),(193,'normal','2016-10-04 09:58:10','2016-10-04 09:58:19',2),(194,'normal','2016-10-04 09:58:17','2016-10-04 09:58:27',2),(195,'normal','2016-10-04 09:59:20','2016-10-04 09:59:35',2),(196,'normal','2016-10-04 10:00:13','2016-10-04 10:00:25',2),(197,'normal','2016-10-04 10:01:07','2016-10-04 10:01:22',2),(198,'normal','2016-10-04 10:01:49','2016-10-04 10:02:07',2),(199,'normal','2016-10-04 10:03:46','2016-10-04 10:03:55',2),(200,'normal','2016-10-04 10:05:53','2016-10-04 10:06:01',2),(201,'normal','2016-10-04 10:07:06','2016-10-04 10:07:21',2),(202,'normal','2016-10-04 10:09:02','2016-10-04 10:09:15',2),(203,'normal','2016-10-04 10:11:37','2016-10-04 10:11:56',2),(204,'normal','2016-10-04 10:15:14','2016-10-04 10:15:36',2),(205,'normal','2016-10-04 10:30:24','2016-10-04 10:30:28',2),(206,'normal','2016-10-04 16:15:48','2016-10-04 16:16:13',2),(207,NULL,'2016-10-04 16:16:46','2016-10-04 16:16:46',2),(208,'normal','2016-10-05 14:12:23','2016-10-05 14:12:30',2),(209,'normal','2016-10-05 17:12:51','2016-10-05 17:12:56',2),(210,'normal','2016-10-10 13:49:11','2016-10-10 13:49:17',1),(211,NULL,'2016-10-10 13:51:05','2016-10-10 13:51:05',1),(212,'normal','2016-10-10 13:52:16','2016-10-10 13:52:21',1),(213,'normal','2016-10-10 13:55:49','2016-10-10 13:55:55',1),(214,'normal','2016-10-10 16:21:21','2016-10-10 16:21:30',1),(215,'normal','2016-10-10 17:58:37','2016-10-10 17:58:48',1),(216,'normal','2016-10-11 15:13:17','2016-10-11 15:15:43',1),(217,'normal','2016-10-11 19:44:21','2016-10-11 19:47:10',1),(218,NULL,'2016-10-12 10:44:49','2016-10-12 10:44:49',1),(219,'normal','2016-10-12 12:59:53','2016-10-12 13:00:43',1),(220,'normal','2016-10-12 13:00:54','2016-10-12 13:02:06',1),(221,'normal','2016-10-12 13:02:58','2016-10-12 13:04:56',1),(222,NULL,'2016-10-13 07:46:26','2016-10-13 07:46:26',1),(223,NULL,'2016-10-13 07:54:39','2016-10-13 07:54:39',1),(224,NULL,'2016-10-13 07:56:17','2016-10-13 07:56:24',1),(225,NULL,'2016-10-13 07:57:04','2016-10-13 07:57:04',1),(226,NULL,'2016-10-13 12:35:11','2016-10-13 12:35:11',1),(227,'normal','2016-10-13 17:23:43','2016-10-13 17:28:26',1),(228,'normal','2016-10-13 17:45:44','2016-10-13 17:48:40',1),(229,'normal','2016-10-13 17:51:43','2016-10-13 17:54:51',1),(230,'normal','2016-10-14 10:32:04','2016-10-14 10:32:22',2),(231,NULL,'2016-10-14 12:10:03','2016-10-14 12:10:03',1),(232,NULL,'2016-10-14 12:10:26','2016-10-14 12:10:26',2),(233,'normal','2016-10-14 16:14:50','2016-10-14 16:15:07',1),(234,'normal','2016-10-14 16:15:26','2016-10-14 16:15:38',1),(235,'normal','2016-10-14 16:22:51','2016-10-14 16:23:37',1),(236,NULL,'2016-10-17 11:19:23','2016-10-17 11:22:26',1),(237,NULL,'2016-10-17 13:11:54','2016-10-17 13:11:54',1),(238,NULL,'2016-10-17 13:12:54','2016-10-17 13:12:54',2),(239,'normal','2016-10-17 13:13:26','2016-10-17 13:13:41',1),(240,'normal','2016-10-17 13:15:49','2016-10-17 13:15:56',1),(241,NULL,'2016-10-18 19:03:02','2016-10-18 19:05:48',1),(242,NULL,'2016-10-18 19:09:46','2016-10-18 19:09:46',1),(243,'normal','2016-10-18 19:14:40','2016-10-18 19:14:53',1),(244,NULL,'2016-10-18 19:26:44','2016-10-18 19:26:44',1),(245,'normal','2016-10-18 19:27:32','2016-10-18 19:27:41',1),(246,'normal','2016-10-19 01:45:56','2016-10-19 01:46:25',1),(247,NULL,'2016-10-19 01:48:06','2016-10-19 01:48:06',1),(248,NULL,'2016-10-19 05:46:56','2016-10-19 05:48:08',1),(249,'normal','2016-10-19 05:48:57','2016-10-19 05:53:07',1),(250,NULL,'2016-10-19 06:33:07','2016-10-19 06:33:07',1),(251,NULL,'2016-10-19 15:13:00','2016-10-19 15:13:00',2),(252,NULL,'2016-10-19 15:31:38','2016-10-19 15:31:38',1),(253,NULL,'2016-10-21 10:48:36','2016-10-21 11:20:56',1),(254,NULL,'2016-10-21 16:55:06','2016-10-21 16:55:06',4),(255,'normal','2016-10-21 18:22:34','2016-10-21 18:23:06',2);
/*!40000 ALTER TABLE `trainings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-24 14:26:12