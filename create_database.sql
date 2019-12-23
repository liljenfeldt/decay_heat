--Script to generate the decay heat database
drop database if exists decay_heat_verification
create database if exists decay_heat_verification
use decay_heat_verification
create table if not exists assembly_type(
    id int auto_increment not null primary key,
    assembly_type_name varchar(55)
)
create table if not exists assembly(
    id int auto_increment not null primary key,
    assembly_name varchar(55),
    initial_enrichment float,
    burnup int,
    assembly_type_id int not null
    foreign key (assembly_type_id) references assembly_type(id)
);