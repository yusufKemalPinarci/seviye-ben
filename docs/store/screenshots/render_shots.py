"""SeviyeBen Play Store telefon ekranları (1080x1920, JPEG, alphasız)."""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

W, H = 1080, 1920
STREET = (46, 74, 62)
ASPHALT = (232, 228, 220)
SIGNAL = (224, 122, 61)
INK = (26, 31, 46)
MUTED = (61, 69, 86)
WHITE = (255, 255, 255)
CARD = (245, 242, 235)

OUT = Path(__file__).resolve().parent


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf" if bold else "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf",
    ]
    for path in candidates:
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def round_rect(draw: ImageDraw.ImageDraw, box, fill, radius=24):
    draw.rounded_rectangle(box, radius=radius, fill=fill)


def nav(draw: ImageDraw.ImageDraw, selected: int):
    labels = ["Rutin", "Karakter", "Envanter", "Ayarlar"]
    icons = ["✓", "☺", "▣", "⚙"]
    y0 = H - 160
    draw.rectangle((0, y0, W, H), fill=WHITE)
    draw.line((0, y0, W, y0), fill=(210, 205, 195), width=2)
    slot = W // 4
    for i, (lab, ic) in enumerate(zip(labels, icons)):
        x = slot * i + slot // 2
        color = STREET if i == selected else MUTED
        draw.text((x, y0 + 28), ic, fill=color, font=font(36, True), anchor="mt")
        draw.text((x, y0 + 90), lab, fill=color, font=font(28, i == selected), anchor="mt")


def app_bar(draw: ImageDraw.ImageDraw, title: str):
    draw.rectangle((0, 0, W, 140), fill=STREET)
    draw.text((48, 70), title, fill=WHITE, font=font(44, True), anchor="lm")


def shot_rutin() -> Image.Image:
    im = Image.new("RGB", (W, H), ASPHALT)
    d = ImageDraw.Draw(im)
    app_bar(d, "SeviyeBen")
    y = 170
    round_rect(d, (40, y, W - 40, y + 220), STREET, 28)
    d.text((70, y + 40), "Gezgin", fill=WHITE, font=font(40, True))
    d.text((70, y + 100), "Seviye 4  ·  Sokak Çırağı", fill=(220, 230, 220), font=font(28))
    d.rounded_rectangle((70, y + 155, W - 100, y + 175), radius=8, fill=(30, 50, 40))
    d.rounded_rectangle((70, y + 155, 70 + 280, y + 175), radius=8, fill=SIGNAL)
    d.text((70, y + 190), "XP  42 / 120", fill=(200, 210, 200), font=font(24))

    y = 420
    round_rect(d, (40, y, W - 40, y + 110), CARD, 20)
    d.text((70, y + 28), "Sokak notu", fill=STREET, font=font(26, True))
    d.text((70, y + 68), "Bugün de tempoyu tut.", fill=INK, font=font(28))

    y = 555
    round_rect(d, (40, y, W - 40, y + 130), CARD, 20)
    d.text((70, y + 28), "Günlük görev", fill=STREET, font=font(26, True))
    d.text((70, y + 70), "Bugün en az 3 rutin bitir.  ·  1 / 3", fill=INK, font=font(28))

    y = 720
    d.text((48, y), "Bugünün rutinleri", fill=INK, font=font(36, True))
    habits = [
        ("30 dk yürü veya spor yap", "Güç · +10 XP"),
        ("8 bardak su iç", "Can · +8 XP"),
        ("45 dk ders / öğrenme", "Zeka · +12 XP"),
        ("Gece 23:00 öncesi uyu", "Enerji · +10 XP"),
    ]
    y = 780
    for title, sub in habits:
        round_rect(d, (40, y, W - 40, y + 130), CARD, 20)
        d.text((70, y + 35), title, fill=INK, font=font(32, True))
        d.text((70, y + 80), sub, fill=MUTED, font=font(24))
        round_rect(d, (W - 220, y + 35, W - 70, y + 95), SIGNAL, 16)
        d.text((W - 145, y + 65), "Bitir", fill=INK, font=font(28, True), anchor="mm")
        y += 150

    nav(d, 0)
    return im


