-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 27 Kas 2025, 20:36:44
-- Sunucu sürümü: 11.8.3-MariaDB-log
-- PHP Sürümü: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `u592601370_bwtest`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `actor_type` varchar(32) DEFAULT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `scope` varchar(64) DEFAULT NULL,
  `action` varchar(64) DEFAULT NULL,
  `meta_json` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `actor_type`, `actor_id`, `scope`, `action`, `meta_json`, `created_at`) VALUES
(94, 'admin', 3, 'agent_finance', 'adjust_balance', '{\"agent_id\":9,\"field\":\"current_cash\",\"amount_before\":\"125,278.00\",\"amount_after\":\"25,000.00\",\"reason\":\"s\"}', '2025-11-27 07:00:59'),
(95, 'admin', 3, 'withdrawal', 'completed', '{\"withdrawal_id\":1,\"site_id\":1,\"amount\":25000}', '2025-11-27 07:03:18'),
(96, 'admin', 3, 'agent', 'update_details', '{\"agent_id\":9}', '2025-11-27 07:55:58');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `deposit_quota_limit` decimal(16,2) NOT NULL DEFAULT 0.00,
  `deposit_quota_used` decimal(16,2) NOT NULL DEFAULT 0.00,
  `twofa_secret` varchar(64) DEFAULT NULL,
  `twofa_enabled` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `admins`
--

