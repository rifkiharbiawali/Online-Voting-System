-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versi server:                 8.0.30 - MySQL Community Server - GPL
-- OS Server:                    Win64
-- HeidiSQL Versi:               12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Membuang struktur basisdata untuk ovs-1
CREATE DATABASE IF NOT EXISTS `ovs-1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ovs-1`;

-- membuang struktur untuk table ovs-1.candidates
CREATE TABLE IF NOT EXISTS `candidates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `photo_url` varchar(255) DEFAULT NULL COMMENT 'URL ke foto profil kandidat.',
  `profile_data` text COMMENT 'Visi, misi, atau data profil lainnya.',
  PRIMARY KEY (`id`),
  KEY `fk_candidates_events_idx` (`event_id`),
  CONSTRAINT `fk_candidates_events` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel ovs-1.candidates: ~0 rows (lebih kurang)

-- membuang struktur untuk table ovs-1.events
CREATE TABLE IF NOT EXISTS `events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `start_time` datetime NOT NULL COMMENT 'Jadwal mulai periode voting.',
  `end_time` datetime NOT NULL COMMENT 'Jadwal akhir periode voting.',
  `status` enum('scheduled','active','archived') NOT NULL DEFAULT 'scheduled',
  `voting_location_lat` decimal(10,8) DEFAULT NULL COMMENT 'Latitude lokasi voting yang diizinkan.',
  `voting_location_lon` decimal(11,8) DEFAULT NULL COMMENT 'Longitude lokasi voting yang diizinkan.',
  `voting_radius_meters` int unsigned DEFAULT '50' COMMENT 'Radius (dalam meter) dari lokasi yang diizinkan.',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel ovs-1.events: ~0 rows (lebih kurang)

-- membuang struktur untuk table ovs-1.notifications
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'Contoh: email_confirmation, final_result.',
  `status` enum('sent','failed') NOT NULL DEFAULT 'sent',
  `sent_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_notifications_users_idx` (`user_id`),
  CONSTRAINT `fk_notifications_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel ovs-1.notifications: ~0 rows (lebih kurang)

-- membuang struktur untuk table ovs-1.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nik` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Nomor Induk Kependudukan atau ID Anggota unik.',
  `nama_lengkap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Simpan password yang sudah di-hash, jangan plain text.',
  `demographics` json DEFAULT NULL COMMENT 'Data demografi dalam format JSON, misal: {"kota": "Jakarta", "tgl_lahir": "2000-01-15"}',
  `role` enum('voter','admin') NOT NULL DEFAULT 'voter',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nik_kta` (`nik`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel ovs-1.users: ~2 rows (lebih kurang)
INSERT INTO `users` (`id`, `nik`, `nama_lengkap`, `email`, `password`, `demographics`, `role`, `created_at`) VALUES
	(1, '123456', 'admin', 'admin@blabla.com', '$2a$12$S7RnknvgXPO73HckRd9EseUS0mxepUdKwcJNUS35987gA7CSiGqBy', NULL, 'admin', '2025-08-20 08:08:26'),
	(2, '1234', 'voter', 'admin2@blabla.com', '$2a$12$S7RnknvgXPO73HckRd9EseUS0mxepUdKwcJNUS35987gA7CSiGqBy', NULL, 'voter', '2025-08-20 09:28:49');

-- membuang struktur untuk table ovs-1.votes
CREATE TABLE IF NOT EXISTS `votes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `candidate_id` bigint unsigned NOT NULL,
  `selfie_photo_url` varchar(255) NOT NULL COMMENT 'URL ke foto selfie sebagai bukti kehadiran.',
  `gps_coordinates` varchar(100) DEFAULT NULL COMMENT 'Koordinat GPS saat voting, format: "lat,lon".',
  `is_valid` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Status keabsahan suara (misal: setelah face matching).',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_vote_per_user_per_event` (`event_id`,`user_id`) COMMENT 'Memastikan satu user hanya bisa vote satu kali di satu event.',
  KEY `fk_votes_events_idx` (`event_id`),
  KEY `fk_votes_users_idx` (`user_id`),
  KEY `fk_votes_candidates_idx` (`candidate_id`),
  CONSTRAINT `fk_votes_candidates` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_votes_events` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_votes_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Membuang data untuk tabel ovs-1.votes: ~0 rows (lebih kurang)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
