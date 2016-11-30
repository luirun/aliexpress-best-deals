-- MySQL dump 10.13  Distrib 5.7.11, for Win64 (x86_64)
--
-- Host: localhost    Database: aliexpress_development
-- ------------------------------------------------------
-- Server version	5.7.11-log

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
-- Table structure for table `ali_reviews`
--

DROP TABLE IF EXISTS `ali_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ali_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productId` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `username` text COLLATE utf8_unicode_ci,
  `user_country` text COLLATE utf8_unicode_ci,
  `user_order_rate` int(11) DEFAULT NULL,
  `user_order_info` text COLLATE utf8_unicode_ci,
  `review_date` text COLLATE utf8_unicode_ci,
  `review_content` text COLLATE utf8_unicode_ci,
  `review_photos` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `is_empty` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET utf8,
  `icon` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) DEFAULT NULL,
  `page` text COLLATE utf8_unicode_ci,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `accepted` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hot_products`
--

DROP TABLE IF EXISTS `hot_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hot_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productId` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `productTitle` text CHARACTER SET utf8,
  `productUrl` text CHARACTER SET utf8,
  `promotionUrl` text COLLATE utf8_unicode_ci,
  `imageUrl` text CHARACTER SET utf8,
  `originalPrice` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salePrice` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `discount` float DEFAULT NULL,
  `lotNum` int(11) DEFAULT NULL,
  `thirtydaysCommission` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `packageType` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `evaluateScore` float DEFAULT NULL,
  `validTime` date DEFAULT NULL,
  `quanity_sold` int(11) DEFAULT NULL,
  `commision` float DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `aff_url` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `category` int(11) NOT NULL DEFAULT '50',
  `subcategory` int(11) DEFAULT NULL,
  `sub_subcategory` int(11) DEFAULT NULL,
  `storeName` text COLLATE utf8_unicode_ci,
  `storeUrl` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productId` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `productTitle` text CHARACTER SET utf8,
  `productDescription` text COLLATE utf8_unicode_ci,
  `productUrl` text CHARACTER SET utf8,
  `promotionUrl` text COLLATE utf8_unicode_ci,
  `imageUrl` text CHARACTER SET utf8,
  `originalPrice` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salePrice` float DEFAULT NULL,
  `storeName` text CHARACTER SET utf8,
  `storeUrl` text COLLATE utf8_unicode_ci,
  `discount` float DEFAULT NULL,
  `lotNum` int(11) DEFAULT NULL,
  `thirtydaysCommission` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `packageType` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `evaluateScore` float DEFAULT NULL,
  `validTime` date DEFAULT NULL,
  `quanity_sold` int(11) DEFAULT NULL,
  `commision` float DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `aff_url` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `category` int(11) NOT NULL DEFAULT '50',
  `subcategory` int(11) DEFAULT NULL,
  `sub_subcategory` int(11) DEFAULT NULL,
  `is_hot` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_approved` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2107 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text COLLATE utf8_unicode_ci,
  `short_description` text COLLATE utf8_unicode_ci,
  `long_description` text COLLATE utf8_unicode_ci,
  `keywords` text COLLATE utf8_unicode_ci,
  `promoted` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `cover_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cover_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cover_file_size` int(11) DEFAULT NULL,
  `cover_updated_at` datetime DEFAULT NULL,
  `author` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subcategories`
--

DROP TABLE IF EXISTS `subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subcategories` (
  `parent` int(11) DEFAULT NULL,
  `name` text CHARACTER SET utf8,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=200048143 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nickname` text COLLATE utf8_unicode_ci,
  `password` text COLLATE utf8_unicode_ci,
  `password_digest` text COLLATE utf8_unicode_ci,
  `name` text COLLATE utf8_unicode_ci,
  `surname` text COLLATE utf8_unicode_ci,
  `description` text COLLATE utf8_unicode_ci,
  `email` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-30 20:26:37
INSERT INTO schema_migrations (version) VALUES ('20161024173458');

INSERT INTO schema_migrations (version) VALUES ('20161024175604');

INSERT INTO schema_migrations (version) VALUES ('20161024175632');

INSERT INTO schema_migrations (version) VALUES ('20161024192754');

INSERT INTO schema_migrations (version) VALUES ('20161102164014');

INSERT INTO schema_migrations (version) VALUES ('20161102173744');

INSERT INTO schema_migrations (version) VALUES ('20161102174357');

INSERT INTO schema_migrations (version) VALUES ('20161103151921');

INSERT INTO schema_migrations (version) VALUES ('20161103152143');

INSERT INTO schema_migrations (version) VALUES ('20161114181042');

