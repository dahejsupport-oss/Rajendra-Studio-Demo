import os
from PIL import Image

src_icon_path = r'C:/Users/Patel Het/.gemini/antigravity/brain/bdbd638a-53e9-4f5d-ab2f-1028b1610149/.user_uploaded/media_1795541971829_d4036e94.png'
src_text_path = r'C:/Users/Patel Het/.gemini/antigravity/brain/bdbd638a-53e9-4f5d-ab2f-1028b1610149/.user_uploaded/media_1795541971862_ba7a7d31.png'

im_icon = Image.open(src_icon_path).convert('RGBA')
im_text = Image.open(src_text_path).convert('RGBA')

# Target directories
target_dirs = [
    os.path.join('assets', 'images'),
    os.path.join('public', 'assets', 'images')
]

for d in target_dirs:
    os.makedirs(d, exist_ok=True)

# 1. ICON LOGO (Square Padded 723x723, centered)
square_size = max(im_icon.width, im_icon.height) + 40
im_icon_square = Image.new('RGBA', (square_size, square_size), (0, 0, 0, 0))
offset_x = (square_size - im_icon.width) // 2
offset_y = (square_size - im_icon.height) // 2
im_icon_square.paste(im_icon, (offset_x, offset_y), im_icon)

# 2. HORIZONTAL COMBINED LOGO (Emblem on Left + DAHEJ SUPPORT Wordmark on Right)
# Target height 240
h_height = 240
icon_h = 210
icon_w = int(icon_h * im_icon.width / im_icon.height)
im_icon_resized = im_icon.resize((icon_w, icon_h), Image.Resampling.LANCZOS)

text_h = 130
text_w = int(text_h * im_text.width / im_text.height)
im_text_resized = im_text.resize((text_w, text_h), Image.Resampling.LANCZOS)

gap = 36
h_width = icon_w + gap + text_w + 30
im_horizontal = Image.new('RGBA', (h_width, h_height), (0, 0, 0, 0))

# Vertically center icon and text
icon_y = (h_height - icon_h) // 2
text_y = (h_height - text_h) // 2 - 2  # slightly optical adjust

im_horizontal.paste(im_icon_resized, (15, icon_y), im_icon_resized)
im_horizontal.paste(im_text_resized, (15 + icon_w + gap, text_y), im_text_resized)

# 3. VERTICAL / STACKED LOGO (Emblem on top + Wordmark below, for Admin Login & Full Cards)
stack_width = 800
stack_height = 800
im_stacked = Image.new('RGBA', (stack_width, stack_height), (0, 0, 0, 0))

top_icon_h = 480
top_icon_w = int(top_icon_h * im_icon.width / im_icon.height)
im_top_icon = im_icon.resize((top_icon_w, top_icon_h), Image.Resampling.LANCZOS)

bot_text_w = 700
bot_text_h = int(bot_text_w * im_text.height / im_text.width)
im_bot_text = im_text.resize((bot_text_w, bot_text_h), Image.Resampling.LANCZOS)

stack_gap = 40
total_stack_h = top_icon_h + stack_gap + bot_text_h
start_y = (stack_height - total_stack_h) // 2

im_stacked.paste(im_top_icon, ((stack_width - top_icon_w) // 2, start_y), im_top_icon)
im_stacked.paste(im_bot_text, ((stack_width - bot_text_w) // 2, start_y + top_icon_h + stack_gap), im_bot_text)

# 4. Save to assets/images and public/assets/images
for d in target_dirs:
    # Icon
    im_icon_square.save(os.path.join(d, 'logo-icon.png'))
    # Horizontal combination (Header, Nav, Footer)
    im_horizontal.save(os.path.join(d, 'logo-horizontal.png'))
    im_horizontal.save(os.path.join(d, 'logo.png'))
    # Text only
    im_text.save(os.path.join(d, 'logo-text.png'))
    # Stacked / Full
    im_stacked.save(os.path.join(d, 'logo-full.png'))
    im_stacked.save(os.path.join(d, 'logo-stacked.png'))

    # Favicon PNGs
    fav_180 = im_icon_square.resize((180, 180), Image.Resampling.LANCZOS)
    fav_180.save(os.path.join(d, 'apple-touch-icon.png'))
    
    fav_64 = im_icon_square.resize((64, 64), Image.Resampling.LANCZOS)
    fav_64.save(os.path.join(d, 'favicon.png'))

    # Favicon ICO
    im_icon_square.save(os.path.join(d, 'favicon.ico'), format='ICO', sizes=[(16, 16), (32, 32), (48, 48), (64, 64)])

# 5. Also save root and public/ favicons
root_fav_dirs = ['.', 'public']
for rd in root_fav_dirs:
    im_icon_square.resize((180, 180), Image.Resampling.LANCZOS).save(os.path.join(rd, 'apple-touch-icon.png'))
    im_icon_square.resize((64, 64), Image.Resampling.LANCZOS).save(os.path.join(rd, 'favicon.png'))
    im_icon_square.save(os.path.join(rd, 'favicon.ico'), format='ICO', sizes=[(16, 16), (32, 32), (48, 48), (64, 64)])

# 6. Generate SVG wrappers with new base64 graphics
import base64
with open('assets/images/logo-icon.png', 'rb') as f:
    icon_b64 = base64.b64encode(f.read()).decode('utf-8')
with open('assets/images/logo-horizontal.png', 'rb') as f:
    horiz_b64 = base64.b64encode(f.read()).decode('utf-8')

fav_svg_content = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">\n' + \
    f'  <image href="data:image/png;base64,{icon_b64}" x="0" y="0" width="512" height="512" />\n</svg>\n'

logo_svg_content = f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {h_width} {h_height}" width="{h_width}" height="{h_height}">\n' + \
    f'  <image href="data:image/png;base64,{horiz_b64}" x="0" y="0" width="{h_width}" height="{h_height}" />\n</svg>\n'

for d in target_dirs:
    with open(os.path.join(d, 'favicon.svg'), 'w', encoding='utf-8') as f:
        f.write(fav_svg_content)
    with open(os.path.join(d, 'logo.svg'), 'w', encoding='utf-8') as f:
        f.write(logo_svg_content)

print("All Dahej Support logos and favicons successfully generated!")
