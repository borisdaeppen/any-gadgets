SELECT Software.name FROM Rechner JOIN Software ON Rechner.fksoftware = Software.pkid JOIN Standort ON Rechner.fkstandort = Standort.pkid WHERE Standort.name = "E101";