INSERT INTO `admins` (`id`, `username`, `password_hash`, `is_active`, `deposit_quota_limit`, `deposit_quota_used`, `twofa_secret`, `twofa_enabled`) VALUES
(3, 'admin', '$2y$10$OyaDkyWg/e.EtBA42N5te.qFYW2HW1JRVdJSgya0LOJbcwK9CCPkS', 1, 0.00, 0.00, NULL, 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `admin_crypto_wallets`
--

CREATE TABLE `admin_crypto_wallets` (
  `id` int(11) NOT NULL,
  `network` varchar(20) NOT NULL COMMENT 'Örn: TRC20, ERC20',
  `coin_symbol` varchar(10) NOT NULL COMMENT 'Örn: USDT, TRX',
  `address` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1: Aktif, 0: Pasif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `admin_crypto_wallets`
--

INSERT INTO `admin_crypto_wallets` (`id`, `network`, `coin_symbol`, `address`, `is_active`) VALUES
(1, 'TRC20', 'USDT', 'TQAk7joXsUNjKJ9zvok7ZN8UWqo7t4PJQW', 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_balance_logs`
--

CREATE TABLE `agent_balance_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(16,2) NOT NULL COMMENT 'Değişim miktarı (+ veya -)',
  `balance_before` decimal(16,2) NOT NULL,
  `balance_after` decimal(16,2) NOT NULL,
  `source_type` enum('manual_load','deposit_deduction','withdraw_refund','bonus') NOT NULL,
  `source_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'İlgili order id veya request id',
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_balance_requests`
--

CREATE TABLE `agent_balance_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(16,2) NOT NULL COMMENT 'Agentın gönderdiği nakit para',
  `bonus_rate` decimal(5,2) NOT NULL DEFAULT 2.50 COMMENT 'Verilen bonus oranı',
  `amount_credited` decimal(16,2) NOT NULL COMMENT 'Bakiyeye işlenen (Ana Para + Bonus)',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_note` varchar(255) DEFAULT NULL,
  `admin_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Onaylayan admin',
  `processed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_personnel`
--

CREATE TABLE `agent_personnel` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `role` enum('personnel','agent') DEFAULT 'personnel',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_personnel_logs`
--

CREATE TABLE `agent_personnel_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL COMMENT 'Ana Agent ID',
  `personnel_id` int(10) UNSIGNED NOT NULL COMMENT 'İşlemi yapan Personel ID',
  `action` varchar(50) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `agent_personnel_logs`
--

INSERT INTO `agent_personnel_logs` (`id`, `agent_id`, `personnel_id`, `action`, `details`, `ip_address`, `created_at`) VALUES
(100, 9, 9, 'deposit_confirmed', '{\"order_id\":256,\"amount_try\":5000,\"coin_type\":\"USDT\",\"coin_amount\":117.8134}', '78.135.60.66', '2025-11-27 06:58:54'),
(101, 9, 9, 'withdraw_paid', '{\"task_id\":26,\"amount\":4999}', '78.135.60.66', '2025-11-27 06:59:52'),
(102, 9, 9, 'deposit_confirmed', '{\"order_id\":257,\"amount_try\":50000,\"coin_type\":\"USDT\",\"coin_amount\":1178.1338}', '78.135.60.66', '2025-11-27 07:00:54'),
(103, 9, 9, 'deposit_confirmed', '{\"order_id\":258,\"amount_try\":10000,\"coin_type\":\"USDT\",\"coin_amount\":235.6268}', '78.135.60.66', '2025-11-27 07:06:55'),
(104, 9, 9, 'deposit_confirmed', '{\"order_id\":259,\"amount_try\":20000,\"coin_type\":\"USDT\",\"coin_amount\":471.2535}', '78.135.60.66', '2025-11-27 07:08:27'),
(105, 9, 9, 'deposit_confirmed', '{\"order_id\":260,\"amount_try\":10000,\"coin_type\":\"USDT\",\"coin_amount\":235.6268}', '78.135.60.66', '2025-11-27 07:16:30');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_profit_logs`
--

CREATE TABLE `agent_profit_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `type` enum('bonus_on_topup','profit_from_withdraw','profit_to_collateral','profit_withdraw','adjustment') NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `fee_amount` decimal(16,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `agent_profit_logs`
--

INSERT INTO `agent_profit_logs` (`id`, `agent_id`, `type`, `amount`, `fee_amount`, `description`, `created_at`) VALUES
(37, 9, 'adjustment', 300.00, 0.00, 'Yatırım Komisyonu (Talep ID: 258) - Oran: %3', '2025-11-27 07:06:55'),
(38, 9, 'profit_withdraw', 600.00, 6.00, 'Kâr çekim talebi (Cüzdan: 555)', '2025-11-27 07:08:38'),
(39, 9, 'profit_to_collateral', 200.00, 0.00, 'Kâr cüzdanından teminata aktarım.', '2025-11-27 07:09:02'),
(40, 9, 'profit_withdraw', 200.00, 2.00, 'Kâr çekim talebi (Cüzdan: 200)', '2025-11-27 07:09:13'),
(41, 9, 'profit_to_collateral', 400.00, 0.00, 'Kâr cüzdanından teminata aktarım.', '2025-11-27 07:09:19'),
(42, 9, 'profit_withdraw', 100.00, 1.00, 'Kâr çekim talebi (Cüzdan: 500)', '2025-11-27 07:16:38');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_profit_wallets`
--

CREATE TABLE `agent_profit_wallets` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `profit_amount` decimal(16,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_profit_withdraw_requests`
--

CREATE TABLE `agent_profit_withdraw_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `fee_rate` decimal(5,2) NOT NULL DEFAULT 1.00,
  `fee_amount` decimal(16,2) NOT NULL DEFAULT 0.00,
  `amount_after_fee` decimal(16,2) NOT NULL DEFAULT 0.00,
  `wallet_address` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected','paid') NOT NULL DEFAULT 'pending',
  `admin_id` int(10) UNSIGNED DEFAULT NULL,
  `admin_note` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `processed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_site_stats`
--

CREATE TABLE `agent_site_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `deposit_volume` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT 'Bu agent üzerinden bu siteye gelen toplam yatırım (site payı)',
  `withdraw_volume` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT 'Bu agente atanmış bu site çekimleri toplamı',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_trc20_wallets`
--

CREATE TABLE `agent_trc20_wallets` (
  `id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED NOT NULL,
  `address` varchar(128) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_withdraw_orders`
--

CREATE TABLE `agent_withdraw_orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `withdraw_request_id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED DEFAULT NULL,
  `agent_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Ödemeyi üstlenen agent',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT 'Sitedeki oyuncu ID',
  `site_user_username` varchar(100) DEFAULT NULL COMMENT 'Sitedeki oyuncu kullanıcı adı',
  `amount` decimal(16,2) NOT NULL COMMENT 'Ödenecek Tutar',
  `bank_name` varchar(100) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `status` enum('pending','assigned','paid','rejected','failed') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `assigned_at` datetime DEFAULT NULL COMMENT 'Agenta atandığı zaman',
  `completed_at` datetime DEFAULT NULL COMMENT 'Ödendiği zaman',
  `receipt_image` varchar(255) DEFAULT NULL COMMENT 'Agentın yüklediği dekont',
  `fail_reason` varchar(255) DEFAULT NULL,
  `to_bank_name` varchar(100) DEFAULT NULL,
  `to_iban` varchar(50) DEFAULT NULL,
  `to_full_name` varchar(150) DEFAULT NULL,
  `processed_by_agent_id` int(10) UNSIGNED DEFAULT NULL,
  `processed_by_personnel_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `agent_withdraw_overflow`
--

CREATE TABLE `agent_withdraw_overflow` (
  `id` int(10) UNSIGNED NOT NULL,
  `withdraw_request_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `amount_try` decimal(16,2) NOT NULL,
  `coin_amount` decimal(16,6) NOT NULL,
  `coin_type` varchar(16) NOT NULL DEFAULT 'USDT',
  `to_bank_name` varchar(255) NOT NULL,
  `to_iban` varchar(64) NOT NULL,
  `to_full_name` varchar(255) NOT NULL,
  `status` enum('waiting','assigned','done','cancelled') NOT NULL DEFAULT 'waiting',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `deposit_agents`
--

CREATE TABLE `deposit_agents` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `quota_limit` decimal(16,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `quota_used` decimal(14,2) NOT NULL DEFAULT 0.00,
  `email` varchar(190) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `commission_rate` decimal(5,2) NOT NULL DEFAULT 2.50,
  `balance` decimal(20,2) DEFAULT 0.00,
  `system_balance` decimal(16,2) NOT NULL DEFAULT 0.00,
  `current_cash` decimal(16,2) NOT NULL DEFAULT 0.00,
  `agent_profit_balance` decimal(16,2) NOT NULL DEFAULT 0.00,
  `total_profit_earned` decimal(16,2) NOT NULL DEFAULT 0.00,
  `total_profit_withdrawn` decimal(16,2) NOT NULL DEFAULT 0.00,
  `total_deposit_volume` decimal(16,2) NOT NULL DEFAULT 0.00,
  `total_withdraw_volume` decimal(16,2) NOT NULL DEFAULT 0.00,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `parent_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Bağlı olduğu Ana Agent ID',
  `role` enum('agent','personnel') NOT NULL DEFAULT 'agent',
  `last_login` datetime DEFAULT NULL,
  `two_factor_secret` varchar(32) DEFAULT NULL,
  `two_factor_enabled` tinyint(1) DEFAULT 0,
  `allowed_ips` text DEFAULT NULL COMMENT 'Virgülle ayrılmış IP listesi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `deposit_agents`
--

INSERT INTO `deposit_agents` (`id`, `name`, `phone`, `note`, `quota_limit`, `is_active`, `created_at`, `quota_used`, `email`, `password_hash`, `commission_rate`, `balance`, `system_balance`, `current_cash`, `agent_profit_balance`, `total_profit_earned`, `total_profit_withdrawn`, `total_deposit_volume`, `total_withdraw_volume`, `permissions`, `parent_id`, `role`, `last_login`, `two_factor_secret`, `two_factor_enabled`, `allowed_ips`) VALUES
(9, 'demo33', 'demo33', '', 0.00, 1, '2025-11-24 04:21:53', 0.00, 'demo33@g.com', '$2y$10$PxqfckgebxD85iT4DkB.RuBilheqLo4cOIwQPn.atxiktl.UhJ2vi', 3.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '[\"approve_deposit\",\"approve_withdraw\",\"manage_ibans\",\"request_balance\",\"manage_personnel\",\"view_reports\",\"view_profit_wallet\",\"view_profit_logs\"]', NULL, 'agent', '2025-11-27 10:09:27', NULL, 0, '');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `deposit_ibans`
--

CREATE TABLE `deposit_ibans` (
  `id` int(10) UNSIGNED NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `holder_name` varchar(255) DEFAULT NULL,
  `agent_id` int(10) UNSIGNED DEFAULT NULL,
  `owner_admin_id` int(10) UNSIGNED DEFAULT NULL,
  `iban` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `quota_limit` decimal(16,2) NOT NULL DEFAULT 0.00,
  `quota_used` decimal(16,2) NOT NULL DEFAULT 0.00,
  `min_deposit_limit` decimal(16,2) NOT NULL DEFAULT 100.00 COMMENT 'Minimum yatırım tutarı',
  `max_deposit_limit` decimal(16,2) NOT NULL DEFAULT 50000.00 COMMENT 'Maksimum yatırım tutarı',
  `max_daily_txn` int(11) NOT NULL DEFAULT 100 COMMENT 'Günlük maksimum işlem adedi',
  `current_daily_txn` int(11) NOT NULL DEFAULT 0 COMMENT 'Bugün kaç işlem aldı',
  `last_txn_date` date DEFAULT NULL COMMENT 'Sayaç sıfırlama için tarih kontrolü',
  `last_sms_text` text DEFAULT NULL COMMENT 'Son gelen banka SMS içeriği',
  `auto_approve` tinyint(1) DEFAULT 0 COMMENT '1 ise SMS ile otomatik onayla',
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `deposit_ibans`
--

INSERT INTO `deposit_ibans` (`id`, `bank_name`, `holder_name`, `agent_id`, `owner_admin_id`, `iban`, `is_active`, `quota_limit`, `quota_used`, `min_deposit_limit`, `max_deposit_limit`, `max_daily_txn`, `current_daily_txn`, `last_txn_date`, `last_sms_text`, `auto_approve`, `updated_at`, `created_at`) VALUES
(13, 'demo34', 'demo34', NULL, NULL, 'demo34', 1, 100000.00, 0.00, 100.00, 50000.00, 100, 0, NULL, NULL, 0, NULL, '2025-11-24 06:08:29'),
(14, 'akbank', 'akbank', 9, NULL, 'tr12333322221111555501', 1, 100000.00, 0.00, 100.00, 50000.00, 100, 0, NULL, NULL, 0, '2025-11-26 18:23:35', '2025-11-25 02:28:09');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `deposit_orders`
--

CREATE TABLE `deposit_orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED DEFAULT NULL,
  `iban_id` int(10) UNSIGNED DEFAULT NULL,
  `agent_id` int(10) UNSIGNED DEFAULT NULL,
  `coin_type` enum('TRX','USDT') NOT NULL,
  `amount_try` decimal(18,2) NOT NULL,
  `rate_try_per_unit` decimal(18,6) DEFAULT NULL,
  `coin_amount` decimal(18,6) DEFAULT NULL,
  `status` enum('pending','approved','rejected','cancelled','expired','user_cancelled') NOT NULL DEFAULT 'pending',
  `payment_method` enum('havale','crypto','credit_card') NOT NULL DEFAULT 'havale',
  `crypto_wallet_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expire_at` datetime NOT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `admin_id` int(10) UNSIGNED DEFAULT NULL,
  `processed_by_agent_id` int(10) UNSIGNED DEFAULT NULL,
  `processed_by_personnel_id` int(11) DEFAULT NULL,
  `fail_reason` varchar(255) DEFAULT NULL,
  `user_confirmed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `merchant_orders`
--

CREATE TABLE `merchant_orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `order_id` varchar(64) NOT NULL COMMENT 'Benzersiz işlem kodu',
  `amount_try` decimal(16,2) NOT NULL COMMENT 'Kullanıcının ödediği brüt TL',
  `commission_rate` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT 'O anki komisyon oranı',
  `commission_amount` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT 'Kesilen komisyon',
  `net_amount` decimal(16,2) NOT NULL COMMENT 'Site bakiyesine eklenen net TL',
  `coin_amount` decimal(18,8) NOT NULL COMMENT 'Kullanıcı cüzdanından düşen USDT',
  `coin_type` varchar(10) NOT NULL DEFAULT 'USDT',
  `status` enum('success','failed') NOT NULL DEFAULT 'success',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `merchant_orders`
--

INSERT INTO `merchant_orders` (`id`, `site_id`, `user_id`, `order_id`, `amount_try`, `commission_rate`, `commission_amount`, `net_amount`, `coin_amount`, `coin_type`, `status`, `created_at`) VALUES
(17, 1, 66, 'ORD-1764268724-2572', 5000.00, 4.00, 200.00, 4800.00, 117.78563000, 'USDT', 'success', '2025-11-27 18:38:44');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `merchant_player_withdraws`
--

CREATE TABLE `merchant_player_withdraws` (
  `id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT 'BetWallet User ID',
  `site_user_ref` varchar(100) DEFAULT NULL COMMENT 'Sitedeki Kullanıcı Adı',
  `order_id` varchar(64) NOT NULL COMMENT 'Site tarafından gönderilen benzersiz işlem kodu',
  `amount` decimal(16,2) NOT NULL COMMENT 'Çekilen Tutar (TL)',
  `net_amount` decimal(16,2) NOT NULL COMMENT 'Cüzdana Geçecek Tutar (TL)',
  `coin_amount` decimal(18,8) DEFAULT 0.00000000 COMMENT 'Cüzdana eklenecek karşılığı (USDT)',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_note` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `processed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(64) DEFAULT NULL,
  `setting_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`) VALUES
(1, 'deposit_iban', 'TR00 0000 0000 0000 0000 0000 00'),
(2, 'site_announcement', 'Sistem güncel bakiyenizden daha fazla çekim gönderemez, lütfen bakiyenizi kontrol edin. 2FA açık tutun. iletişim @betwallettr'),
(3, 'site_announcement_active', '1'),
(8, 'usdt_try_rate', '42.450000');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `sites`
--

CREATE TABLE `sites` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `register_url` varchar(255) DEFAULT NULL,
  `api_key` varchar(64) NOT NULL,
  `api_secret` varchar(128) NOT NULL,
  `callback_url` varchar(255) NOT NULL,
  `return_url` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `show_in_wallet` tinyint(1) NOT NULL DEFAULT 1,
  `commission_rate` decimal(5,2) NOT NULL DEFAULT 4.00,
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_deposit_volume` decimal(16,2) NOT NULL DEFAULT 0.00,
  `total_withdraw_volume` decimal(16,2) NOT NULL DEFAULT 0.00,
  `site_username` varchar(100) DEFAULT NULL,
  `site_password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `success_redirect_url` varchar(255) DEFAULT NULL COMMENT 'Başarılı yükleme sonrası kullanıcıyı yönlendirme linki (Örn: https://siteadi.com/deposit/success)',
  `net_balance` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Komisyon sonrası çekilebilir net bakiye',
  `two_factor_secret` varchar(32) DEFAULT NULL,
  `two_factor_enabled` tinyint(1) DEFAULT 0,
  `allowed_ips` text DEFAULT NULL COMMENT 'Virgülle ayrılmış IP listesi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `sites`
--

INSERT INTO `sites` (`id`, `name`, `slug`, `logo_url`, `register_url`, `api_key`, `api_secret`, `callback_url`, `return_url`, `is_active`, `show_in_wallet`, `commission_rate`, `balance`, `total_deposit_volume`, `total_withdraw_volume`, `site_username`, `site_password`, `created_at`, `success_redirect_url`, `net_balance`, `two_factor_secret`, `two_factor_enabled`, `allowed_ips`) VALUES
(1, 'Sekabet', 'sekabet', 'https://thedalton100.com/demotest/admin/955628d2-519d-4e79-927c-d2862bf26828.png', 'https://thedalton100.com/#sponsors', 'SEKABET_123', 'super_gizli_merchant_secret_987654321', 'https://yayincin.com/merchant/callback_test.php', 'https://sekabet.com/deposit/success', 1, 1, 4.00, 192788.48, 122627.00, 0.00, 'sekabet', '$2y$10$xMCwgoTXCdtotWGV.UngdO7zDWh9o1UEsgf8xt8By0a8hFVZPd4dy', '2025-11-21 10:47:21', 'https://thedalton100.com/#sponsors', 151874.60, NULL, 0, NULL),
(2, 'Betnano', 'betnano', 'https://thedalton100.com/demotest/admin/955628d2-519d-4e79-927c-d2862bf26828.png', '', '', '4e5506fea3fc3aa0d86069d62c138d12f529a7ce6af9fba983c2fa48195fee11', '', '', 1, 1, 4.00, 20872.00, 11325.00, 0.00, 'betnano', '$2y$10$CH5JSvdbKvCYXzEP5tfrAec71.iEVolHJzizDLcX7OHj.2Wmy3puG', '2025-11-21 19:17:42', NULL, 20872.00, NULL, 0, ''),
(3, 'Grandpashabet', 'pasha', 'https://thedalton100.com/demotest/admin/955628d2-519d-4e79-927c-d2862bf26828.png', '', '', '', '', '', 1, 1, 4.00, 0.00, 0.00, 0.00, NULL, NULL, '2025-11-21 19:17:56', NULL, 0.00, NULL, 0, NULL),
(5, 'Sekabet Demo', 'sekabet-demo', 'https://via.placeholder.com/64x64.png?text=SKB', NULL, 'SEKABET_DEMO_KEY', 'SEKABET_DEMO_SECRET', '', '', 1, 1, 0.04, 0.00, 0.00, 0.00, NULL, NULL, '2025-11-22 23:54:31', NULL, 0.00, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `site_balance_requests`
--

CREATE TABLE `site_balance_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_id` int(10) UNSIGNED DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `site_deposit_requests`
--

CREATE TABLE `site_deposit_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `order_id` varchar(64) NOT NULL,
  `amount_try` decimal(18,2) NOT NULL,
  `amount_coin` decimal(18,8) NOT NULL,
  `coin_type` enum('TRX','USDT') NOT NULL,
  `status` enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `site_personnel`
--

CREATE TABLE `site_personnel` (
  `id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `permissions` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `site_withdrawals`
--

CREATE TABLE `site_withdrawals` (
  `id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `wallet_address` varchar(255) NOT NULL,
  `status` enum('pending','completed','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `support_messages`
--

CREATE TABLE `support_messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `support_messages`
--

INSERT INTO `support_messages` (`id`, `ticket_id`, `user_id`, `is_admin`, `message`, `created_at`) VALUES
(5, 5, 68, 0, '123', '2025-11-27 19:46:20'),
(6, 5, 68, 0, '123', '2025-11-27 19:46:25');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `subject` varchar(200) NOT NULL,
  `status` enum('open','answered','closed') NOT NULL DEFAULT 'open',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_message_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `support_tickets`
--

INSERT INTO `support_tickets` (`id`, `user_id`, `subject`, `status`, `created_at`, `updated_at`, `last_message_at`) VALUES
(5, 68, '123', 'open', '2025-11-27 19:46:20', '2025-11-27 19:46:25', '2025-11-27 19:46:25');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `system_metrics_history`
--

CREATE TABLE `system_metrics_history` (
  `id` int(11) NOT NULL,
  `boss_pool_balance` decimal(20,2) NOT NULL,
  `short_term_liability` decimal(20,2) NOT NULL,
  `net_position` decimal(20,2) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `system_metrics_history`
--

INSERT INTO `system_metrics_history` (`id`, `boss_pool_balance`, `short_term_liability`, `net_position`, `created_at`) VALUES
(1, 0.00, 0.00, 0.00, '2025-11-27 09:03:06');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `phone_verified` tinyint(1) NOT NULL DEFAULT 0,
  `phone_verification_code` varchar(10) DEFAULT NULL,
  `phone_verification_expires_at` datetime DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `trc20_address` varchar(64) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `is_banned` tinyint(1) DEFAULT 0,
  `two_factor_secret` varchar(255) DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `is_2fa_enabled` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `users`
--

INSERT INTO `users` (`id`, `username`, `full_name`, `phone`, `phone_verified`, `phone_verification_code`, `phone_verification_expires_at`, `email`, `password`, `password_hash`, `trc20_address`, `created_at`, `is_banned`, `two_factor_secret`, `two_factor_enabled`, `is_2fa_enabled`) VALUES
(66, 'sekabet', NULL, NULL, 0, NULL, NULL, NULL, NULL, '$2y$10$lc0V.K2w9Wi0o2MFcHBQseALu3hCC8ewByQxqtRGrTY/lCyqc9McK', 'Tbf75b4f93455b5c12ea811b943b1b2', '2025-11-27 06:58:20', 0, NULL, 0, 0),
(67, 'Demo', NULL, NULL, 0, NULL, NULL, NULL, NULL, '$2y$10$4fSsmlURvpGZceBPBTH8/.QI678RWyEbslshGvhy.OznQSbrv9sQm', 'Te2a1d7f735cf720ee4285db2172647', '2025-11-27 18:11:02', 0, 'BUHD535OA7XOU5ZD', 0, 0),
(68, '123', NULL, NULL, 0, NULL, NULL, NULL, NULL, '$2y$10$FxuxZjH4Ag6napWbu4bUSuQjTmLae2XM49Vn5rU3BYV/BCAMGnPZO', 'T4f8bafbbcb3e7e7ffd66504565a044', '2025-11-27 19:34:14', 0, 'F5FDKD52MF2D3TK4', 0, 0),
(18286149, 'username', 'user name', '5469112233', 0, NULL, NULL, 'e@g.com', NULL, '$2y$10$v1LjRBKFhkLgnPKPo4Gpd.OWiN91JvYFvtWBU2dAE8VZk7kMc6F.6', 'T72c0470ec3cadf1fa889a275a8db88', '2025-11-27 19:56:29', 0, 'JJVW243ZIGO3K3XO', 0, 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `user_bank_accounts`
--

CREATE TABLE `user_bank_accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `bank_name` varchar(191) NOT NULL,
  `iban` varchar(34) NOT NULL,
  `account_holder` varchar(191) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `user_bank_accounts`
--

INSERT INTO `user_bank_accounts` (`id`, `user_id`, `bank_name`, `iban`, `account_holder`, `is_default`, `created_at`) VALUES
(6, 66, 'tr121111222233334444555501', 'TR121111222233334444555501', 'ahmet karaca', 1, '2025-11-27 06:59:16'),
(7, 68, '1', '11111111111111111111', '1', 1, '2025-11-27 19:34:38');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `user_sites`
--

CREATE TABLE `user_sites` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED NOT NULL,
  `site_username` varchar(100) NOT NULL,
  `site_balance_try` decimal(14,2) NOT NULL DEFAULT 0.00,
  `linked_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Tablo döküm verisi `user_sites`
--

INSERT INTO `user_sites` (`id`, `user_id`, `site_id`, `site_username`, `site_balance_try`, `linked_at`) VALUES
(24, 66, 1, 'test1', 50000.00, '2025-11-27 08:07:28'),
(25, 67, 1, 'test1', 0.00, '2025-11-27 18:11:22'),
(26, 68, 1, 'test1', 0.00, '2025-11-27 19:44:22');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `wallets`
--

CREATE TABLE `wallets` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `coin_type` enum('TRX','USDT') NOT NULL,
  `balance` decimal(20,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Tablo döküm verisi `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `coin_type`, `balance`, `created_at`) VALUES
(140, 66, 'TRX', 0.00, '2025-11-27 06:58:20'),
(141, 66, 'USDT', 118.13, '2025-11-27 06:58:20'),
(142, 67, 'TRX', 0.00, '2025-11-27 18:11:02'),
(143, 67, 'USDT', 0.00, '2025-11-27 18:11:02'),
(144, 66, 'USDT', -117.79, '2025-11-27 18:38:05'),
(145, 68, 'TRX', 0.00, '2025-11-27 19:34:14'),
(146, 68, 'USDT', 0.00, '2025-11-27 19:34:14'),
(147, 18286149, 'TRX', 0.00, '2025-11-27 19:56:29'),
(148, 18286149, 'USDT', 0.00, '2025-11-27 19:56:29');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `withdrawal_parts`
--

CREATE TABLE `withdrawal_parts` (
  `id` int(10) UNSIGNED NOT NULL,
  `withdraw_id` int(10) UNSIGNED NOT NULL,
  `agent_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(16,2) NOT NULL DEFAULT 0.00,
  `source` enum('agent','finance') NOT NULL DEFAULT 'agent',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `withdraw_requests`
--

CREATE TABLE `withdraw_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `site_id` int(10) UNSIGNED DEFAULT NULL,
  `coin_type` varchar(10) NOT NULL,
  `amount` decimal(18,6) NOT NULL,
  `method` enum('crypto','bank') NOT NULL DEFAULT 'crypto',
  `user_bank_name` varchar(100) DEFAULT NULL COMMENT 'Kullanıcının parayı istediği banka',
  `user_iban` varchar(50) DEFAULT NULL COMMENT 'Kullanıcının IBAN adresi',
  `user_full_name` varchar(150) DEFAULT NULL COMMENT 'IBAN sahibinin adı',
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Tablo için indeksler `admin_crypto_wallets`
--
ALTER TABLE `admin_crypto_wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `is_active` (`is_active`);

--
-- Tablo için indeksler `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `agent_balance_logs`
--
ALTER TABLE `agent_balance_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_log_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_balance_requests`
--
ALTER TABLE `agent_balance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bal_req_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_personnel`
--
ALTER TABLE `agent_personnel`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `agent_personnel_logs`
--
ALTER TABLE `agent_personnel_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_logs_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_profit_logs`
--
ALTER TABLE `agent_profit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_agent_profit_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_profit_wallets`
--
ALTER TABLE `agent_profit_wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_profit_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_profit_withdraw_requests`
--
ALTER TABLE `agent_profit_withdraw_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_apwr_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_site_stats`
--
ALTER TABLE `agent_site_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `agent_site_unique` (`agent_id`,`site_id`),
  ADD KEY `idx_site_id` (`site_id`),
  ADD KEY `idx_agent_id` (`agent_id`);

--
-- Tablo için indeksler `agent_trc20_wallets`
--
ALTER TABLE `agent_trc20_wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_withdraw_orders`
--
ALTER TABLE `agent_withdraw_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_w_site` (`site_id`),
  ADD KEY `idx_w_agent` (`agent_id`);

--
-- Tablo için indeksler `agent_withdraw_overflow`
--
ALTER TABLE `agent_withdraw_overflow`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_withdraw_request_id` (`withdraw_request_id`);

--
-- Tablo için indeksler `deposit_agents`
--
ALTER TABLE `deposit_agents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_agent_parent` (`parent_id`);

--
-- Tablo için indeksler `deposit_ibans`
--
ALTER TABLE `deposit_ibans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ibans_agent` (`agent_id`);

--
-- Tablo için indeksler `deposit_orders`
--
ALTER TABLE `deposit_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_order_iban` (`iban_id`),
  ADD KEY `fk_order_agent` (`agent_id`),
  ADD KEY `idx_site_id` (`site_id`);

--
-- Tablo için indeksler `merchant_orders`
--
ALTER TABLE `merchant_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mo_site` (`site_id`),
  ADD KEY `idx_mo_user` (`user_id`),
  ADD KEY `idx_mo_order` (`order_id`);

--
-- Tablo için indeksler `merchant_player_withdraws`
--
ALTER TABLE `merchant_player_withdraws`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_order` (`site_id`,`order_id`),
  ADD KEY `idx_mpw_site` (`site_id`),
  ADD KEY `idx_mpw_user` (`user_id`);

--
-- Tablo için indeksler `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Tablo için indeksler `sites`
--
ALTER TABLE `sites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `idx_site_username` (`site_username`);

--
-- Tablo için indeksler `site_balance_requests`
--
ALTER TABLE `site_balance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sbr_site` (`site_id`);

--
-- Tablo için indeksler `site_deposit_requests`
--
ALTER TABLE `site_deposit_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sdr_user` (`user_id`),
  ADD KEY `fk_sdr_site` (`site_id`);

--
-- Tablo için indeksler `site_personnel`
--
ALTER TABLE `site_personnel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sp_site` (`site_id`);

--
-- Tablo için indeksler `site_withdrawals`
--
ALTER TABLE `site_withdrawals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sw_site_id` (`site_id`);

--
-- Tablo için indeksler `support_messages`
--
ALTER TABLE `support_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_support_messages_ticket` (`ticket_id`);

--
-- Tablo için indeksler `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_support_tickets_user` (`user_id`);

--
-- Tablo için indeksler `system_metrics_history`
--
ALTER TABLE `system_metrics_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_at` (`created_at`);

--
-- Tablo için indeksler `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `trc20_address` (`trc20_address`);

--
-- Tablo için indeksler `user_bank_accounts`
--
ALTER TABLE `user_bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Tablo için indeksler `user_sites`
--
ALTER TABLE `user_sites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_site` (`user_id`,`site_id`),
  ADD KEY `idx_user_sites_user` (`user_id`),
  ADD KEY `fk_user_sites_site` (`site_id`);

--
-- Tablo için indeksler `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_wallet_user` (`user_id`);

--
-- Tablo için indeksler `withdrawal_parts`
--
ALTER TABLE `withdrawal_parts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_withdraw_id` (`withdraw_id`),
  ADD KEY `idx_agent_id` (`agent_id`);

--
-- Tablo için indeksler `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_wr_site` (`site_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- Tablo için AUTO_INCREMENT değeri `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `admin_crypto_wallets`
--
ALTER TABLE `admin_crypto_wallets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `agent_balance_logs`
--
ALTER TABLE `agent_balance_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tablo için AUTO_INCREMENT değeri `agent_balance_requests`
--
ALTER TABLE `agent_balance_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Tablo için AUTO_INCREMENT değeri `agent_personnel`
--
ALTER TABLE `agent_personnel`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `agent_personnel_logs`
--
ALTER TABLE `agent_personnel_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- Tablo için AUTO_INCREMENT değeri `agent_profit_logs`
--
ALTER TABLE `agent_profit_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- Tablo için AUTO_INCREMENT değeri `agent_profit_wallets`
--
ALTER TABLE `agent_profit_wallets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `agent_profit_withdraw_requests`
--
ALTER TABLE `agent_profit_withdraw_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Tablo için AUTO_INCREMENT değeri `agent_site_stats`
--
ALTER TABLE `agent_site_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `agent_trc20_wallets`
--
ALTER TABLE `agent_trc20_wallets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `agent_withdraw_orders`
--
ALTER TABLE `agent_withdraw_orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Tablo için AUTO_INCREMENT değeri `agent_withdraw_overflow`
--
ALTER TABLE `agent_withdraw_overflow`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `deposit_agents`
--
ALTER TABLE `deposit_agents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tablo için AUTO_INCREMENT değeri `deposit_ibans`
--
ALTER TABLE `deposit_ibans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Tablo için AUTO_INCREMENT değeri `deposit_orders`
--
ALTER TABLE `deposit_orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=261;

--
-- Tablo için AUTO_INCREMENT değeri `merchant_orders`
--
ALTER TABLE `merchant_orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Tablo için AUTO_INCREMENT değeri `merchant_player_withdraws`
--
ALTER TABLE `merchant_player_withdraws`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Tablo için AUTO_INCREMENT değeri `sites`
--
ALTER TABLE `sites`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `site_balance_requests`
--
ALTER TABLE `site_balance_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `site_deposit_requests`
--
ALTER TABLE `site_deposit_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `site_personnel`
--
ALTER TABLE `site_personnel`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Tablo için AUTO_INCREMENT değeri `site_withdrawals`
--
ALTER TABLE `site_withdrawals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `support_messages`
--
ALTER TABLE `support_messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `system_metrics_history`
--
ALTER TABLE `system_metrics_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18286150;

--
-- Tablo için AUTO_INCREMENT değeri `user_bank_accounts`
--
ALTER TABLE `user_bank_accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Tablo için AUTO_INCREMENT değeri `user_sites`
--
ALTER TABLE `user_sites`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Tablo için AUTO_INCREMENT değeri `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- Tablo için AUTO_INCREMENT değeri `withdrawal_parts`
--
ALTER TABLE `withdrawal_parts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `agent_balance_logs`
--
ALTER TABLE `agent_balance_logs`
  ADD CONSTRAINT `fk_log_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `agent_balance_requests`
--
ALTER TABLE `agent_balance_requests`
  ADD CONSTRAINT `fk_bal_req_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `agent_profit_logs`
--
ALTER TABLE `agent_profit_logs`
  ADD CONSTRAINT `fk_agent_profit_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `agent_profit_wallets`
--
ALTER TABLE `agent_profit_wallets`
  ADD CONSTRAINT `fk_profit_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `agent_profit_withdraw_requests`
--
ALTER TABLE `agent_profit_withdraw_requests`
  ADD CONSTRAINT `fk_apwr_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `agent_withdraw_orders`
--
ALTER TABLE `agent_withdraw_orders`
  ADD CONSTRAINT `fk_aw_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`),
  ADD CONSTRAINT `fk_aw_site` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`);

--
-- Tablo kısıtlamaları `deposit_agents`
--
ALTER TABLE `deposit_agents`
  ADD CONSTRAINT `fk_agent_parent` FOREIGN KEY (`parent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `deposit_ibans`
--
ALTER TABLE `deposit_ibans`
  ADD CONSTRAINT `fk_ibans_agent` FOREIGN KEY (`agent_id`) REFERENCES `deposit_agents` (`id`) ON DELETE SET NULL;

--
-- Tablo kısıtlamaları `deposit_orders`
--
ALTER TABLE `deposit_orders`
  ADD CONSTRAINT `fk_deposit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `site_balance_requests`
--
ALTER TABLE `site_balance_requests`
  ADD CONSTRAINT `fk_sbr_site` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `site_deposit_requests`
--
ALTER TABLE `site_deposit_requests`
  ADD CONSTRAINT `fk_sdr_site` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`),
  ADD CONSTRAINT `fk_sdr_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Tablo kısıtlamaları `site_personnel`
--
ALTER TABLE `site_personnel`
  ADD CONSTRAINT `fk_sp_site` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `site_withdrawals`
--
ALTER TABLE `site_withdrawals`
  ADD CONSTRAINT `fk_sw_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `support_messages`
--
ALTER TABLE `support_messages`
  ADD CONSTRAINT `fk_support_messages_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `fk_support_tickets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `user_sites`
--
ALTER TABLE `user_sites`
  ADD CONSTRAINT `fk_user_sites_site` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`),
  ADD CONSTRAINT `fk_user_sites_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Tablo kısıtlamaları `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `fk_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
