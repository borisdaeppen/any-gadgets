INSERT INTO Standort (pkid,name) VALUES (1,"E101");
INSERT INTO Standort (pkid,name) VALUES (2,"E303");
INSERT INTO Standort (pkid,name) VALUES (3,"E109");
INSERT INTO Standort (pkid,name) VALUES (4,"E210");

INSERT INTO Software (pkid,name,version) VALUES (1,"Debian", "Wheezy");
INSERT INTO Software (pkid,name,version) VALUES (2,"Windows", "8");
INSERT INTO Software (pkid,name,version) VALUES (3,"Solaris", "2011.11");
INSERT INTO Software (pkid,name,version) VALUES (4,"Ubuntu", "14.04.1 LTS (trusty)");

INSERT INTO Rechner (pkid,fkstandort,fksoftware,hostname,memory,disk) VALUES (1,4,3,"Neptun",4,500);
INSERT INTO Rechner (pkid,fkstandort,fksoftware,hostname,memory,disk) VALUES (2,1,1,"Zeus",8,250);
INSERT INTO Rechner (pkid,fkstandort,fksoftware,hostname,memory,disk) VALUES (3,1,4,"Athene",2,50);
INSERT INTO Rechner (pkid,fkstandort,fksoftware,hostname,memory,disk) VALUES (4,3,3,"Hades",16,2000);

INSERT INTO Statuslog (pkid,fkrechner,zeitpunkt,servicename,resultat,nachricht) VALUES (1,1,"2014-10-26 11:01:58","memory-check","OK","2.5");
INSERT INTO Statuslog (pkid,fkrechner,zeitpunkt,servicename,resultat,nachricht) VALUES (2,4,"2014-10-27 23:56:02","memory-check","ERR","15.9");
INSERT INTO Statuslog (pkid,fkrechner,zeitpunkt,servicename,resultat,nachricht) VALUES (3,4,"2014-10-27 23:56:08","disk-check","ERR","1992");
INSERT INTO Statuslog (pkid,fkrechner,zeitpunkt,servicename,resultat,nachricht) VALUES (4,2,"2014-10-28 07:00:01","up","OK","ssh-port respond");

