USE RetailAnalyticsDB;
GO

--1. VIEW:Müþteri bazlý RFM skorlama ve segmentasyon tablosu
CREATE VIEW vw_Customer_RFM AS
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
WHEN R_Score>=4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions (Sampiyonlar)'
WHEN F_Score >= 4 AND M_Score >= 3 THEN 'Loyal Customers (Sadik Musteriler)'
WHEN R_Score >= 4 AND F_Score <= 2 THEN 'New / Promising (Yeni / Umut Veren)'
WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk (Kaybetme Riski)'
WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Hibernating (Uykuda / Kayip)'
ELSE 'Potential Loyalist (Potansiyel Sadik)'
END AS Customer_Segment
FROM RFM_Scores;
GO

--Test sorgusu: oluþan segmentlerin daðýlýmýný ve ortalama harcamalarý görelim
SELECT Customer_Segment,COUNT(*) AS Musteri_Sayisi, AVG(Monetary) AS Ortalama_Harcama
From vw_Customer_RFM
GROUP BY Customer_Segment
ORDER BY Musteri_Sayisi DESC;






--CREATE VIEW ... komutu 
--bir inþa (tanýmlama) komutudur; çalýþtýrdýðýnda ekrana veri dökmez, 
--sadece Messages sekmesinde "Commands completed successfully" yazar 
--ve arka planda Views klasörünün altýna sanal tabloyu kaydeder.
--Oluþturduðum o sanal tablonun gerçekten doðru hesaplama yapýp yapmadýðýný gözümüzle doðrulamak için hemen altýna o SELECT test sorgusunu ekledim.




GO
-- 2. VIEW: Pazarlama Kampanyalarý Katýlým ve Dönüþüm Oraný (ROI) Özeti
CREATE VIEW vw_Campaign_ROI AS
SELECT
'1. Kampanya (AcceptedCmp1)' AS Kampanya_Adi,
COUNT(*)AS Toplam_Musteri,
SUM(CAST(AcceptedCmp1 AS INT)) AS Kabul_Eden_Sayisi,
ROUND(CAST(SUM(CAST(AcceptedCmp1 AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS Katilim_Orani_Yuzde,
AVG(CASE WHEN AcceptedCmp1 = 1 THEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) END) AS Kabul_Eden_Ort_Harcama
FROM marketing_campaign_clean

UNION ALL

SELECT 
    '2. Kampanya (AcceptedCmp2)',
    COUNT(*),
    SUM(CAST(AcceptedCmp2 AS INT)),
    ROUND(CAST(SUM(CAST(AcceptedCmp2 AS INT)) AS FLOAT) / COUNT(*) * 100, 2),
    AVG(CASE WHEN AcceptedCmp2 = 1 THEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) END)
FROM marketing_campaign_clean

UNION ALL

SELECT 
    '3. Kampanya (AcceptedCmp3)',
    COUNT(*),
    SUM(CAST(AcceptedCmp3 AS INT)),
    ROUND(CAST(SUM(CAST(AcceptedCmp3 AS INT)) AS FLOAT) / COUNT(*) * 100, 2),
    AVG(CASE WHEN AcceptedCmp3 = 1 THEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) END)
FROM marketing_campaign_clean

UNION ALL

SELECT 
    '4. Kampanya (AcceptedCmp4)',
    COUNT(*),
    SUM(CAST(AcceptedCmp4 AS INT)),
    ROUND(CAST(SUM(CAST(AcceptedCmp4 AS INT)) AS FLOAT) / COUNT(*) * 100, 2),
    AVG(CASE WHEN AcceptedCmp4 = 1 THEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) END)
FROM marketing_campaign_clean

UNION ALL

SELECT 
    '5. Kampanya (AcceptedCmp5)',
    COUNT(*),
    SUM(CAST(AcceptedCmp5 AS INT)),
    ROUND(CAST(SUM(CAST(AcceptedCmp5 AS INT)) AS FLOAT) / COUNT(*) * 100, 2),
    AVG(CASE WHEN AcceptedCmp5 = 1 THEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) END)
FROM marketing_campaign_clean

UNION ALL

SELECT 
    '6. Son Kampanya (Response)',
    COUNT(*),
    SUM(CAST(Response AS INT)),
    ROUND(CAST(SUM(CAST(Response AS INT)) AS FLOAT) / COUNT(*) * 100, 2),
    AVG(CASE WHEN Response = 1 THEN (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) END)
FROM marketing_campaign_clean;
GO

--Test Sorgusu: 6 kampanyanýn performasýný karþýlaþtýrma
SELECT * FROM vw_Campaign_ROI
ORDER BY Katilim_Orani_Yuzde DESC;