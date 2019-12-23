--Script to generate the decay heat database
drop database if exists decay_heat_verification
create database decay_heat_verification
create table if not exists assembly(
    id int auto_increment not null primary key,
    assembly_name varchar(55),
    initial_enrichment float,
    burnup int
);