# Web Client
The web client is the interface that appears to the user.

> Game <--> Server **<--> Client**

  Grab IPC for electron communication, and JQuery for the DOM.

    {ipcRenderer} = require('electron')
    $ = require './node_modules/jquery/dist/jquery.js'

  We'll store the user's text input in a persistent buffer

    buffer = ""

  Flash represents a flash of text (challenges)
  They're meant to last a few seconds, then disappear.

    _flash = $('#flash')
    flash = (content)->
      _flash.html(content)

## *Challenge accepted*

    ipcRenderer.on 'challenge', (event, response)->
      console.log "Response: #{response}"
      _flash.html(response)
      _flash.attr("class", "user")

## Challenge responses
When the server responds to your submission.
`response.status` an http like code. `200` is OK.
`response.message` is feedback on your submission.

After `2000ms`, get a new challenge
by sending a `challenge-request`.

    ipcRenderer.on 'submission-response', (event, response)->
      console.log response.status
      flash response.message

      if response.status == 200
        _flash.attr("class", "success")
      else if response.status == 400
        _flash.attr("class", "error")

      window.setTimeout(->
          ipcRenderer.send('challenge-request')
        , 2000)

      return

  Fire off an initial challenge request to get started.

    ipcRenderer.send 'challenge-request'

  Helper functions

    numify = (char)-> char.charCodeAt()
    stringify = (num)-> String.fromCharCode(num)

## Input Handling

  We'll use a JQuery keypress listener.
  e.which contains a number, so numify&stringify will help out here.
  keys:
  `enter: 13` `backspace: 8`

    $(document).on 'keypress', (e)->
      # log the keys pressed for development
      console.log e.which
      ascii = stringify e.which
      # 0-9 goes into our submission buffer.
      if e.which >= numify("0") and e.which <= numify("9")
        buffer += ascii
      else if e.which is 8
        buffer = buffer.substring(0, buffer.length-1)
      # hit enter.
      else if e.which is 13
        ipcRenderer.send 'submission', buffer
        buffer = ""
      flash buffer
