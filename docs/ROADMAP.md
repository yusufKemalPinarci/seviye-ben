# SeviyeBen — Yol Haritası (eksiksiz ürün)

> Kaynak gerçek: `docs/PROGRESS.md` (hangi sprintteyiz).  
> Bu dosya: oyunun **tam** olması için fazlar. Her Cursor mesajında **tek sprint** (1 madde).

## Sprint ritüeli

`docs/PROGRESS.md` + `.cursor/skills/seviye-ben-sprint/`. Tek mesajda tek sprint.

---

## Faz A — Çekirdek (bitti ✓)

| # | Konu |
|---|------|
| A1 | XP / seviye / streak ekonomi |
| A2 | Alışkanlık + ekipman içerik JSON |
| A3 | Ana / Karakter / Envanter + Hive |
| A4 | Günlük görev + gün serisi + ünvan |
| A5 | Onboarding, sil, düzenle, haptic |
| A6 | Başarımlar |
| A7 | İkon + splash |
| A8 | Unit/widget test iskeleti |
| A9 | Play Store doküman iskeleti |
| A10 | Görsel karakter (paper-doll) + görünüm |

---

## Faz B — Oyun hissi (sıradaki)

| Sprint | Konu | Kabul |
|--------|------|--------|
| **B1** | Seviye atlama animasyonu / parti (avatar + SnackBar) | Seviye ↑ görünür kutlama |
| **B2** | Günlük sokak cümlesi (JSON, güne göre) | Ana ekranda 1 cümle |
| **B3** | Bugün özeti kartı (biten rutin, kazanılan XP) | Günlük XP/rutin sayısı |
| **B4** | Alışkanlık serisi kırılınca yumuşak uyarı | Seri kaybı anlaşılır |
| **B5** | Ses kapalı/açık + hafif SFX (yerel asset, opsiyonel) | Ayarlarda toggle |

---

## Faz C — İlerleme derinliği

| Sprint | Konu | Kabul |
|--------|------|--------|
| **C1** | Daha fazla alışkanlık şablonu + kategori filtresi | Filtre: güç/zeka/enerji/can |
| **C2** | Ekipman set bonusları (2+ parça) | Set takınca ekstra bonus |
| **C3** | Haftalık meydan okuma (7 gün hedef) | Haftalık progress + ödül |
| **C4** | Başarım genişletme (20+) + rozet satırı | Karakter’de rozet şeridi |
| **C5** | İstatistik geçmişi (son 7 gün grafik, yerel) | Basit bar chart |

---

## Faz D — Karakter & görsel polisaj

| Sprint | Konu | Kabul |
|--------|------|--------|
| **D1** | Avatar idle / bitirme mikro-animasyonu | Bitir’de kısa bounce |
| **D2** | Ekipman önizleme (envanterde giyince avatar) | Envanter + canlı preview |
| **D3** | Arka plan temaları (sokak / gece / yağmur) | Karakter’de seçim |
| **D4** | Ünvan + seviye mesajı zenginleştirme | Daha fazla `level_messages` |

---

## Faz E — Kalite & güven

| Sprint | Konu | Kabul |
|--------|------|--------|
| **E1** | GameNotifier unit testleri (completeHabit, daily, başarım) | Kritik yollar yeşil |
| **E2** | Veri yedek/geri yükle (JSON export-import, paylaşım intent) | Offline yedek |
| **E3** | Ayarlar ekranı (haptic, ses, görünüm, yedek) | Tek Ayarlar sekmesi/sayfa |
| **E4** | Erişilebilirlik (font ölçeği, kontrast) | Sistem fontuna uyum |
| **E5** | Performans: liste builder, gereksiz rebuild azalt | 50+ alışkanlıkta akıcı |

---

## Faz F — Yayın

| Sprint | Konu | Kabul |
|--------|------|--------|
| **F1** | Upload keystore + release AAB | Play’e yüklenebilir imza |
| **F2** | Gizlilik URL host + Data safety | Console onay |
| **F3** | Ekran görüntüleri (telefon 2–8) | Store listing |
| **F4** | Dahili / kapalı test → üretim | Canlı yayın |
| **F5** | (İsteğe bağlı) iOS App Store paket | IPA + listing |

---

## Faz G — Görsel self-development (bitti ✓)

| Sprint | Konu | Kabul |
|--------|------|--------|
| **G1** | Seviye basamakları + baskın stat aura | Sv.3 vs Sv.15 ayırt edilir |
| **G2** | Unlock try-on + envanter siluet | Level-up’ta dene; listede siluet |
| **G3** | Sahne unlock + sokak kimliği | Kilitli tema; kimlik kartı |
| **G4** | +ekipman, habit sparkle, polisaj | 18 parça; test yeşil |

---

## Faz H — FTUE / doğruluk (bitti ✓)

| Sprint | Konu | Kabul |
|--------|------|--------|
| **H1** | Seed reseed bug + boş liste CTA | Silinen habit hortlamaz; CTA |
| **H2** | Onboarding loop demosu | Bitir→XP→Giy anlaşılır |
| **H3** | Ana ekran ilk-gün sadeleştirme | Hedefler kapalı; liste üstte |

---

## Bilerek kapsam dışı (şimdilik)

- Online hesap, bulut sync, sosyal liderlik
- Habitica asset / isim kopyası
- Uygulama içi LLM / harici agent framework (CrewAI vb.)
- Reklam / IAP (sonra ayrı karar)

---

## “Eksiksiz” tanımı (çıkış kriteri)

1. Günlük kullanım döngüsü net (rutin → XP → seviye → ekipman → başarım)
2. Karakter görsel olarak kimlik veriyor
3. Motivasyon + haftalık hedef var
4. Ayarlar + yerel yedek var
5. Testler kritik yolları örtüyor
6. Play Store’da yayınlanabilir (F fazı)

B1…F5 bitince ürün “tam” sayılır; sonrası içerik/denge iterasyonu.
