# SeviyeBen — Play Console Data safety formu

Play Console → Uygulama içeriği → **Veri güvenliği**.  
Aşağıdaki cevaplar ofline SeviyeBen için hazırlanmıştır (Sprint 30 / F2).

## Özet cevaplar

| Konu | Cevap |
|------|--------|
| Kullanıcı verisi topluyor mu? | **Hayır** (cihaz dışına iletim yok) |
| Kullanıcı verisi paylaşıyor mu? | **Hayır** |
| Hesap oluşturma / giriş | **Yok** |
| Reklam / analitik SDK | **Yok** |
| Şifreli iletim | **Uygulanmaz** (ağ üzerinden işlev yok) |
| Silme hakkı | Kullanıcı uygulamayı / uygulama verisini siler |

## Adım adım (Console)

### 1) Veri toplama ve güvenlik
1. **Uygulamanız kullanıcı verilerini topluyor veya paylaşıyor mu?** → **Hayır**
2. Onay kutusu: gizlilik politikası URL’sinin doğru olduğunu doğrula.

> Google tanımı: “toplama” = verinin cihazdan **dışarı iletilmesi**.  
> Hive’daki yerel ilerleme tek başına “toplama” sayılmaz.

### 2) Gizlilik politikası URL
- Alan: herkese açık HTTPS URL  
- Kaynak dosya: [`privacy/index.html`](privacy/index.html)  
- Örnek host: GitHub Pages → `https://<kullanıcı>.github.io/<repo>/privacy/`  
  (veya aynı HTML’i herhangi bir statik hosta koy)

### 3) Veri türleri ekranı
“Hayır” seçildiği için çoğu veri türü formu **atlanır**.  
İleride ağ / analitik eklersen formu yeniden doldur.

### 4) Güvenlik uygulamaları (görünürse)
| Soru | Öneri |
|------|--------|
| Veriler aktarımda şifreleniyor mu? | Hayır / uygulanmaz (aktarım yok) |
| Kullanıcılar veri silme isteyebilir mi? | Evet — uygulama / veri silme |
| Bağımsız güvenlik incelemesi? | Hayır (gerekmez) |

### 5) Önizleme ve gönder
Formu kaydet → **Önizle** → **Gönder**.  
Politika URL’si erişilebilir olmalı (404 kabul edilmez).

## Yerel veri notu (destek / şeffaflık)

Uygulama işlevi için cihazda tutulanlar (paylaşılmaz / toplanmaz):

- Uygulama etkinliği: tamamlanan rutinler, XP, seri  
- Uygulama bilgisi ve performans: yerel ayarlar  
- Kişisel bilgiler: isteğe bağlı karakter adı (yalnızca cihazda)

Yedek JSON: kullanıcı Ayarlar’dan dışa aktarıp kendisi paylaşır; uygulama otomatik yüklemez.
