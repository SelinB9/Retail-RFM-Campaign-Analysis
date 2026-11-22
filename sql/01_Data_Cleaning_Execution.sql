USE RetailAnalyticsDB;
GO

-- 1. Eksik (NULL) gelir kontrolü
SELECT COUNT(*) AS Eksik_Gelir_Sayisi
FROM marketing_campaign
WHERE Income IS NULL;

-- 2. Medeni durum kategorileri kontrolü
SELECT Marital_Status, COUNT(*) AS Kisi_Sayisi
FROM marketing_campaign
GROUP BY Marital_Status
ORDER BY Kisi_Sayisi DESC;

-- 3. Uç deðerler: En eski/en yeni doðum yýlý ve en düþük/en yüksek gelir
SELECT 
    MIN(Year_Birth) AS En_Eski_Dogum_Yili,
    MAX(Year_Birth) AS En_Yeni_Dogum_Yili,
    MIN(Income) AS En_Dusuk_Gelir,
    MAX(Income) AS En_Yuksek_Gelir
FROM marketing_campaign;



GO
-- 1. Boþ (NULL) olan 24 gelir kaydýný ortalama gelirle dolduruyoruz
UPDATE marketing_campaign
SET Income = (SELECT AVG(CAST(Income AS BIGINT)) FROM marketing_campaign WHERE Income IS NOT NULL)
WHERE Income IS NULL;

-- 2. Standart dýþý medeni durumlarý ('Alone', 'Absurd', 'YOLO') 'Single' altýnda birleþtiriyoruz
UPDATE marketing_campaign
SET Marital_Status = 'Single'
WHERE Marital_Status IN ('Alone', 'Absurd', 'YOLO');

-- 3. Mantýksýz doðum yýllarýný (1900 ve öncesi) ve 666.666'lýk aykýrý geliri siliyoruz
DELETE FROM marketing_campaign
WHERE Year_Birth <= 1900 OR Income > 600000;

/**bu komutlardan sonra öncesi sonrasý karþýlaþtýrma yapabilmek için veri tabaný tablo ismini _clean olarak deðiþtirdim */