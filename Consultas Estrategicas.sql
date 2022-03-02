---Capitalizacion del Mercado
CREATE VIEW Fluctuacion_Capitalizacion_Mercado 
AS 
SELECT MCV.Id_Fluctuation, MCV.Id_Cryptocurrency, CN.Cryptocurrency, D.Date, MCV.MarketCap
FROM [Market Cap and Volume] AS MCV 
INNER JOIN Date AS D ON MCV.Id_Date = D.Id_Date
INNER JOIN [Cryptocurrency Name] as CN ON CN.Id_Cryptocurrency = MCV.Id_Cryptocurrency

--Fluctuación del Volumen 
CREATE VIEW Fluctuacion_Volumen 
AS
SELECT MCV.Id_Fluctuation, MCV.Id_Cryptocurrency, CN.Cryptocurrency, D.Date, MCV.Volume
FROM [Market Cap and Volume] AS MCV 
INNER JOIN Date AS D ON MCV.Id_Date = D.Id_Date
INNER JOIN [Cryptocurrency Name] as CN ON CN.Id_Cryptocurrency = MCV.Id_Cryptocurrency

--Fluctuacion Precios
CREATE VIEW Fluctuacion_Precios
AS
SELECT MCV.Id_Fluctuation, MCV.Id_Cryptocurrency,CN.Cryptocurrency,D.Date, P.Cierre, P.Apertura, P.MasAlto, P.MasBajo
FROM Date AS D 
INNER JOIN [Market Cap and Volume] AS MCV ON D.Id_Date = MCV.Id_Date
INNER JOIN Prices AS P ON P.Id_Fluctuation = MCV.Id_Fluctuation
INNER JOIN [Cryptocurrency Name] AS CN ON MCV.Id_Cryptocurrency = CN.Id_Cryptocurrency


---Suministro Disponible por Criptomoneda. 
CREATE VIEW Suministros_Disponible
AS 
SELECT ASU.Id_Available, ASU.Id_Cryptocurrency, CN.Cryptocurrency, ASU.Available_suppy
FROM AvailableSuppy AS ASU
INNER JOIN [Cryptocurrency Name] AS CN ON ASU.Id_Cryptocurrency = CN.Id_Cryptocurrency



SELECT ASP.Id_Cryptocurrency, CN.Cryptocurrency, ASP.Available_suppy, CP.Platform
FROM AvailableSuppy AS ASP
INNER JOIN [Cryptocurrency Name] as CN ON ASP.Id_Cryptocurrency = CN.Id_Cryptocurrency
INNER JOIN CryptocurrencyPlatform AS CP ON ASP.Id_Platform = CP.Id_Platform;


--Cantidad de monedas por plataforma 

CREATE VIEW Cantidad_Monedas_x_Plataforma
AS
SELECT CP.Platform, COUNT(CN.Cryptocurrency) as 'Cantidad_Monedas'
FROM AvailableSuppy AS ASP
INNER JOIN [Cryptocurrency Name] as CN ON ASP.Id_Cryptocurrency = CN.Id_Cryptocurrency
INNER JOIN CryptocurrencyPlatform AS CP ON ASP.Id_Platform = CP.Id_Platform
GROUP BY CP.Platform


---Historico de las monedas del Market Cap y el Volumen. 
SELECT MCV.Id_Date, D.Date, CN.Id_Cryptocurrency, CN.Cryptocurrency, MCV.MarketCap, MCV.Volume
FROM Prices AS P 
INNER JOIN [Market Cap and Volume] AS MCV ON P.Id_Fluctuation = MCV.Id_Fluctuation
INNER JOIN [Cryptocurrency Name] AS CN ON CN.Id_Cryptocurrency = MCV.Id_Cryptocurrency
INNER JOIN Date AS D ON D.Id_Date = MCV.Id_Date 
ORDER BY CN.Id_Cryptocurrency ASC;


--InformaciÓn de  monedas de acuerdo al año en las que empiezan a tener registros. 
GO 
CREATE VIEW Monedas_x_año 
AS 
SELECT DISTINCT CN.Id_Cryptocurrency,CN.Cryptocurrency ,YEAR(D.Date) AS 'Año'
FROM Prices AS P 
INNER JOIN [Market Cap and Volume] AS MCV ON P.Id_Fluctuation = MCV.Id_Fluctuation
INNER JOIN [Cryptocurrency Name] AS CN ON CN.Id_Cryptocurrency = MCV.Id_Cryptocurrency
INNER JOIN Date AS D ON D.Id_Date = MCV.Id_Date;

--Clasificacion de las monedas por cantidad de años en los que tienen registros.
GO 
CREATE VIEW Monedas_x_cantidad_años
AS
SELECT Id_Cryptocurrency, Cryptocurrency, COUNT(Año) AS 'Cantidad_Años'
FROM Monedas_x_año
GROUP BY Id_Cryptocurrency, Cryptocurrency

SELECT * 
FROM Monedas_x_cantidad_años 
WHERE Cantidad_Años = 1
ORDER BY Cantidad_Años ASC


-- monedas que no tienen registros de precios, market cap y volumen en ningun año. 
CREATE VIEW Monedas_Sin_Registros 
AS 
SELECT CN.Id_Cryptocurrency, CN.Cryptocurrency, MCA.Cantidad_Años
FROM [Cryptocurrency Name] AS CN 
LEFT JOIN  Monedas_x_cantidad_años AS MCA ON CN.Id_Cryptocurrency = MCA.Id_Cryptocurrency
WHERE MCA.Cantidad_Años IS NULL;


