import struct, zlib, os

def create_gradient_png(width, height, start, end, filename):
    sig = b'\x89PNG\r\n\x1a\n'
    # IHDR chunk
    ihdr = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr_crc = zlib.crc32(b'IHDR' + ihdr) & 0xffffffff
    ihdr_chunk = struct.pack('>I', len(ihdr)) + b'IHDR' + ihdr + struct.pack('>I', ihdr_crc)
    # Raw image data
    raw = b''
    for y in range(height):
        raw += b'\x00'  # filter byte
        for x in range(width):
            t = (x + y) / (width + height)
            r = int(start[0] + (end[0] - start[0]) * t)
            g = int(start[1] + (end[1] - start[1]) * t)
            b = int(start[2] + (end[2] - start[2]) * t)
            raw += bytes([r, g, b])
    # IDAT chunk
    compressed = zlib.compress(raw)
    idat_crc = zlib.crc32(b'IDAT' + compressed) & 0xffffffff
    idat_chunk = struct.pack('>I', len(compressed)) + b'IDAT' + compressed + struct.pack('>I', idat_crc)
    # IEND chunk
    iend_crc = zlib.crc32(b'IEND') & 0xffffffff
    iend_chunk = struct.pack('>I', 0) + b'IEND' + struct.pack('>I', iend_crc)
    # Save
    data = sig + ihdr_chunk + idat_chunk + iend_chunk
    with open(filename, 'wb') as f:
        f.write(data)

start = (0, 102, 255)    # #0066FF
end = (77, 148, 255)     # #4D94FF
sizes = [72, 96, 128, 144, 152, 192, 384, 512]

for folder in ['web-app/icons', 'docs/web-app/icons']:
    os.makedirs(folder, exist_ok=True)
    for size in sizes:
        path = os.path.join(folder, f'icon-{size}x{size}.png')
        create_gradient_png(size, size, start, end, path)
        print(f'Created {path}')

# Update manifest
manifest = {
    "name": "OCALM - Escrow Securise",
    "short_name": "OCALM",
    "description": "Fais tes affaires... Au Calme. Transactions securisees avec escrow.",
    "start_url": "./",
    "scope": "./",
    "display": "standalone",
    "background_color": "#FFFFFF",
    "theme_color": "#0066FF",
    "orientation": "portrait",
    "icons": []
}

for size in sizes:
    manifest["icons"].append({
        "src": f"./icons/icon-{size}x{size}.png",
        "sizes": f"{size}x{size}",
        "type": "image/png",
        "purpose": "any maskable"
    })

import json
for folder in ['web-app', 'docs/web-app']:
    with open(os.path.join(folder, 'manifest.json'), 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f'Updated manifest in {folder}')

print('All done!')
