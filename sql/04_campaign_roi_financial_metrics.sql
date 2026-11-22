USE RetailAnalyticsDB;
GO

CREATE OR ALTER VIEW vw_Campaign_ROI AS
WITH CampaignData AS (
    SELECT '1. Kampanya' AS Kampanya_Adi, 1 AS Sira_No, SUM(CAST(AcceptedCmp1 AS INT)) AS Kabul_Eden_Kisi, COUNT(*) AS Toplam_Musteri FROM dbo.marketing_campaign_clean
    UNION ALL
    SELECT '2. Kampanya ', 2, SUM(CAST(AcceptedCmp2 AS INT)), COUNT(*) FROM marketing_campaign_clean
    UNION ALL
    SELECT '3. Kampanya ', 3, SUM(CAST(AcceptedCmp3 AS INT)), COUNT(*) FROM marketing_campaign_clean
    UNION ALL
    SELECT '4. Kampanya ', 4, SUM(CAST(AcceptedCmp4 AS INT)), COUNT(*) FROM marketing_campaign_clean
    UNION ALL
    SELECT '5. Kampanya ', 5, SUM(CAST(AcceptedCmp5 AS INT)), COUNT(*) FROM marketing_campaign_clean
    UNION ALL
    SELECT '6. Son Kampanya ', 6, SUM(CAST(Response AS INT)), COUNT(*) FROM marketing_campaign_clean
),
FinancialBase AS(
SELECT 
    Kampanya_Adi,
    Sira_No,
    Kabul_Eden_Kisi,
    Toplam_Musteri,
    11 AS Birim_Gelir,
    3 AS Birim_Maliyet,
    CAST(ROUND((Kabul_Eden_Kisi * 100.0) / Toplam_Musteri, 2) AS DECIMAL(5,2)) AS Katilim_Orani_Yuzde,
    (Kabul_Eden_Kisi * 11) AS Kampanya_Geliri,
    (Toplam_Musteri * 3) AS Kampanya_Iletisim_Maliyeti,
    ((Kabul_Eden_Kisi * 11) - (Toplam_Musteri * 3)) AS Kampanya_Net_Kar
FROM CampaignData
)
SELECT
*,
CAST(ROUND(((Kampanya_Geliri - Kampanya_Iletisim_Maliyeti) * 100.0) / Kampanya_Iletisim_Maliyeti, 2) AS DECIMAL(6,2)) AS Kampanya_ROI_Yuzde,
CAST(ROUND((Birim_Maliyet * 100.0) / Birim_Gelir, 1) AS DECIMAL(5,1)) AS Karlilik_Esigi_Yuzde,
    CAST(ROUND(Katilim_Orani_Yuzde - ((Birim_Maliyet * 100.0) / Birim_Gelir), 2) AS DECIMAL(6,2)) AS Esik_Farki_Puan,
    CASE 
        WHEN Katilim_Orani_Yuzde >= ((Birim_Maliyet * 100.0) / Birim_Gelir) THEN 'Kârlý (Eþik Üstü)'
        ELSE 'Zararda (Eþik Altý)'
    END AS Karlilik_Durumu

FROM FinancialBase;
GO