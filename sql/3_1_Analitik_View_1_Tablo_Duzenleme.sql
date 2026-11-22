USE RetailAnalyticsDB;
GO

--1. VIEW:Müþteri bazlý RFM skorlama ve segmentasyon tablosu
CREATE OR ALTER VIEW vw_Customer_RFM AS
WITH Customer_Metrics AS (
SELECT
ID,
(2026-Year_Birth) AS Yas,
Education,
Marital_Status,
Income,
(Kidhome+Teenhome) AS Toplam_Cocuk,
Recency,
(NumWebPurchases + NumCatalogPurchases + NumStorePurchases) AS Frequency,
(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Monetary,
NumWebPurchases,
NumCatalogPurchases,
NumStorePurchases,
NumDealsPurchases,
NumWebVisitsMonth,
Complain,
Response
FROM marketing_campaign_clean
),
RFM_Scores AS (
SELECT
*,
-- Recency (Gün) ne kadar KÜÇÜKSE müþteri o kadar tazedir -> Az gün = 5 puan
NTILE(5) OVER (ORDER BY Recency DESC)AS R_Score,
-- Frequency (Alýþveriþ sýklýðý) ne kadar BÜYÜKSE o kadar iyidir -> Çok alýþveriþ = 5 puan
NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
-- Monetary (Toplam harcama) ne kadar BÜYÜKSE o kadar iyidir -> Çok harcama = 5 puan
NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
FROM Customer_Metrics
)
SELECT
*,
(R_Score+F_Score+M_Score) AS Total_RFM_SCORE,
CASE
WHEN R_Score>=4 AND F_Score >= 4 AND M_Score >= 4 THEN  'Þampiyonlar'
WHEN F_Score >= 4 AND M_Score >= 3 THEN  'Sadýk Müþteriler'
WHEN R_Score >= 4 AND F_Score <= 2 THEN 'Yeni / Umut Veren'
WHEN R_Score <= 2 AND F_Score >= 3 THEN  'Kaybetme Riski'
WHEN R_Score <= 2 AND F_Score <= 2 THEN  'Uykuda / Kayýp'
ELSE 'Potansiyel Sadýk'
END AS Customer_Segment
FROM RFM_Scores;
GO
