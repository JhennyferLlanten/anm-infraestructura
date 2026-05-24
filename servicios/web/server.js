const http = require('http');
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');

const pool = new Pool({
    host: 'db',
    port: 5432,
    database: process.env.DB_NAME || 'anm_mineria',
    user: process.env.DB_USER || 'anm_user',
    password: process.env.DB_PASS || 'Anm2026*Secure',
});

const LOG_FILE = '/app/logs/inserciones.log';

function log(tipo, mensaje, datos = null) {
    const fecha = new Date().toISOString();
    const linea = datos
        ? `[${fecha}] [${tipo}] ${mensaje} | ${JSON.stringify(datos)}`
        : `[${fecha}] [${tipo}] ${mensaje}`;
    console.log(linea);
    fs.appendFileSync(LOG_FILE, linea + '\n');
}

fs.mkdirSync('/app/logs', { recursive: true });
log('INFO', 'Servidor ANM iniciado');

const server = http.createServer(async (req, res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

    if (req.method === 'GET' && req.url === '/api/titulos') {
        try {
            const result = await pool.query(
                'SELECT expediente, titular, mineral, departamento, estado FROM titulos_mineros ORDER BY created_at DESC LIMIT 20'
            );
            log('INFO', `Consulta exitosa — ${result.rows.length} registros retornados`);
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(result.rows));
        } catch(e) {
            log('ERROR', 'Fallo en consulta SELECT', { error: e.message });
            res.writeHead(500, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: e.message }));
        }
        return;
    }

    if (req.method === 'POST' && req.url === '/api/titulos') {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', async () => {
            try {
                const d = JSON.parse(body);
                log('INFO', 'Intento de inserción recibido', {
                    expediente: d.expediente,
                    titular: d.titular,
                    mineral: d.mineral,
                    departamento: d.departamento
                });
                await pool.query(
                    `INSERT INTO titulos_mineros
                        (expediente, titular, municipio, departamento, mineral, area_hectareas, fecha_inicio, fecha_vencimiento)
                     VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
                    [d.expediente, d.titular, d.municipio||null, d.departamento||null,
                     d.mineral||null, d.area_hectareas||null, d.fecha_inicio||null, d.fecha_vencimiento||null]
                );
                log('SUCCESS', 'Inserción exitosa en DB', {
                    expediente: d.expediente, titular: d.titular, mineral: d.mineral
                });
                res.writeHead(201, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ ok: true }));
            } catch(e) {
                log('ERROR', 'Fallo en inserción a DB', { error: e.message });
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: e.message }));
            }
        });
        return;
    }

    const filePath = path.join(__dirname, 'html', 'index.html');
    fs.readFile(filePath, (err, data) => {
        if (err) { res.writeHead(404); res.end('Not found'); return; }
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(data);
    });
});

server.listen(3001, () => log('INFO', 'API ANM corriendo en puerto 3001'));
