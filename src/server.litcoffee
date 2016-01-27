# Braingames Server

This runs the back end of the electron application.
The server communicates with the client using the ipc module.
We'll configure the browser, display it, and route events to the game.

    # See: Destructured assignment
    {app, BrowserWindow, ipcMain} = require('electron')
    game = require './game'
    mainwindow = null

The app will create `ready` and `window-all-closed` events.

## Ready

  The ready event will prepare the window.
  Options you can include in customization here:
  ```coffee
  mainwindow.setMenu(null)
  mainwindow.center()
  mainwindow.focus()
  ```

    app.on 'ready', ->
      settings=
        width: 800
        height: 600
      mainwindow = new BrowserWindow settings
      mainwindow.loadURL "file://#{__dirname}/index.html"
      mainwindow.maximize()
      mainwindow.on 'closed', ->
        mainwindow = null

## All Closed

  FIXME: I'm not sure what's up with darwin

    app.on 'window-all-closed', ->
      if process.platform != 'darwin'
        app.quit()

## Client Communication

  We need to pass messages to the game,
  and ipcMain is the communication module.

    ipcMain.on 'challenge-request', (event)->
      event.sender.send 'challenge', game.challenge(event)

  Challenge responses from the user are challenge 'submissions'.
  A response is ambiguous for acknowledgement, or something else.

    ipcMain.on 'challenge-submission', (event, data)->
      game.receive_submission(data).then(
        (response)->
          event.sender.send 'submission-response', response
        ,(reason)->
          event.sender.send 'submission-response', reason)
