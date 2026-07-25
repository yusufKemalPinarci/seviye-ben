from PIL import Image, ImageDraw, ImageFont
from pathlib import Path

out = Path(r"c:\Users\ysfkml\Desktop\yeni fikir\seviye_ben\assets\branding")
out.mkdir(parents=True, exist_ok=True)

W, H = 1024, 500
STREET = (46, 74, 62)
SIGNAL = (224, 122, 61)
ASPHALT = (232, 228, 220)
INK = (26, 31, 46)
WHITE = (255, 255, 255)

img = Image.new("RGB", (W, H), STREET)
d = ImageDraw.Draw(img)

# subtle asphalt band
d.rectangle([0, H - 90, W, H], fill=ASPHALT)

# logo plate
logo_path = out / "splash_logo.png"
if logo_path.exists():
    logo = Image.open(logo_path).convert("RGBA")
    logo = logo.resize((280, 280), Image.Resampling.LANCZOS)
    img.paste(logo, (72, (H - 280) // 2 - 10), logo)

# title text
try:
    font_lg = ImageFont.truetype("arial.ttf", 72)
    font_sm = ImageFont.truetype("arial.ttf", 28)
except OSError:
    font_lg = ImageFont.load_default()
    font_sm = font_lg

d.text((400, 160), "SeviyeBen", fill=WHITE, font=font_lg)
d.text(
    (400, 250),
    "Sokakta seviye atla. Tamamen ofline.",
    fill=ASPHALT,
    font=font_sm,
)
d.rectangle([400, 310, 520, 318], fill=SIGNAL)

img.save(out / "feature_graphic.png", "PNG")

# Play Console often wants 512 icon
icon = Image.open(out / "app_icon.png").convert("RGB").resize(
    (512, 512), Image.Resampling.LANCZOS
)
icon.save(out / "play_icon_512.png", "PNG")
print("ok feature_graphic + play_icon_512")
