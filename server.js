const express = require('express');
const { exec } = require('child_process');
const http = require('http');
const WebSocket = require('ws');

const readline = require('readline');
readline.emitKeypressEvents(process.stdin);

if (process.stdin.isTTY) {

process.stdin.setRawMode(true);
}


const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });




// Servir le fichier HTML
app.use(express.static(__dirname));

wss.on('connection', (ws) => {
    ws.on('message', (message) => {

        const command = message.toString().trim();  // Supprime les espaces en début/fin de commande
	    console.log("cmd: ",command);
        console.log("size: ",message.length);
        if (command == 'exit'){
            process.exit();
           }
        

        if (message.length != "") {
               const command = message.toString().trim();  // Supprime les espaces en début/fin de commande
	
             console.log(command);
 

    

        exec(command, (error, stdout, stderr) => {
            if (error) {
                ws.send('Erreur: ${error.message}\r\n');
                return;
            }
            if (stderr) {
                ws.send('Erreur: ${stderr}\r\n');
                return;
            }

            // Nettoyer la sortie pour assurer un bon affichage dans le terminal
            ws.send(stdout.replace(/\n/g, '\r\n'));
          
        });
    
    }

    });
});

process.on('SIGINT', function() {
    console.log("Caught interrupt signal");

    if (i_should_exit)
        process.exit();
});


const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Serveur en écoute sur http://localhost:${PORT}`);
});

