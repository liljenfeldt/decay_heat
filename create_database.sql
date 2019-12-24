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
LOAD DATA LOCAL INFILE '/home/noemi/python/decay_heat/decay_heat/epri_measure.csv'
    INTO TABLE assembly
    COLUMNS TERMINATED BY ';'
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES
    (@dummy,@dummy,@dummy,assembly_name,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy) 
    ;
SELECT * FROM assembly;