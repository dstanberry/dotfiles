"""Icon generator"""

from PIL import Image, ImageDraw, ImageFont

WIDTH, HEIGHT, BORDER_RAD = 400, 400, 30
BG, FG = "#303031", "#c9d1d9"
COLORS = {
    "K1": "#97b182",
    "D": "#6f8fb4",
    "A": "#94628a",
    "R": "#bf616a",
    "K2": "#d08770",
}


def draw_canvas(width, height, radius, fill_color):
    """Create an image with rounded corners"""
    image = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)

    draw.rounded_rectangle([(0, 0), (width, height)], radius=radius, fill=fill_color)

    return image


def main():
    img = draw_canvas(WIDTH, HEIGHT, BORDER_RAD, BG)
    draw = ImageDraw.Draw(img)
    color_keys = COLORS.keys()
    chars = ["K", "D", "A", "R", "K"]

    char_widths = []
    font_size = 72
    spacing = 15

    try:
        font = ImageFont.truetype("Arial.ttf", font_size)
    except IOError:
        font = ImageFont.load_default()

    for c in chars:
        bbox = draw.textbbox((0, 0), c, font=font)
        char_widths.append(bbox[2] - bbox[0])

    total_width = sum(char_widths) + spacing * (len(chars) - 1)
    x = (WIDTH - total_width) // 2
    y = (HEIGHT - 120) // 2

    for char, color_key, char_width in zip(chars, color_keys, char_widths):
        draw.text((x, y), char, fill=COLORS[color_key], font=font)
        x += char_width + spacing

    underline_y = y + 85
    underline_left = (WIDTH - total_width) // 2 - 10
    underline_right = underline_left + total_width + 20
    underline_thickness = 6

    draw.rounded_rectangle(
        [
            (underline_left, underline_y),
            (underline_right, underline_y + underline_thickness),
        ],
        radius=underline_thickness // 2,
        fill=FG,
    )

    img.save("icon.png")
    print("Generated icon.png (400x400)")


if __name__ == "__main__":
    main()
