

CREATE VIEW Cripo_x_inversor 
AS
SELECT Id_Contact, Investment1
FROM [dbo].[Investment]
WHERE Id_Contact != 0
UNION
SELECT Id_Contact, Investment2
FROM [dbo].[Investment]
WHERE Id_Contact != 0
UNION
SELECT Id_Contact, Investment3
FROM [dbo].[Investment]
WHERE Id_Contact != 0
UNION
SELECT Id_Contact, Investment4
FROM [dbo].[Investment]
WHERE Id_Contact != 0


CREATE VIEW Inversion_x_NomPersona
AS
SELECT I.Id_Contact, I.Contact, I.Position, CI.Investment1 as Inversion 
FROM Inversionistas AS I 
INNER JOIN [dbo].[Cripo_x_inversor] AS CI ON I.Id_Contact = CI.Id_Contact
INNER JOIN [Cryptocurrency Name] AS CN ON CI.Investment1 = CN.Cryptocurrency
WHERE CN.Cryptocurrency != '0'

-- Una sola persona hizo la misma inversion desde distinta ciudad. 
CREATE VIEW Ciudad_x_inversion
AS
SELECT  CI.Id_City, CI.City, I.Id_Contact, GCI.Contact
FROM Investment AS I
INNER JOIN CityInformation AS CI ON I.Id_City = CI.Id_City
INNER JOIN [General Contact Information] AS GCI ON GCI.Id_Contact = I.Id_Contact



CREATE VIEW Tabla_intermedia
AS
SELECT  Id_Contact, COUNT(Inversion) AS Inversiones
FROM Inversion_x_NomPersona
GROUP BY Id_Contact







SELECT DISTINCT I.Id_Contact, COUNT(CI.City)
FROM Investment AS I
INNER JOIN CityInformation AS CI ON I.Id_City = CI.Id_City
GROUP BY I.Id_Contact
HAVING COUNT(CI.City) > 1;


SELECT I.Id_City, CI.City, GCI.Id_Contact, GCI.Contact  
FROM Investment AS I
INNER JOIN CityInformation AS CI ON CI.Id_City = I.Id_City
INNER JOIN [General Contact Information] AS GCI ON GCI.Id_Contact = I.Id_Contact

-----------------------------------------------------------------------------------------------------------------------------------

