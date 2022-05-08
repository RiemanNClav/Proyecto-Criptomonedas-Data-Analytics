CREATE VIEW Tipo_Status 
AS
SELECT  CA.Id_Cryptocurrency, AT.Type, CS.Status
FROM [dbo].[CryptocurrencyActivity] AS CA 
INNER JOIN [dbo].[AssetType] AS AT ON CA.Id_Asset = AT.Id_Asset
INNER JOIN [dbo].[CryptocurrencyStatus] AS CS ON CS.Id_Status = CA.Id_Status

CREATE VIEW Cantidad_x_Plataforma
AS
SELECT CN.Cryptocurrency, CP.Platform
FROM [dbo].[CryptocurrencyPlatform] AS CP 
INNER JOIN [dbo].[AvailableSuppy] AS ASP ON CP.Id_Platform = ASP.Id_Platform
INNER JOIN [Cryptocurrency Name] AS CN ON ASP.Id_Cryptocurrency = CN.Id_Cryptocurrency