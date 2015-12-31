var BrowserWindow, app, electron, game, ipc, mainwindow;

electron = require('electron');

game = require("./game/numbergame")();

app = electron.app;

ipc = electron.ipcMain;

BrowserWindow = electron.BrowserWindow;

mainwindow = null;

console.log('starting');

app.on('window-all-closed', function() {
  console.log('all closed');
  if (process.platform !== 'darwin') {
    return app.quit();
  }
});

app.on('ready', function() {
  console.log('ready');
  mainwindow = new BrowserWindow({
    width: 800,
    height: 600
  });
  mainwindow.loadURL("file://" + __dirname + "/index.html");
  mainwindow.webContents.openDevTools();
  mainwindow.setMenu(null);
  mainwindow.center();
  mainwindow.focus();
  mainwindow.maximize();
  mainwindow.on('closed', function() {
    console.log('closed');
    return mainwindow = null;
  });
  ipc.on('challenge-request', function(event) {
    console.log("Received a challenge");
    return event.sender.send('challenge', game.challenge());
  });
  return ipc.on('submission', function(event, data) {
    console.log("Received a submission");
    return game.check(data).then(function(response) {
      console.log("Game check responded with " + response);
      return event.sender.send('submission-response', response);
    }, function(reason) {
      console.log("Game rejected with " + reason);
      return event.sender.send('submission-response', reason);
    });
  });
});
