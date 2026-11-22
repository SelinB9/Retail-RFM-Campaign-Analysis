USE RetailAnalyticsDB;
GO 

CREATE VIEW vw_Urun_Kategorileri AS
SELECT ID, N'Þarap' AS Kategori, MntWines AS Harcama FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Et Ürünleri', MntMeatProducts FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Altýn', MntGoldProds FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Balýk', MntFishProducts FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Tatlý', MntSweetProducts FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Meyve', MntFruits FROM marketing_campaign_clean;
GO

CREATE VIEW vw_Kanal_Tercihleri AS
SELECT ID, N'Maðaza' AS Kanal, NumStorePurchases AS Islem_Adedi FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Web', NumWebPurchases FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Katalog', NumCatalogPurchases FROM marketing_campaign_clean
UNION ALL
SELECT ID, N'Ýndirimli', NumDealsPurchases FROM marketing_campaign_clean;
GO