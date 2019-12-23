--Script to generate the decay heat database
drop database if exists decay_heat_verification
create database decay_heat_verification
create table if not exists element(
    id int,
    element_namn varchar(55)
);