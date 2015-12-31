ipc = require('electron').ipcRenderer
# controller = require('./controller')()
$ = require './node_modules/jquery/dist/jquery.js'

# ------
# setup
# ------

buffer = ""

_flash = $('#flash')
flash = (content)->
  _flash.html(content)

ipc.on 'challenge', (event, response)->
  console.log "Response: #{response}"
  _flash.html(response)
  _flash.attr("class", "user")

ipc.on 'submission-response', (event, response)->
  console.log response.status
  flash response.message

  window.setTimeout(->
      ipc.send('challenge-request')
    , 2000)

  if response.status == 200
    _flash.attr("class", "success")
  else if response.status == 400
    _flash.attr("class", "error")

  return

# ------
# launch
# ------

ipc.send 'challenge-request'

numify = (char)-> char.charCodeAt()
stringify = (num)-> String.fromCharCode(num)

$(document).on 'keypress', (e)->
  console.log e.which
  ascii = stringify e.which
  if e.which >= numify("0") and e.which <= numify("9")
    buffer += ascii
  else if e.which is 13
    ipc.send 'submission', buffer
    buffer = ""
  flash buffer


# controller.listener.simple_combo "enter", ->
#   flash controller.buffer
#   controller.buffer = ""
