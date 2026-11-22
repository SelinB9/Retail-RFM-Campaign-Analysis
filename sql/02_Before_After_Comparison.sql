USE RetailAnalyticsDB;
GO

-- =========================================================================
-- BÖLÜM 1: ÖNCESÝ - HAM VERÝDEKÝ HATALARIN TESPÝTÝ (marketing_campaign_raw)
-- =========================================================================

-- Tespit 1: Boþ (NULL) Gelir Kayýtlarý (Sonuç: 24 çýkacak)
SELECT '1. Ham Veri (Öncesi)' AS Durum, COUNT(*) AS Eksik_Gelir_Sayisi
FROM marketing_campaign_raw
WHERE Income IS NULL;

-- Tespit 2: Standart Dýþý Medeni Durumlar (Alone, Absurd, YOLO görünecek)
SELECT '1. Ham Veri (Öncesi)' AS Durum, Marital_Status, COUNT(*) AS Kisi_Sayisi
FROM marketing_campaign_raw
GROUP BY Marital_Status
ORDER BY Kisi_Sayisi DESC;

-- Tespit 3: Aykýrý Doðum Yýlý ve Gelir Deðerleri (1893 ve 666.666 görünecek)
SELECT '1. Ham Veri (Öncesi)' AS Durum, 
       MIN(Year_Birth) AS En_Eski_Dogum_Yili, 
       MAX(Income) AS En_Yuksek_Gelir
FROM marketing_campaign_raw;

GO

-- =========================================================================
-- BÖLÜM 2: TEMÝZLÝK ÝÞLEMLERÝ (Bu komutlarla ham veriden temiz tablo üretildi)
-- =========================================================================
/*
1. UPDATE marketing_campaign_clean SET Income = (Ortalama Gelir) WHERE Income IS NULL; -> 24 boþ kayýt dolduruldu.
2. UPDATE marketing_campaign_clean SET Marital_Status = 'Single' WHERE Marital_Status IN ('Alone', 'Absurd', 'YOLO'); -> 7 kayýt birleþtirildi.
3. DELETE FROM marketing_campaign_clean WHERE Year_Birth <= 1900 OR Income > 600000; -> 4 aykýrý satýr silindi.
*/

-- =========================================================================
-- BÖLÜM 3: SONRASI - TEMÝZLENMÝÞ TABLO DOÐRULAMASI (marketing_campaign_clean)
-- =========================================================================

-- Doðrulama 1: Eksik Gelir Sýfýrlandý (Sonuç: 0 çýkacak)
SELECT '2. Temiz Veri (Sonrasý)' AS Durum, COUNT(*) AS Eksik_Gelir_Sayisi
FROM marketing_campaign_clean
WHERE Income IS NULL;

-- Doðrulama 2: Medeni Durumlar Standartlaþtý (Sadece 5 temiz kategori kalacak)
SELECT '2. Temiz Veri (Sonrasý)' AS Durum, Marital_Status, COUNT(*) AS Kisi_Sayisi
FROM marketing_campaign_clean
GROUP BY Marital_Status
ORDER BY Kisi_Sayisi DESC;

-- Doðrulama 3: Aykýrý Deðerler Temizlendi (1940 ve 162.397 görünecek)
SELECT '2. Temiz Veri (Sonrasý)' AS Durum, 
       MIN(Year_Birth) AS En_Eski_Dogum_Yili, 
       MAX(Income) AS En_Yuksek_Gelir
FROM marketing_campaign_clean;