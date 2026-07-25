# SeviyeBen — Play Store hazırlık

## Mağaza kimliği
| Alan | Değer |
|------|--------|
| Uygulama adı | SeviyeBen |
| applicationId | `com.seviyeben.seviye_ben` |
| Sürüm | `pubspec.yaml` → `1.0.0+1` (versionName + versionCode) |
| Kategori önerisi | Üretkenlik veya Yaşam tarzı |
| Ücret | Ücretsiz (IAP yok) |

## Kısa açıklama
```
Hayatını RPG’ye çevir: rutin bitir, XP kazan, seviye atla. Tamamen ofline.
```

## Uzun açıklama
```
SeviyeBen, alışkanlıklarını sokak temalı bir seviye atlama oyununa dönüştürür.

• Rutinleri tamamla, XP ve seri kazan
• Güç, zeka, enerji, can istatistiklerini büyüt
• Günlük görev ve başarımlarla tempo tut
• Ekipman aç, karakterini güçlendir
• Hesap yok, internet yok — her şey cihazında

Habitica kopyası değil; orijinal tema ve içerik.
```

## Data safety (özet)
- Veri toplanmaz / paylaşılmaz (cihaz dışı iletim yok)
- Yerel depolama: uygulama işlevi (ilerleme)
- Şifreli iletim: yok (ağ yok)
- Hesap oluşturma: yok

Tam form cevapları: [`DATA_SAFETY.md`](DATA_SAFETY.md)

## İçerik derecelendirmesi
Şiddet / cinsel içerik yok; alışkanlık + hafif oyunlaştırma. Ankette “basit” / herkese uygun seçenekleri işaretle.

## Gizlilik politikası
| Kaynak | Dosya |
|--------|--------|
| Markdown | [`privacy_policy.md`](privacy_policy.md) |
| Yayınlanacak HTML | [`privacy/index.html`](privacy/index.html) |

### URL host (Play Console)
1. `docs/privacy/` klasörünü statik site köküne koy (veya repo’da `docs/` → GitHub Pages)
2. Sayfa adresi örnek: `https://<kullanıcı>.github.io/<repo>/privacy/`
3. Tarayıcıda açıldığını doğrula (404 olmamalı)
4. Play Console → Uygulama içeriği → Gizlilik politikası URL alanına yapıştır

| Alan | Değer |
|------|--------|
| Gizlilik URL | _(host ettikten sonra buraya yaz)_ |

## İmza (upload keystore)
```bash
cd seviye_ben/android
# keytool: Android Studio JBR içinden (PATH’te yoksa tam yol kullan)
keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -dname "CN=SeviyeBen, OU=Mobile, O=SeviyeBen, L=Istanbul, ST=Istanbul, C=TR"
copy key.properties.example key.properties
# key.properties: storeFile=../upload-keystore.jks + şifreler
```

`key.properties` ve `*.jks` git’e eklenmez. **Yedekle** — kaybolursa Play güncellemesi yapılamaz.

## AAB üret
```bash
cd seviye_ben
flutter test
flutter build appbundle --release
```
Çıktı: `build/app/outputs/bundle/release/app-release.aab`

`key.properties` yoksa debug imza kullanılır — **mağazaya yükleme**.

## Görseller
| Asset | Boyut | Dosya |
|-------|--------|--------|
| Uygulama ikonu | 512×512 (Play) | `seviye_ben/assets/branding/play_icon_512.png` |
| Feature graphic | 1024×500 | `seviye_ben/assets/branding/feature_graphic.png` |
| Telefon ekran görüntüsü | 1080×1920 JPEG ×4 | [`docs/store/screenshots/`](store/screenshots/) |

Yeniden çizim: `python docs/store/screenshots/render_shots.py`

## Checklist
- [x] Upload keystore + `key.properties` (yerel; git dışı)
- [x] `flutter build appbundle --release` (release imza)
- [x] Gizlilik politikası HTML + Data safety cevapları (`privacy/`, `DATA_SAFETY.md`)
- [ ] Gizlilik URL’sini host et ve Console’a yapıştır
- [ ] Data safety formunu Console’da gönder
- [ ] Kısa / uzun açıklama yapıştır
- [x] Feature graphic + ekran görüntüleri (`docs/store/screenshots/`)
- [ ] İçerik derecelendirmesi anketi
- [ ] Dahili test → kapalı test → üretim
