/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS 
** File:  final project 
** Author: Zoey
** Desc:   Creating the final project model 
************************************************/


/*!40101 SET NAMES utf8 */;
/*!40101 SET SQL_MODE=''*/;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/FP/*!40100 DEFAULT CHARACTER SET latin1 */;

USE FP;

##Table FP.FBI_code

CREATE TABLE IF NOT EXISTS FP.FBI_code (
  FBI_code VARCHAR(45) NOT NULL,
  FBI_code_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (FBI_code))
ENGINE=InnoDB DEFAULT CHARSET=latin1;

SELECT * FROM FP.FBI_code; 

CREATE TABLE Ward (
    ward_id INT,
    alderman_name VARCHAR(45),
    ward_address VARCHAR(45),
    ward_city VARCHAR(45),
    ward_district VARCHAR(45),
    ward_zipcode VARCHAR(45),
    ward_email VARCHAR(45),
    ward_phone VARCHAR(45),
    PRIMARY KEY (ward_id)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

SELECT * FROM Ward;

##Table FP.IUCR
CREATE TABLE IUCR (
    IUCR_id varchar(45),
    primary_description varchar(45),
    secondary_description varchar(45),
    PRIMARY KEY (IUCR_id)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

SELECT * FROM IUCR;

##Table FP.Ward
CREATE TABLE Ward (
    ward_id int,
    alderman_name varchar(45),
    ward_address varchar(45),
    ward_city varchar(45),
    ward_district varchar(45),
    ward_zipcode varchar(45),
    ward_email varchar(45),
    ward_phone varchar(45),
    PRIMARY KEY (ward_id)

SELECT * FROM Ward;

##table FP.district 
CREATE TABLE District (
    district_num INT,
    distrct_name VARCHAR(45),
    PRIMARY KEY (district_num)
);

SELECT 
    *
FROM
    district;

##Table FP.Community_area
CREATE TABLE Community_area (
    community_area_id INT,
    community_name VARCHAR(45),
    community_area_sqmi DOUBLE,
    community_density_sqmi DOUBLE,
    community_population INT,
    PRIMARY KEY (community_area_id)
);

SELECT 
    *
FROM
    Community_area;

##Table Crime
CREATE TABLE Crime (
    crime_id int,
    crime_case varchar(45),
    crime_date varchar(45),
    crime_block varchar(45),
    IUCR_id varchar(45),
    location_description varchar(45),
    arrest varchar(45),
    domestic varchar(45),
    beat varchar(45),
    district_id int,
    ward_id int,
    community_area_id int,
    FBI_code varchar(45),
    incident_year varchar(45),
    latitude varchar(45),
    longitude varchar(45),
	crime_datetime datetime GENERATED ALWAYS AS (STR_TO_DATE(crime_date, '%m/%d/%Y %r')),
    PRIMARY KEY (crime_id),
    FOREIGN KEY (IUCR_id) REFERENCES IUCR(IUCR_id),
    FOREIGN KEY (district_id) REFERENCES District(district_num),
    FOREIGN KEY (ward_id) REFERENCES Ward(ward_id),
    FOREIGN KEY (community_area_id) REFERENCES Community_area(community_area_id),
    FOREIGN KEY (FBI_code) REFERENCES FBI_code(FBI_code)
);

SELECT 
    *
FROM
    Crime;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;