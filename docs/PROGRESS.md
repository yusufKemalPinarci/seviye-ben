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

- Dal: `cursor/equip-visibility-game-hud` (origin’de)
- Son commit: `b1e59c9` — equip visibility + RPG HUD
- Base: `main`

---

## Tamamlanan (özet)

| Alan | Durum |
|------|--------|
| Çekirdek + Faz B–E + F1–F3 + AAB | ✓ |
| Crew kaldırıldı; sprint = skill + PROGRESS | ✓ |
| Ekipman: sırt slotu, avatar katmanları, envanter “Üzerinde” | ✓ |
| Oyun HUD: XP bar, istatistik pill, görev kartları | ✓ |

### Bu turda yapılanlar (detay)

- **Workflow:** CrewAI zorunluluğu kalktı; `.cursor/skills/seviye-ben-sprint/` + bu dosya
- **Bug:** Ders çantası `body` yerine `back` (kıyafeti düşürmez); eski kayıt migrate
- **Avatar:** Konturlu katmanlar; çanta kolların üstünde
- **Envanter:** Slot özeti; aynı slotta “Değiştir” uyarısı
- **Asfalt seti:** 3 parça imkânsızdı (2 ayakkabı) → max 2 parça bonus
- **UI:** RPG HUD header, `XpBar`, habit/görev kartları, karakter istatistik panelleri

---

## Sonraki sprint

1. **F4 — Dahili / kapalı test → üretim** (Play Console)
2. F5 — (İsteğe bağlı) iOS App Store paket

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
- Her biten işte docs/PROGRESS.md güncelle (tamamlanan + sıradaki + bu chat özeti).
- Dal: cursor/equip-visibility-game-hud (gerekirse main’e merge sor).

## Sıradaki
F4 — Dahili / kapalı test → üretim.
```
