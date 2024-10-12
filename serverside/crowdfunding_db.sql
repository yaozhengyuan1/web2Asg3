/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50721
 Source Host           : localhost:3306
 Source Schema         : t1

 Target Server Type    : MySQL
 Target Server Version : 50721
 File Encoding         : 65001

 Date: 12/10/2024 02:27:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for FUNDRAISER
-- ----------------------------
DROP TABLE IF EXISTS `FUNDRAISER`;
CREATE TABLE `FUNDRAISER` (
  `FUNDRAISER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ORGANIZER` varchar(255) NOT NULL,
  `CAPTION` varchar(255) NOT NULL,
  `TARGET_FUNDING` decimal(10,2) NOT NULL,
  `CURRENT_FUNDING` decimal(10,2) NOT NULL,
  `CITY` varchar(255) NOT NULL,
  `ACTIVE` tinyint(1) NOT NULL,
  `CATEGORY_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`FUNDRAISER_ID`) USING BTREE,
  KEY `CATEGORY_ID` (`CATEGORY_ID`) USING BTREE,
  CONSTRAINT `FUNDRAISER_ibfk_1` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `category` (`CATEGORY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of FUNDRAISER
-- ----------------------------
BEGIN;
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (1, 'Jackson Family', 'Help The Jacksons Rebuild After Flood', 30000.00, 7394.00, 'Byron Bay', 0, 1);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (2, 'Xiaoshan School', 'Fund New Library for Xiaoshan School', 9000.00, 5000.00, 'Coffs Harbour', 1, 2);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (3, 'Animal Shelter', 'Support the Local Animal Shelter', 13000.00, 6000.00, 'Lismore', 1, 5);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (4, 'Community Garden', 'Build a Community Garden', 7000.00, 2000.00, 'Sydney', 1, 2);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (5, 'Medical Fund', 'Help Jane with Her Medical Bills', 10000.00, 25000.00, 'Tweed Heads', 1, 1);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (6, 'Sports Club', 'Renovate the Local Sports Club', 8000.00, 4000.00, 'Gold Coast', 1, 3);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (7, 'Green Initiative', 'Plant Trees in the Community', 5000.00, 1000.00, 'Newcastle', 1, 3);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (8, 'Tech Fund', 'Support Rural Tech Education', 12000.00, 8500.00, 'Brisbane', 1, 2);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (9, 'Homeless Shelter', 'Provide Supplies for the Homeless', 15000.00, 9500.00, 'Canberra', 1, 3);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (10, 'Wildlife Conservation', 'Save Local Wildlife', 20000.00, 12000.00, 'Darwin', 1, 3);
INSERT INTO `FUNDRAISER` (`FUNDRAISER_ID`, `ORGANIZER`, `CAPTION`, `TARGET_FUNDING`, `CURRENT_FUNDING`, `CITY`, `ACTIVE`, `CATEGORY_ID`) VALUES (13, '7777777', '7777777', 77777.00, 777777.00, '777777777', 0, 3);
COMMIT;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `CATEGORY_ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`CATEGORY_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
BEGIN;
INSERT INTO `category` (`CATEGORY_ID`, `NAME`) VALUES (1, 'Medical');
INSERT INTO `category` (`CATEGORY_ID`, `NAME`) VALUES (2, 'Education');
INSERT INTO `category` (`CATEGORY_ID`, `NAME`) VALUES (3, 'Social Impact');
INSERT INTO `category` (`CATEGORY_ID`, `NAME`) VALUES (4, 'Environment');
INSERT INTO `category` (`CATEGORY_ID`, `NAME`) VALUES (5, 'Community');
COMMIT;

-- ----------------------------
-- Table structure for donation
-- ----------------------------
DROP TABLE IF EXISTS `donation`;
CREATE TABLE `donation` (
  `DONATION_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATE` date NOT NULL,
  `AMOUNT` decimal(10,2) NOT NULL,
  `GIVER` varchar(100) NOT NULL,
  `FUNDRAISER_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`DONATION_ID`) USING BTREE,
  KEY `FUNDRAISER_ID` (`FUNDRAISER_ID`) USING BTREE,
  CONSTRAINT `donation_ibfk_1` FOREIGN KEY (`FUNDRAISER_ID`) REFERENCES `FUNDRAISER` (`FUNDRAISER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of donation
-- ----------------------------
BEGIN;
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (1, '2024-10-01', 100.00, 'Alice', 1);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (2, '2024-10-02', 150.00, 'Bob', 1);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (3, '2024-10-03', 200.00, 'Charlie', 2);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (4, '2024-10-04', 300.00, 'David', 3);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (5, '2024-10-05', 400.00, 'Eva', 4);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (6, '2024-10-06', 500.00, 'Frank', 5);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (7, '2024-10-07', 250.00, 'Grace', 6);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (8, '2024-10-08', 350.00, 'Hannah', 7);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (9, '2024-10-09', 450.00, 'Isaac', 8);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (10, '2024-10-10', 600.00, 'James', 9);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (11, '2024-10-11', 100.00, 'ywy100p', 2);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (12, '2024-10-11', 111.00, 'Joe', 2);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (13, '2024-10-11', 300.00, 'yyy', 5);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (14, '2024-10-11', 78777777.00, '777', 2);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (15, '2024-10-11', 22222222.00, '22222', 1);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (16, '2024-10-11', 2348.00, 'fdfdsfsd', 10);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (17, '2024-10-11', 2323232.00, 'fffff', 1);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (18, '2024-10-11', 2000000.00, 'hghh', 1);
INSERT INTO `donation` (`DONATION_ID`, `DATE`, `AMOUNT`, `GIVER`, `FUNDRAISER_ID`) VALUES (19, '2024-10-11', 324324.00, 'ffffff', 2);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
