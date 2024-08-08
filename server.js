const express = require('express');
const { exec } = require('child_process');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Servir le fichier HTML
app.use(express.static(__dirname));

wss.on('connection', (ws) => {
    ws.on('message', (message) => {
        // Exécuter la commande reçue
        exec(message, (error, stdout, stderr) => {
            if (error) {
                ws.send(`Erreur: ${error.message}`);
                return;
            }
            if (stderr) {
                ws.send(`Erreur: ${stderr}`);
                return;
            }
            ws.send(stdout);
        });
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Serveur en écoute sur http://localhost:${PORT}`);
});

