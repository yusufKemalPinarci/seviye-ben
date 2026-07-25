# SeviyeBen — İlerleme / Handoff



> Yeni chat: **önce bu dosya** + `docs/ROADMAP.md` + `.cursor/rules/seviye-ben.mdc`.  

> Uzun sohbet geçmişi gerekmez.



## Ürün

- **İsim:** SeviyeBen — ofline RPG alışkanlık (sokak seviye atlama)

- **Stack:** Flutter + Riverpod (MVVM) + Hive · UI Türkçe · internet/hesap YOK

- **Klasörler:** `seviye_ben/` · `seviye_ben_crew/` · `.cursor/rules/` · `docs/`



## Crew ritüeli (her mesaj / her sprint)

1. `docs/PROGRESS.md` → **Sonraki sprint** 1. maddeyi al (tek iş)

2. **Tasarla** (`*_ekonomi.md`) → **İçerik** (`*_icerik.*`) → **Kod** (`*_plan.md` + lib)

3. Canlı CrewAI / API **yok**; çıktı: `seviye_ben_crew/output/`

4. Sprint bitince bu dosyayı güncelle; sıradaki = ROADMAP’te bir sonraki açık madde



Detaylı fazlar: [`docs/ROADMAP.md`](ROADMAP.md)



---



## Bugüne kadar özet (Sprint 1–31)



| Alan | Durum |

|------|--------|

| Çekirdek + Faz B + C + D + E + F1–F2 | ✓ |

| **F3 Ekran görüntüleri (4× telefon)** | ✓ Sprint 31 |

| AAB (release imza) | ✓ |



---



## Önemli dosyalar

| Dosya | Rol |

|-------|-----|

| `docs/store/screenshots/*.jpg` | Play telefon görselleri (1080×1920) |

| `docs/store/screenshots/render_shots.py` | Görselleri yeniden üret |

| `docs/privacy/index.html` | Host edilecek gizlilik sayfası |

| `docs/PLAY_STORE.md` | mağaza checklist |



## Çalıştırma

```bash

cd seviye_ben

flutter pub get && flutter test && flutter run

flutter build appbundle --release

```



---



## Sonraki sprint (öncelik — ROADMAP Faz F)

1. **F4 — Dahili / kapalı test → üretim**

2. F5 — (İsteğe bağlı) iOS App Store paket



---



## Yeni chat’e yapıştır

```

SeviyeBen Flutter ofline RPG alışkanlık app.

Önce docs/PROGRESS.md, docs/ROADMAP.md ve .cursor/rules/seviye-ben.mdc oku.

Her işte Crew ritüeli: tasarla → içerik → kod (API yok; CrewAI canlı koşturma).

Tek sprint: PROGRESS.md "Sonraki sprint" 1. madde.

Bitince PROGRESS.md güncelle.



## Bu chatte bitenler

- F3: docs/store/screenshots 01–04 JPEG



## Sıradaki (PROGRESS 1. madde)

F4 — Dahili / kapalı test → üretim.



Crew output son numaralar: ~87–89 sprint31. Yeni sprint 32 → 90/91/92.

```



## Güncelleme kuralı

Her sprint bitince: tamamlananlara ekle + Sonraki sprint listesini kaydır.