def shot_karakter() -> Image.Image:
    im = Image.new("RGB", (W, H), ASPHALT)
    d = ImageDraw.Draw(im)
    app_bar(d, "Karakter")
    # avatar frame
    round_rect(d, (290, 180, 790, 680), (35, 42, 58), 28)
    d.ellipse((390, 280, 690, 580), fill=(90, 120, 100))
    d.text((540, 430), "SB", fill=WHITE, font=font(72, True), anchor="mm")
    d.text((540, 720), "Gezgin · Seviye 4", fill=INK, font=font(34, True), anchor="mt")
    d.text((540, 775), "Ünvan: Sokak Çırağı", fill=MUTED, font=font(28), anchor="mt")

    stats = [("Güç", 6), ("Zeka", 5), ("Enerji", 4), ("Can", 7)]
    y = 860
    for name, val in stats:
        d.text((80, y), name, fill=INK, font=font(30, True))
        d.rounded_rectangle((280, y + 8, W - 80, y + 36), radius=10, fill=(210, 205, 195))
        d.rounded_rectangle((280, y + 8, 280 + val * 70, y + 36), radius=10, fill=STREET)
        d.text((W - 100, y), str(val), fill=MUTED, font=font(28), anchor="rm")
        y += 70

    d.text((80, y + 20), "Başarımlar", fill=INK, font=font(32, True))
    x = 80
    for label in ["İlk adım", "Seri 3", "Görev"]:
        round_rect(d, (x, y + 80, x + 220, y + 180), CARD, 18)
        d.text((x + 110, y + 130), label, fill=STREET, font=font(24, True), anchor="mm")
        x += 250

    nav(d, 1)
    return im


def shot_envanter() -> Image.Image:
    im = Image.new("RGB", (W, H), ASPHALT)
    d = ImageDraw.Draw(im)
    app_bar(d, "Envanter")
    round_rect(d, (340, 170, 740, 520), (40, 55, 70), 24)
    d.ellipse((420, 240, 660, 480), fill=(100, 130, 110))
    d.text((540, 545), "Giydiğin parçalar anında burada görünür.", fill=MUTED, font=font(24), anchor="mt")
    d.text((48, 600), "Açık ekipman", fill=INK, font=font(34, True))

    items = [
        ("Bere", "Kafa · +1 Güç", "Giy"),
        ("Sırt çantası", "Gövde · +1 Enerji", "Çıkar"),
        ("Koşu ayakkabısı", "Ayak · Sv.3", "Kilitli"),
    ]
    y = 660
    for title, sub, action in items:
        round_rect(d, (40, y, W - 40, y + 150), CARD, 20)
        d.text((70, y + 40), title, fill=INK, font=font(32, True))
        d.text((70, y + 90), sub, fill=MUTED, font=font(24))
        fill = SIGNAL if action != "Kilitli" else (190, 185, 175)
        round_rect(d, (W - 250, y + 45, W - 70, y + 110), fill, 16)
        d.text((W - 160, y + 78), action, fill=INK, font=font(26, True), anchor="mm")
        y += 170

    nav(d, 2)
    return im


def shot_ayarlar() -> Image.Image:
    im = Image.new("RGB", (W, H), ASPHALT)
    d = ImageDraw.Draw(im)
    app_bar(d, "Ayarlar")
    sections = [
        ("Ses", "Alışkanlık ve seviye sesleri", True),
        ("Titreşim", "Bitir ve seviye titreşimi", True),
        ("Görünüm", "Karakter stili ve arka plan", False),
        ("Yedek", "JSON dışa / içe aktar", False),
        ("Erişilebilirlik", "Sistem yazı boyutuna uyum", False),
    ]
    y = 180
    for title, body, toggle in sections:
        round_rect(d, (40, y, W - 40, y + 150), CARD, 20)
        d.text((70, y + 40), title, fill=INK, font=font(34, True))
        d.text((70, y + 95), body, fill=MUTED, font=font(26))
        if toggle:
            d.rounded_rectangle((W - 200, y + 50, W - 80, y + 100), radius=24, fill=STREET)
            d.ellipse((W - 145, y + 55, W - 95, y + 95), fill=WHITE)
        y += 170

    nav(d, 3)
    return im


def main():
    shots = [
        ("01_rutin.jpg", shot_rutin),
        ("02_karakter.jpg", shot_karakter),
        ("03_envanter.jpg", shot_envanter),
        ("04_ayarlar.jpg", shot_ayarlar),
    ]
    for name, fn in shots:
        im = fn()
        path = OUT / name
        im.save(path, "JPEG", quality=92, optimize=True)
        print(path.name, path.stat().st_size, im.size)


if __name__ == "__main__":
    main()
