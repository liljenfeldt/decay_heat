drop database if exists decay_heat_verification;
create database if not exists decay_heat_verification;
use decay_heat_verification;
create table if not exists assembly_type (
    id int auto_increment not null primary key,
    assembly_type_name varchar(55),
    UNIQUE(assembly_type_name)
);
create table if not exists assembly (
    id int auto_increment not null primary key,
    assembly_name varchar(55),
    initial_enrichment float,
    burnup int,
    assembly_type_id int,
    UNIQUE(assembly_name),
    foreign key (assembly_type_id) references assembly_type(id)
);
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
INSERT IGNORE INTO assembly_type (assembly_type_name) SELECT DISTINCT(ti.assembly_type) FROM temp_import ti;
INSERT IGNORE INTO assembly (assembly_name,initial_enrichment,burnup,assembly_type_id)
SELECT ti.assembly_name, ti.initial_enrichment, ti.burnup, at.id FROM temp_import ti
join assembly_type at on at.assembly_type_name = ti.assembly_type;
DROP TABLE temp_import;
SELECT * FROM assembly;