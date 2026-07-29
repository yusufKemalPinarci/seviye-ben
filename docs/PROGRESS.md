# SeviyeBen — İlerleme / Handoff

> **Tek kaynak.** Her iş bitince bu dosya güncellenir. Yeni chat önce bunu okur.  
> Skill: `.cursor/skills/seviye-ben-sprint/` · Plan: [`ROADMAP.md`](ROADMAP.md)

## Ürün

SeviyeBen — ofline RPG alışkanlık (Flutter + Riverpod + Hive · UI Türkçe · internet/hesap yok)  
Klasör: `seviye_ben/`

## Nasıl ilerleriz (zorunlu)

1. Bu dosyada **Sonraki sprint** → sadece **1. madde**
2. Skill sırası: düşün → gerekirse asset → `lib/` kod → test
3. Bitince **bu dosyayı güncelle** (Tamamlanan + Sonraki + “Bu chatte” + Yeni chat bloğu)
4. CrewAI / `seviye_ben_crew/output` **yok**

---

## Git

- Dal: `main` (yerel değişiklikler: Faz G + Faz H; henüz commit yok)
- Base: `origin/main`

---

## Tamamlanan (özet)

| Alan | Durum |
|------|--------|
| Çekirdek + Faz B–E + F1–F3 + AAB | ✓ |
| Faz G — Görsel self-development | ✓ |
| **Faz H — FTUE / doğruluk (H1–H3)** | ✓ |
| **F4 hazırlık** (runbook + privacy URL hedefi) | ✓ |

### Bu turda yapılanlar (detay)

- **H1:** `contentHabitsSeeded` — silinen seed habit geri gelmez; boş listede “Alışkanlık ekle” CTA
- **H2:** Onboarding “Sokak döngüsü” (Bitir → XP → Giy)
- **H3:** Ana ekranda “Bugünün hedefleri” ExpansionTile (kapalı); rutin listesi üstte
- **F4:** [`docs/F4_CONSOLE.md`](F4_CONSOLE.md) + PLAY_STORE gizlilik URL hedefi; Pages/Console canlı adımları hesap sahibinde

---

## Sonraki sprint

1. **F4 Console işleri** — Pages aç (`main`/`/docs`), Data safety + listing + dahili→kapalı→üretim ([`F4_CONSOLE.md`](F4_CONSOLE.md))
2. F5 — (İsteğe bağlı) iOS App Store paket
3. (Sonra) Yerel bildirim / home widget

---

## Çalıştırma

```bash
cd seviye_ben
flutter pub get && flutter test && flutter run
flutter build appbundle --release
```

---

## Yeni chat’e yapıştır

```
SeviyeBen Flutter ofline RPG alışkanlık app.

Önce docs/PROGRESS.md oku (tek handoff kaynağı).
Skill: .cursor/skills/seviye-ben-sprint/
ROADMAP: docs/ROADMAP.md (referans).

Kurallar:
- CrewAI yok; crew output yazma.
- Tek sprint = PROGRESS "Sonraki sprint" 1. madde.
- Her biten işte docs/PROGRESS.md güncelle.

## Sıradaki
F4 Console: Pages + Data safety + dahili→üretim (docs/F4_CONSOLE.md).
```
