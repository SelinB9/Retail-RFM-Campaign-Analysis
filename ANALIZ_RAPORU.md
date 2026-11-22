# 📈 Detaylı Veri Analizi, Stratejik Öneriler ve İş Soruları Raporu

Bu doküman, **SQL Server (`RetailAnalyticsDB`)** üzerinde hazırlanan görünümler (`VIEW`) ve **Power BI** dashboard çalışmasından elde edilen detaylı analitik bulguları, iş birimleri için geliştirilen aksiyon önerilerini ve yöneticilerin bu veri modeli üzerinden yanıt alabileceği kritik iş sorularını içermektedir.

---

## 1. Analitik Bulgular (Metrik Özeti)

### A. Demografi, Gelir ve Harcama Profili
* **Toplam Geçerli Müşteri:** 2.236 kişi
* **Çocuklu Aile Oranı (`Kidhome + Teenhome > 0`):** %71,51
* **Ortalama Yıllık Gelir:** $51.962
* **Eğitim Düzeyi Dağılımı:** Lisans (%50) | Doktora (%22) | Yüksek Lisans (%17) | 2n Cycle (%9) | Temel Eğitim (%2)
* **Gelir – Sepet İlişkisi:** Yıllık gelir arttıkça tek seferdeki ortalama sepet tutarı ve toplam harcama doğru orantılı yükselmektedir.

### B. RFM Segmentasyon ve Ciro Katkısı
* **Müşteri Dağılımı (Toplam 2.236):** Sadık Müşteriler (597) | Potansiyel Sadık (456) | Yeni/Umut Veren (367) | Uykuda/Kayıp (343) | Şampiyonlar (297) | Kaybetme Riski (176)
* **Ciro Katkı Sıralaması:** Sadık Müşteriler (673B) > Şampiyonlar (368B) > Potansiyel Sadık (169B) > Kaybetme Riski (95B) > Yeni/Umut Veren (26B) > Uykuda/Kayıp (24B)
* **Ana Ciro Kaynağı:** Toplam müşteri tabanının yaklaşık %40'ını oluşturan **Sadık Müşteriler ve Şampiyonlar**, toplam cironun ana lokomotifidir.

### C. Ürün Kategorisi Performansı
* **Ciro Liderleri:** 1. Şarap | 2. Et Ürünleri
* **Niş / Üst Gelir Kategorisi:** Altın ürünleri (üst gelir ve Şampiyon segmentinde yoğunlaşmaktadır)
* **Düşük Sepet Paylı Gruplar:** Balık, Meyve, Tatlı

### D. Satış Kanalları ve Dijital Trafik
* **1. Kanal (Fiziksel Mağaza):** 12.959 işlem (en yüksek işlem hacmi)
* **2. Kanal (Web):** İkinci en güçlü satış kanalı — Aylık ortalama **5,3 web ziyareti**
* **3. Kanal (Katalog):** En düşük işlem payına sahip kanal
* **İndirimli Alışveriş Oranı:** %24,8

### E. Pazarlama Kampanyaları ve ROI Performansı
* **Toplam Kampanya Net Kâr / Zarar:** -29.248 (Zarar)
* **Genel Kampanya ROI (%):** -%72,7
* **Kampanya Katılım Oranları:** 6. Son Kampanya (%14,9) > 4. Kampanya (%7,5) > 3. Kampanya (%7,3) = 5. Kampanya (%7,3) > 1. Kampanya (%6,4) > 2. Kampanya (%1,3)
* **Temel Sonuç:** Katılım oranları kârlılık eşiğinin altında kaldığı için genel kitleye yayılan kampanyalar negatif ROI üretmektedir.
---

## 2. Veri Odaklı Stratejik Aksiyon Önerileri

### 1. Segment Bazlı Kademeli Kampanya Stratejisi (Tüm Müşterileri Kapsayan Plan)
* Müşterilerin tamamına aynı maliyetli kampanyayı göndermek yerine RFM segmentlerine göre farklılaştırılmış bir bütçe dağılımı uygulanmalıdır.

### 2. Katalog Kanalının Segment Bazlı Optimizasyonu
* **Hedefli Dağıtım & Dijital Geçiş:** Fiziksel katalog yalnızca geleneksel alışverişi ve basılı materyali tercih eden ileri yaş grubundaki müşteriler için korunmalı; dijital kanalları aktif kullanan kitle ise web tabanlı e-kataloğa yönlendirilerek tasarruf edilen bütçe dijital kampanyalara aktarılmalıdır.

