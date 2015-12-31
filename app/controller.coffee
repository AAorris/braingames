module.exports = ()->
  @listener = new window.keypress.Listener()

  numbers = "0123456789"
  letters = "abcdefghijklmnopqrstuvwxyz"

  @numpress_callbacks = []
  pressed_number = (number)->
    for callback in @numpress_callbacks
      callback(number)

  @letterpress_callbacks = []
  pressed_letter = (letter)->
    for callback in @letterpress_callbacks
      callback(letter)

  @buffer = ""

  @numpress_callbacks.push (number)->
    @buffer += number
    console.log @buffer

  @letterpress_callbacks.push (letter)->
    @buffer += letter
    console.log @buffer

  for n in numbers
    @listener.simple_combo "#{n}", pressed_number.bind(@, n)

  for l in letters
    @listener.simple_combo "#{l}", pressed_letter.bind(@, l)

  this
