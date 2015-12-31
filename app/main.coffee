electron = require 'electron'
game = require("./game/numbergame")()

app = electron.app
ipc = electron.ipcMain
BrowserWindow = electron.BrowserWindow

mainwindow = null
console.log 'starting'

app.on 'window-all-closed', ()->
  console.log 'all closed'
  if process.platform != 'darwin'
    app.quit()

app.on 'ready', ()->
  console.log 'ready'
  mainwindow = new BrowserWindow {width: 800, height:600}
  mainwindow.loadURL "file://#{__dirname}/index.html"
  mainwindow.webContents.openDevTools()
  mainwindow.setMenu(null)
  mainwindow.center()
  mainwindow.focus()
  mainwindow.maximize()
  mainwindow.on 'closed', ()->
    console.log 'closed'
    mainwindow = null

  ipc.on 'challenge-request', (event)->
    console.log "Received a challenge"
    event.sender.send 'challenge', game.challenge()

  ipc.on 'submission', (event, data)->
    console.log "Received a submission"
    game.check(data).then(
      (response)->
        console.log "Game check responded with #{response}"
        event.sender.send 'submission-response', response
      , (reason)->
        console.log "Game rejected with #{reason}"
        event.sender.send 'submission-response', reason)