--- Maximo volumen por año  de cada una de las monedas. 
CREATE VIEW Maximo_Volumen_x_AñoMoneda
AS
SELECT YEAR(D.Date) as 'Año', MCV.Id_Cryptocurrency, CN.Cryptocurrency, MAX(MCV.Volume) as 'Máximo_Volumen' 
FROM [Market Cap and Volume] AS MCV 
INNER JOIN Date AS D ON MCV.Id_Date = D.Id_Date
INNER JOIN [Cryptocurrency Name] AS CN ON CN.Id_Cryptocurrency = MCV.Id_Cryptocurrency
GROUP BY YEAR(D.Date), MCV.Id_Cryptocurrency, CN.Cryptocurrency;

---Maximo Market cap por año de cada una de las monedas.
CREATE VIEW Maximo_MarketCap_x_Año_Moneda
AS
SELECT  YEAR(D.Date) as 'Año', MCV.Id_Cryptocurrency,CN.Cryptocurrency, MAX(MCV.MarketCap) as 'Máximo_Market_Cap' 
FROM [Market Cap and Volume] AS MCV 
INNER JOIN Date AS D ON MCV.Id_Date = D.Id_Date
INNER JOIN [Cryptocurrency Name] AS CN ON CN.Id_Cryptocurrency = MCV.Id_Cryptocurrency
GROUP BY YEAR(D.Date), MCV.Id_Cryptocurrency, CN.Cryptocurrency



---Frecuencia de monedas por tipo de activo. 
CREATE VIEW Frecuencia_Moneda_x_Activo
AS
SELECT  AT.Type, COUNT(CA.Id_Cryptocurrency) AS 'Frecuencia_Monedas'
FROM CryptocurrencyActivity AS CA 
INNER JOIN AssetType AS AT  ON CA.Id_Asset = AT.Id_Asset
INNER JOIN CryptocurrencyStatus AS CS ON CA.Id_Status = CS.Id_Status
GROUP BY AT.Type 


--Cantidad de hombres y mujeres que invierten en criptomonedas. 
SELECT  SUBSTRING(Contact,1,2) AS 'Iniciales', COUNT(SUBSTRING(Contact,1,2)) as 'Cantidad_Hombres_Mujeres'
FROM [General Contact Information]
GROUP BY SUBSTRING(Contact,1,2)
ORDER BY COUNT(SUBSTRING(Contact,1,2)) ASC;

CREATE VIEW Inversionistas
AS
SELECT *,
   CASE
WHEN Contact LIKE 'Mr%' THEN 'Hombre'
WHEN Contact LIKE 'Ms%' THEN 'Mujer'
Else 'Mujer'
END AS 'Inversionista'
FROM [General Contact Information]

CREATE VIEW Distribucion_Inversiones_Hombre_Mujer
AS
SELECT Inversionista, COUNT(Id_Contact) AS Cantidad_Inversionitas
FROM Inversionistas
GROUP BY Inversionista


--¿De donde son las personas que invierten en criptomonedas? 
CREATE VIEW Frecuencia_Inversores_por_Ciudad
AS
SELECT CI.City, COUNT(GCI.Contact) AS 'Cantidad de Inversionitas'
FROM CityInformation AS CI 
INNER JOIN Investment AS I ON CI.Id_City = I.Id_City
INNER JOIN [General Contact Information] AS GCI ON I.Id_Contact = GCI.Id_Contact
GROUP BY CI.City 

---Inversiones Hechas
CREATE VIEW Inversiones_Hechas
AS

SELECT  I.Investment1 AS Criptomoneda, COUNT(I.Id_Contact) AS Inversiones
FROM Investment AS I 
WHERE I.Investment1 != '0'
GROUP BY I.Investment1

UNION

SELECT  I.Investment2, COUNT(I.Id_Contact) AS Cantidad_Personas_Inversion2
FROM Investment AS I 
WHERE I.Investment2 != '0'
GROUP BY I.Investment2

UNION

SELECT  I.Investment3, COUNT(I.Id_Contact) AS Cantidad_Personas_Inversion3
FROM Investment AS I 
WHERE I.Investment3 != '0'
GROUP BY I.Investment3

UNION

SELECT  I.Investment4, COUNT(I.Id_Contact) AS Cantidad_Personas_Inversion4
FROM Investment AS I 
WHERE I.Investment4 != '0'
GROUP BY I.Investment4

UNION

SELECT  I.Investment5, COUNT(I.Id_Contact) AS Cantidad_Personas_Inversion5
FROM Investment AS I 
WHERE I.Investment5 != '0'
GROUP BY I.Investment5

--Monedas en las que mas invierten las personas. 

CREATE VIEW Total_Inversiones
AS
SELECT Criptomoneda, SUM(Inversiones) as Inversiones
FROM Inversiones_Hechas
GROUP BY Criptomoneda;

SELECT * 
FROM Total_Inversiones
ORDER BY 
Inversiones DESC;

---Trabajos de las personas que mas invierten en criptomonedas.
CREATE VIEW Trabajos_Personas
AS
SELECT Position, COUNT(Id_Contact) AS Cantidad
FROM [General Contact Information]
WHERE Position NOT IN ('#N/A','0')
GROUP BY Position;






