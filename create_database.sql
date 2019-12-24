drop database if exists decay_heat_verification;
create database if not exists decay_heat_verification;
use decay_heat_verification;
create table if not exists assembly_type (
    id int auto_increment not null primary key,
    assembly_type_name varchar(55)
);
create table if not exists assembly (
    id int auto_increment not null primary key,
    assembly_name varchar(55),
    initial_enrichment float,
    burnup int,
    assembly_type_id int,
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
    dc_date varchar(55),
    m_date varchar(55),
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
    (facility,reactor,assembly_type,assembly_name,initial_enrichment,u_weight,burnup,dc_date,m_date,cooling_time,measured_dh,scale5_ornl,reactor_type)
    ;
SELECT * FROM temp_import;
drop table temp_import;
SELECT * FROM assembly;