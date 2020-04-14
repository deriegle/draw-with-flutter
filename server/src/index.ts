import * as express from 'express';
import * as WebSocket from 'ws';
import * as http from 'http';
import { ILine, parseILineFromString } from './interfaces/ILine';

const app = express();
const server = http.createServer(app);
const webSocketServer = new WebSocket.Server({ server });

const lines: ILine[] = []

// TODO: Add ping/pong for checking for unresponsive clients
webSocketServer.on('connection', (ws: WebSocket) => {
  ws.on('message', (message: string) => {
    console.log('new message');
    const newLines = parseILineFromString(message);

    if (newLines === null) {
      console.log(`Received message: ${message}`);
      ws.send(`Hello, you sent -> ${message}`);
    } else {
      lines.push(...newLines);
      // Alert client that we added the new lines
      ws.send(`Added ${newLines.length} new lines`);

      // Alert clients of new lines added
      webSocketServer.clients.forEach(client => {
        if (client != ws) {
          client.send(JSON.stringify({
            message: `Added ${newLines.length} new lines`,
            added: newLines.length,
            total: lines.length,
            lines: newLines,
          }));
        }
      });

      console.log(`-------------------------`);
      console.log(`Added: ${newLines.length}`);
      console.log(`Total: ${lines.length}`);
    }
  });

  ws.send(JSON.stringify({
    message: `${lines.length} lines on server right now`,
    added: 0,
    total: lines.length,
    lines,
  }));
});

const port = process.env.PORT || 8080;
server.listen(port, () => {
  console.log(`Server started on port ${port}`);
});