### 3. Web Trafiğini Satışa Çevirme (Çapraz Satış / Cross-Sell)
* Aylık ortalama **5,3 web ziyareti** yapan kullanıcıların ziyaretlerini siparişe dönüştürmek için dijital sepette tamamlayıcı ürün önerileri (örneğin Şarap ve Et alımlarında eşlikçi ürün paketleri) sunulmalıdır.

### 4. Çocuklu Ailelere Yönelik Çoklu Alım Paketleri
* Müşteri tabanının **%71,51'ini** oluşturan çocuklu ailelerin düzenli alışveriş alışkanlığını korumak için aile boyu tüketim paketleri ve çoklu alım avantajları kurgulanmalıdır.
---

## 3. Bu Veri Modeli ile Cevaplanabilen Yönetici Soruları (25 Kritik İş Sorusu)

Oluşturulan SQL görünümleri (`vw_Customer_RFM`, `vw_Urun_Kategorileri`, `vw_Kanal_Tercihleri`, `vw_Kampanya_ROI`, `vw_Genel_KPI`) sayesinde iş birimleri ve yöneticiler aşağıdaki sorulara doğrudan yanıt alabilmektedir:

### A. Kampanya ve ROI Soruları (`vw_Kampanya_ROI` & `vw_Genel_KPI`)
1. 1.Kampanyaya toplam kaç müşteri katıldı ve kaç müşteri katılmadı?
2. 2., 3., 4., 5. ve 6. (Son) kampanyalara ayrı ayrı kaç müşteri katıldı?
3. 6 pazarlama kampanyasının her birinin katılım oranı (%) kaçtır?
4. En yüksek ve en düşük katılım oranına sahip pazarlama kampanyaları hangileridir?
5. Kampanyaların toplam maliyeti, elde edilen geliri ve toplam net kâr/zarar tutarı nedir?
6. Tüm kampanyaların genel yatırım getirisi (ROI %) oranı nedir ve kârlılık eşiğine ulaşılabildi mi?
7. İndirimli alışverişlerin toplam işlemler içindeki oranı (%) nedir?

### B. RFM Segmentasyonu ve Müşteri Değeri Soruları (`vw_Customer_RFM` & `vw_Genel_KPI`)
8. Toplam geçerli müşteri sayımız kaçtır ve RFM segmentlerine göre müşteri sayıları nasıl dağılmaktadır?
9. "Şampiyonlar" ve "Sadık Müşteriler" segmentlerinde kaç müşteri bulunmaktadır?
10. "Potansiyel Sadık" ve "Yeni/Umut Veren" segmentlerindeki müşteri sayısı kaçtır?
11. "Kaybetme Riski" ve "Uykuda/Kayıp" segmentlerinde toplam kaç müşteri yer almaktadır?
12. Şirketin toplam cirosu ne kadardır ve her bir RFM segmentinin toplam ciroya katkısı nedir?
13. En yüksek ve en düşük ciro katkısı sağlayan RFM segmentleri hangileridir?
14. Müşterilerin genel ortalama alışveriş sıklığı (*Frequency*) kaçtır?
15. Müşteri bazında son alışverişten bu yana geçen gün sayısı (*Recency*) ve toplam harcama (*Monetary*) değerleri nedir?

### C. Demografi ve Müşteri Profili Soruları (`vw_Genel_KPI` & Dashboard Demografi Kartları)
16. Müşterilerin ortalama yıllık hane geliri ne kadardır?
17. Evinde çocuk veya genç (`Kidhome + Teenhome > 0`) bulunan aileler toplam müşterilerin yüzde kaçını oluşturmaktadır?
18. Müşterilerin eğitim düzeyine (Lisans, Doktora, Yüksek Lisans, 2n Cycle, Temel Eğitim) göre yüzdelik dağılımı nasıldır?
19. Müşterilerin medeni durumuna göre dağılımı nasıldır?
20. Yıllık gelir düzeyi ile müşterilerin toplam harcama tutarı nasıl değişmektedir?

### D. Ürün Kategorisi ve Satış Kanalı Soruları (`vw_Urun_Kategorileri` & `vw_Kanal_Tercihleri`)
21. 6 ürün kategorisinin (Şarap, Et, Balık, Meyve, Tatlı, Altın) ayrı ayrı toplam satış tutarları nedir?
22. Şirket cirosunun en büyük kısmını hangi ürün kategorisi sırtlamaktadır, en düşük pay hangi kategoridedir?
23. Fiziksel mağaza, web ve katalog kanallarının toplam işlem sayıları kaçtır?
24. Müşteriler alışverişlerinde en çok ve en az hangi satış kanalını tercih etmektedir?
25. Müşteriler web sitemizi ayda ortalama kaç kez ziyaret etmektedir?
