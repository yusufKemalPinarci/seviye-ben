# F4 — Play Console: dahili → kapalı → üretim

Bu dosya operasyon checklist’idir. Kod/AAB hazır; kalan adımlar Play Console’da yapılır.

## Gizlilik URL (host)

| Alan | Değer |
|------|--------|
| Kaynak | [`privacy/index.html`](privacy/index.html) |
| Host | GitHub Pages (`main` → `/docs`) |
| URL | `https://yusufkemalpinarci.github.io/seviye-ben/privacy/` |

Doğrulama: tarayıcıda aç; 404 olmamalı. Pages yeni açıldıysa 1–5 dk bekleyebilir.

## Console sırası

1. **Uygulama içeriği → Gizlilik politikası** → yukarıdaki URL
2. **Veri güvenliği** → [`DATA_SAFETY.md`](DATA_SAFETY.md) (“Hayır” toplama/paylaşım)
3. **Mağaza girişi** → kısa/uzun açıklama [`PLAY_STORE.md`](PLAY_STORE.md)
4. **Grafikler** → feature graphic + `docs/store/screenshots/*.jpg`
5. **İçerik derecelendirmesi** → basit / herkese uygun
6. **Test ve yayın**
   - Dahili test: AAB yükle → tester ekle → duman testi
   - Kapalı test: küçük grup
   - Üretim: inceleme gönder → canlı

## Yerel AAB

```bash
cd seviye_ben
flutter test
flutter build appbundle --release
```

Çıktı: `build/app/outputs/bundle/release/app-release.aab`  
`key.properties` zorunlu (git dışı).

## Durum

| Madde | Durum |
|-------|--------|
| Privacy HTML | Hazır |
| Privacy URL (hedef) | `https://yusufkemalpinarci.github.io/seviye-ben/privacy/` |
| Pages açma | Repo Settings → Pages → `main` / `/docs` (bir kez) |
| Data safety metni | Hazır |
| AAB / keystore | Yerel hazır (F1) |
| Screenshots | Hazır (F3) |
| Console form doldurma | Hesap sahibi yapar |
| Dahili → kapalı → üretim | Hesap sahibi yapar |

## Pages’i aç (bir kez)

1. GitHub → `seviye-ben` → **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: `main` · Folder: `/docs` → Save
4. Birkaç dakika sonra gizlilik URL’sini tarayıcıda doğrula
