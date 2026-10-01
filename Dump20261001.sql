-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: priorities_archive
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `archive_transfers`
--

DROP TABLE IF EXISTS `archive_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive_transfers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_id` int NOT NULL,
  `archive_id` int DEFAULT NULL,
  `transfer_status` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `attempt_count` int NOT NULL DEFAULT '0',
  `error_message` text COLLATE utf8mb4_unicode_ci,
  `source_reference` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cloud_sql_mysql',
  `destination_reference` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local_mysql',
  `payload_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_attempt_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `archive_transfers_file_id_idx` (`file_id`),
  KEY `archive_transfers_archive_id_idx` (`archive_id`),
  KEY `archive_transfers_status_idx` (`transfer_status`),
  CONSTRAINT `archive_transfers_archive_id_archives_id_fk` FOREIGN KEY (`archive_id`) REFERENCES `archives` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive_transfers`
--

LOCK TABLES `archive_transfers` WRITE;
/*!40000 ALTER TABLE `archive_transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `archives`
--

DROP TABLE IF EXISTS `archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archives` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_id` int NOT NULL,
  `file_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `archived_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `archived_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ARCHIVED',
  `current_pdf_version` int NOT NULL DEFAULT '1',
  `original_pdf_version` int NOT NULL DEFAULT '1',
  `original_pdf_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_pdf_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `archives_file_id_unique` (`file_id`),
  KEY `archives_file_id_idx` (`file_id`),
  KEY `archives_file_number_idx` (`file_number`),
  KEY `archives_status_idx` (`status`),
  KEY `archives_archived_at_idx` (`archived_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archives`
--

LOCK TABLES `archives` WRITE;
/*!40000 ALTER TABLE `archives` DISABLE KEYS */;
/*!40000 ALTER TABLE `archives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `archive_id` int DEFAULT NULL,
  `file_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `table_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `field_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_value` text COLLATE utf8mb4_unicode_ci,
  `new_value` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_info` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `audit_logs_archive_id_idx` (`archive_id`),
  KEY `audit_logs_file_id_idx` (`file_id`),
  KEY `audit_logs_user_id_idx` (`user_id`),
  KEY `audit_logs_table_record_idx` (`table_name`,`record_id`),
  KEY `audit_logs_created_at_idx` (`created_at`),
  CONSTRAINT `audit_logs_archive_id_archives_id_fk` FOREIGN KEY (`archive_id`) REFERENCES `archives` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `audit_logs_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_history`
--

DROP TABLE IF EXISTS `file_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_id` int NOT NULL,
  `actor_name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_type` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_status` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_status` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `file_history_file_idx` (`file_id`),
  CONSTRAINT `file_history_file_id_incoming_files_id_fk` FOREIGN KEY (`file_id`) REFERENCES `incoming_files` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_history`
--

LOCK TABLES `file_history` WRITE;
/*!40000 ALTER TABLE `file_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incoming_files`
--

DROP TABLE IF EXISTS `incoming_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incoming_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` int NOT NULL,
  `arrival_date` timestamp NOT NULL,
  `source_entity` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `importance` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `status` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_AG',
  `original_file_key` text COLLATE utf8mb4_unicode_ci,
  `original_file_url` text COLLATE utf8mb4_unicode_ci,
  `original_file_name` text COLLATE utf8mb4_unicode_ci,
  `original_mime_type` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signed_file_key` text COLLATE utf8mb4_unicode_ci,
  `signed_file_url` text COLLATE utf8mb4_unicode_ci,
  `is_signed` tinyint(1) NOT NULL DEFAULT '0',
  `signature_name` text COLLATE utf8mb4_unicode_ci,
  `signature_title` text COLLATE utf8mb4_unicode_ci,
  `signed_at` timestamp NULL DEFAULT NULL,
  `signed_instruction` text COLLATE utf8mb4_unicode_ci,
  `assigned_department` text COLLATE utf8mb4_unicode_ci,
  `assigned_employee` text COLLATE utf8mb4_unicode_ci,
  `director_instruction` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `due_date` timestamp NULL DEFAULT NULL,
  `registered_by` text COLLATE utf8mb4_unicode_ci,
  `current_responsible` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `directed_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `incoming_files_status_idx` (`status`),
  KEY `incoming_files_importance_idx` (`importance`),
  KEY `incoming_files_arrival_idx` (`arrival_date`),
  KEY `incoming_files_file_number_idx` (`file_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incoming_files`
--

LOCK TABLES `incoming_files` WRITE;
/*!40000 ALTER TABLE `incoming_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `incoming_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipient_open_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recipient_role` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'director',
  `file_id` int DEFAULT NULL,
  `kind` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `notifications_recipient_idx` (`recipient_open_id`),
  KEY `notifications_read_idx` (`read_at`),
  KEY `notifications_file_id_idx` (`file_id`),
  CONSTRAINT `notifications_file_id_incoming_files_id_fk` FOREIGN KEY (`file_id`) REFERENCES `incoming_files` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pdf_versions`
--

DROP TABLE IF EXISTS `pdf_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdf_versions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `archive_id` int NOT NULL,
  `file_id` int NOT NULL,
  `version_number` int NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'application/pdf',
  `file_size` int NOT NULL,
  `file_hash` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `is_current` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pdf_versions_archive_version_unique` (`archive_id`,`version_number`),
  KEY `pdf_versions_archive_id_idx` (`archive_id`),
  KEY `pdf_versions_file_id_idx` (`file_id`),
  KEY `pdf_versions_file_hash_idx` (`file_hash`),
  CONSTRAINT `pdf_versions_archive_id_archives_id_fk` FOREIGN KEY (`archive_id`) REFERENCES `archives` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pdf_versions`
--

LOCK TABLES `pdf_versions` WRITE;
/*!40000 ALTER TABLE `pdf_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdf_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `open_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` text COLLATE utf8mb4_unicode_ci,
  `name` text COLLATE utf8mb4_unicode_ci,
  `job_title` text COLLATE utf8mb4_unicode_ci,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `login_method` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_signed_in` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_open_id_unique` (`open_id`),
  UNIQUE KEY `users_uid_unique` (`uid`),
  UNIQUE KEY `users_username_unique` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-01  7:45:44
