const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const DATABASE_URL = process.env.DATABASE_URL;
if (!DATABASE_URL) {
  console.error('DATABASE_URL is not set');
  process.exit(1);
}

async function init() {
  const client = new Client({ connectionString: DATABASE_URL, ssl: { rejectUnauthorized: false } });
  try {
    await client.connect();
    console.log('Connected to PostgreSQL');

    const sqlPath = path.join(__dirname, 'init.sql');
    if (!fs.existsSync(sqlPath)) {
      console.log('init.sql not found, skipping DB init');
      return;
    }

    const sql = fs.readFileSync(sqlPath, 'utf-8');
    // Split on semicolons, filter out empty statements
    const statements = sql.split(';').map(s => s.trim()).filter(Boolean);

    for (const stmt of statements) {
      try {
        await client.query(stmt + ';');
      } catch (err) {
        // Ignore "already exists" errors
        if (err.code === '42P07' || err.code === '42710' || err.message.includes('already exists')) {
          console.log('SKIP (already exists):', stmt.substring(0, 50) + '...');
        } else {
          console.error('SQL error:', err.message, '| Statement:', stmt.substring(0, 100));
        }
      }
    }

    console.log('Database initialization complete');
  } catch (err) {
    console.error('DB init failed:', err.message);
    process.exit(1);
  } finally {
    await client.end();
  }
}

init();
