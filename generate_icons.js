const fs = require('fs');
const path = require('path');

const sizes = [72, 96, 128, 144, 152, 192, 384, 512];
const folders = ['web-app/icons', 'docs/web-app/icons'];

// Simple colored rect as base64
function createPngBuffer(size) {
  // PNG signature
  const sig = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
  
  // Create a simple minimal valid PNG with solid blue color
  // Using a very basic chunk structure
  function makeChunk(type, data) {
    const chunk = Buffer.concat([Buffer.from(type), data]);
    const crc = require('zlib').crc32(chunk);
    const len = Buffer.alloc(4);
    len.writeUInt32BE(data.length, 0);
    const crcBuf = Buffer.alloc(4);
    crcBuf.writeUInt32BE(crc, 0);
    return Buffer.concat([len, chunk, crcBuf]);
  }
  
  // IHDR
  const ihdrData = Buffer.alloc(13);
  ihdrData.writeUInt32BE(size, 0);  // width
  ihdrData.writeUInt32BE(size, 4);  // height
  ihdrData.writeUInt8(8, 8);        // bit depth
  ihdrData.writeUInt8(2, 9);        // color type RGB
  ihdrData.writeUInt8(0, 10);       // compression
  ihdrData.writeUInt8(0, 11);       // filter
  ihdrData.writeUInt8(0, 12);       // interlace
  
  // Create pixel data - solid blue (#0066FF)
  const r = 0, g = 102, b = 255;
  const rowSize = 1 + size * 3;  // filter byte + RGB data
  const rawData = Buffer.alloc(rowSize * size);
  
  for (let y = 0; y < size; y++) {
    rawData[y * rowSize] = 0;  // filter: none
    for (let x = 0; x < size; x++) {
      const idx = y * rowSize + 1 + x * 3;
      rawData[idx] = r;
      rawData[idx + 1] = g;
      rawData[idx + 2] = b;
    }
  }
  
  // IDAT (compressed)
  const compressed = require('zlib').deflateSync(rawData);
  
  // Build PNG
  const ihdr = makeChunk('IHDR', ihdrData);
  const idat = makeChunk('IDAT', compressed);
  const iend = makeChunk('IEND', Buffer.alloc(0));
  
  return Buffer.concat([sig, ihdr, idat, iend]);
}

// Create folders
folders.forEach(folder => {
  if (!fs.existsSync(folder)) fs.mkdirSync(folder, { recursive: true });
});

// Generate icons
sizes.forEach(size => {
  const buf = createPngBuffer(size);
  folders.forEach(folder => {
    const filepath = path.join(folder, `icon-${size}x${size}.png`);
    fs.writeFileSync(filepath, buf);
    console.log(`Created ${filepath} (${buf.length} bytes)`);
  });
});

// Update manifest
const manifest = {
  name: "OCALM - Escrow Securise",
  short_name: "OCALM",
  description: "Fais tes affaires... Au Calme. Transactions securisees avec escrow.",
  start_url: "./",
  scope: "./",
  display: "standalone",
  background_color: "#FFFFFF",
  theme_color: "#0066FF",
  orientation: "portrait",
  icons: sizes.map(size => ({
    src: `./icons/icon-${size}x${size}.png`,
    sizes: `${size}x${size}`,
    type: "image/png",
    purpose: "any maskable"
  }))
};

folders.forEach(folder => {
  const filepath = path.join(folder, '..', 'manifest.json');
  fs.writeFileSync(filepath, JSON.stringify(manifest, null, 2));
  console.log(`Updated manifest: ${filepath}`);
});

console.log('All icons generated!');
