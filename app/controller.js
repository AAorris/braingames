module.exports = function() {
  var i, j, l, len, len1, letters, n, numbers, pressed_letter, pressed_number;
  this.listener = new window.keypress.Listener();
  numbers = "0123456789";
  letters = "abcdefghijklmnopqrstuvwxyz";
  this.numpress_callbacks = [];
  pressed_number = function(number) {
    var callback, i, len, ref, results;
    ref = this.numpress_callbacks;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      callback = ref[i];
      results.push(callback(number));
    }
    return results;
  };
  this.letterpress_callbacks = [];
  pressed_letter = function(letter) {
    var callback, i, len, ref, results;
    ref = this.letterpress_callbacks;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      callback = ref[i];
      results.push(callback(letter));
    }
    return results;
  };
  this.buffer = "";
  this.numpress_callbacks.push(function(number) {
    this.buffer += number;
    return console.log(this.buffer);
  });
  this.letterpress_callbacks.push(function(letter) {
    this.buffer += letter;
    return console.log(this.buffer);
  });
  for (i = 0, len = numbers.length; i < len; i++) {
    n = numbers[i];
    this.listener.simple_combo("" + n, pressed_number.bind(this, n));
  }
  for (j = 0, len1 = letters.length; j < len1; j++) {
    l = letters[j];
    this.listener.simple_combo("" + l, pressed_letter.bind(this, l));
  }
  return this;
};
