# SeviyeBen

Ofline RPG aliskanlik uygulamasi (Flutter) + gelistirme icin CrewAI ekibi.

## Klasorler

| Klasor | Ne |
|--------|-----|
| `seviye_ben/` | Flutter mobil uygulama (offline) |
| `seviye_ben_crew/` | CrewAI icerik/plan uretimi |
| `.cursor/rules/` | Cursor kurallari (awesome-cursorrules + proje) |

## Stack

- Flutter + Riverpod (MVVM) + Hive
- Tamamen ofline (hesap/API yok)
- CrewAI sadece gelistirmede (uygulama icinde LLM yok)

## Kurallar kaynagi

- [awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules) Flutter + clean code
- [crewAI](https://github.com/crewAIInc/crewAI) ajan orkestrasyonu

## Ilerleme

Guncel durum ve yeni chat promptu: [`docs/PROGRESS.md`](docs/PROGRESS.md)  
Eksiksiz urun yol haritasi: [`docs/ROADMAP.md`](docs/ROADMAP.md)

## Play Store

Hazirlik checklist, mağaza metinleri, imza ve AAB: [`docs/PLAY_STORE.md`](docs/PLAY_STORE.md)  
Gizlilik politikasi: [`docs/privacy_policy.md`](docs/privacy_policy.md)

## Calistirma

```bash
# Flutter
cd seviye_ben
flutter pub get
flutter run

# CrewAI sirasi (ekonomi -> icerik -> plan)
# LLM anahtari yoksa ofline pipeline calisir
cd seviye_ben_crew
python scripts/run_crew_or_offline.py

# Canli ajanlar icin:
# copy .env.example .env  → OPENAI_API_KEY yaz
# crewai run
```

## Urun

**SeviyeBen** — hayati RPG'ye cevir: gorev bitir, XP kazan, seviye atla, ekipman ac.
Tema: sokak seviye atlama (guc / zeka / enerji / can).
