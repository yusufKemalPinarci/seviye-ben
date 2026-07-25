from PIL import Image, ImageDraw
from pathlib import Path

out = Path(r"c:\Users\ysfkml\Desktop\yeni fikir\seviye_ben\assets\branding")
out.mkdir(parents=True, exist_ok=True)

STREET = (46, 74, 62, 255)
SIGNAL = (224, 122, 61, 255)
WHITE = (255, 255, 255, 255)


def draw_logo(size: int, bg, fg, accent, pad_ratio=0.18) -> Image.Image:
    img = Image.new("RGBA", (size, size), bg)
    d = ImageDraw.Draw(img)
    pad = int(size * pad_ratio)
    inset = int(size * 0.06)
    d.rounded_rectangle(
        [inset, inset, size - inset, size - inset],
        radius=int(size * 0.18),
        fill=bg if bg[3] > 0 else STREET,
        outline=accent,
        width=max(2, size // 64),
    )
    left = pad
    right = size - pad
    bottom = size - pad
    usable_w = right - left
    usable_h = bottom - pad
    step_h = usable_h / 3.2
    for i in range(3):
        x0 = left + int(usable_w * (0.08 + i * 0.18))
        x1 = left + int(usable_w * (0.42 + i * 0.18))
        y1 = bottom - int(i * (step_h * 0.55))
        y0 = y1 - int(step_h * 0.85)
        color = fg if i < 2 else accent
        d.rounded_rectangle(
            [x0, y0, x1, y1],
            radius=max(4, size // 48),
            fill=color,
        )
    cx = size // 2 + int(size * 0.08)
    cy = int(size * 0.28)
    arm = int(size * 0.12)
    thick = max(4, size // 28)
    d.polygon(
        [
            (cx, cy - arm),
            (cx + arm, cy + arm // 2),
            (cx + arm - thick, cy + arm // 2),
            (cx, cy - arm + thick * 2),
            (cx - arm + thick, cy + arm // 2),
            (cx - arm, cy + arm // 2),
        ],
        fill=accent,
    )
    return img


icon = draw_logo(1024, STREET, WHITE, SIGNAL)
icon.convert("RGB").save(out / "app_icon.png", "PNG")

fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
logo = draw_logo(768, STREET, WHITE, SIGNAL, pad_ratio=0.16)
fg.paste(logo, ((1024 - 768) // 2, (1024 - 768) // 2), logo)
fg.save(out / "app_icon_foreground.png", "PNG")

splash_logo = draw_logo(512, STREET, WHITE, SIGNAL, pad_ratio=0.2)
plate = Image.new("RGBA", (640, 640), (0, 0, 0, 0))
pd = ImageDraw.Draw(plate)
pd.rounded_rectangle([16, 16, 624, 624], radius=96, fill=STREET)
plate.paste(splash_logo, ((640 - 512) // 2, (640 - 512) // 2), splash_logo)
plate.save(out / "splash_logo.png", "PNG")

print("ok", [p.name for p in out.iterdir()])
