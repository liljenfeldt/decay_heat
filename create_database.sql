drop database if exists decay_heat_verification;
create database if not exists decay_heat_verification;
use decay_heat_verification;
create table temp_import (
    facility varchar(55),
    reactor varchar(55),
    assembly_type varchar(55),
    assembly_name varchar(55),
    initial_enrichment varchar(55),
    u_weight float,
    burnup int,
    dc_date date,
    m_date date,
    cooling_time float,
    measured_dh float,
    scale5_ornl float,
    reactor_type varchar(55)
);
LOAD DATA LOCAL INFILE '/home/noemi/python/decay_heat/decay_heat/epri_measure.csv'
    INTO TABLE temp_import
    COLUMNS TERMINATED BY ';'
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES
    (facility,reactor,assembly_type,assembly_name,initial_enrichment,u_weight,burnup,@dc_date,@m_date,cooling_time,measured_dh,scale5_ornl,reactor_type)
    set dc_date = STR_TO_DATE(@dc_date,'%m/%d/%Y'),
         m_date = STR_TO_DATE(@m_date,'%m/%d/%Y')
    ;

create table if not exists reactor_type (
    id int auto_increment not null primary key,
    reactor_type varchar(55) not null,
    UNIQUE(reactor_type)
);
INSERT IGNORE INTO reactor_type (reactor_type) 
    SELECT DISTINCT(ti.reactor_type) FROM temp_import ti;

create table if not exists reactor (
    id int auto_increment not null primary key,
    reactor_name varchar(55),
    country varchar(55),
    reactor_type_id int,
    UNIQUE(reactor_name),
    FOREIGN KEY (reactor_type_id) REFERENCES reactor_type(id)
);
INSERT IGNORE INTO reactor (reactor_name,reactor_type_id)
    SELECT ti.reactor, (SELECT id FROM reactor_type where reactor_type = max(ti.reactor_type)) 
    FROM temp_import ti GROUP BY ti.reactor;

create table if not exists assembly_type (
    id int auto_increment not null primary key,
    assembly_type_name varchar(55),
    UNIQUE(assembly_type_name)
);
INSERT IGNORE INTO assembly_type (assembly_type_name) 
    SELECT DISTINCT(ti.assembly_type) FROM temp_import ti;

create table if not exists assembly (
    id int auto_increment not null primary key,
    assembly_name varchar(55),
    initial_enrichment float,
    burnup int,
    discharge_date date,
    assembly_type_id int,
    reactor_id int,
    UNIQUE(assembly_name,reactor_id),
    foreign key (assembly_type_id) references assembly_type(id),
    foreign key (reactor_id) references reactor(id)
);
INSERT IGNORE INTO assembly (assembly_name,initial_enrichment,burnup,assembly_type_id,discharge_date,reactor_id)
    SELECT ti.assembly_name, ti.initial_enrichment, ti.burnup, at.id, ti.dc_date, r.id FROM temp_import ti
    join assembly_type at on at.assembly_type_name = ti.assembly_type
    join reactor r on r.reactor_name = ti.reactor;

CREATE TABLE IF NOT EXISTS measurement_facility (
    id int auto_increment not null primary key,
    measurement_facility_name varchar(55),
    country varchar(55),
    UNIQUE(measurement_facility_name)
);
INSERT IGNORE INTO measurement_facility (measurement_facility_name)
    SELECT DISTINCT(facility) FROM temp_import;

CREATE TABLE IF NOT EXISTS measurement (
    id int auto_increment not null primary key,
    assembly_id int,
    measurement_facility_id int,
    total_measured_decay_heat float,
    escape_gamma float,
    cal_decay_heat float,
    measurement_undertainty float,
    UNIQUE(assembly_id,measurement_facility_id),
    FOREIGN KEY (assembly_id) REFERENCES assembly(id)
    FOREIGN KEY (measurement_facility_id) REFERENCE measurement_facility(id)
);

-- DROP TABLE temp_import;
SELECT * FROM measurement_facility;