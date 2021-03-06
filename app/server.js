// Generated by CoffeeScript 1.10.0
(function() {
  var BrowserWindow, app, game, ipcMain, mainwindow, ref;

  ref = require('electron'), app = ref.app, BrowserWindow = ref.BrowserWindow, ipcMain = ref.ipcMain;

  game = require('./game');

  mainwindow = null;

  app.on('ready', function() {
    var settings;
    settings = {
      width: 800,
      height: 600
    };
    mainwindow = new BrowserWindow(settings);
    mainwindow.loadURL("file://" + __dirname + "/index.html");
    mainwindow.maximize();
    return mainwindow.on('closed', function() {
      return mainwindow = null;
    });
  });

  app.on('window-all-closed', function() {
    if (process.platform !== 'darwin') {
      return app.quit();
    }
  });

  ipcMain.on('challenge-request', function(event) {
    return event.sender.send('challenge', game.challenge(event));
  });

  ipcMain.on('challenge-submission', function(event, data) {
    return game.receive_submission(data).then(function(response) {
      return event.sender.send('submission-response', response);
    }, function(reason) {
      return event.sender.send('submission-response', reason);
    });
  });

}).call(this);
