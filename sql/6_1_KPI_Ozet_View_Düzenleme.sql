USE RetailAnalyticsDB;
GO

ALTER VIEW vw_Genel_KPI AS
SELECT
ID,
-- 1) Evde çocuk veya genç (Kidhome + Teenhome > 0) varsa 1, yoksa 0
--1.1)çocuklu müsteri oraný %71.51
CASE 
WHEN (ISNULL(Kidhome, 0) + ISNULL(Teenhome, 0))> 0 THEN 1
ELSE 0
END AS Cocuklu_Mu,

-- 2) Ýndirimli alýþveriþ ve toplam normal kanal alýþveriþleri
ISNULL(NumDealsPurchases, 0) AS Indirimli_Islem,
    (ISNULL(NumStorePurchases, 0) + ISNULL(NumWebPurchases, 0) + ISNULL(NumCatalogPurchases, 0)) AS Toplam_Normal_Islem,


-- 3) Ýndirimli alýþveriþ oraný
     CAST(ISNULL(NumDealsPurchases, 0)AS FLOAT)/ 
    NULLIF(ISNULL(NumStorePurchases, 0) + ISNULL(NumWebPurchases, 0) + ISNULL(NumCatalogPurchases, 0),0) AS Indirimli_Oran
FROM marketing_campaign_clean;
GO
