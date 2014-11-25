CREATE DATABASE examin;
USE examin;

CREATE TABLE Standort
(
pkid int not null,
name varchar(255),
PRIMARY KEY(pkid)
);

CREATE TABLE Software
(
pkid int not null,
name varchar(255),
version varchar(20),
PRIMARY KEY(pkid)
);

CREATE TABLE Rechner
(
pkid int not null,
fkstandort int,
fksoftware int,
hostname varchar(255),
memory int,
disk int,
PRIMARY KEY (pkid),
FOREIGN KEY (fkstandort) REFERENCES Standort(pkid),
FOREIGN KEY (fksoftware) REFERENCES Software(pkid)
);

CREATE TABLE Statuslog
(
pkid int not null,
fkrechner int,
zeitpunkt varchar(19),
servicename varchar(50),
resultat varchar(5),
nachricht varchar(255),
PRIMARY KEY(pkid)
);

