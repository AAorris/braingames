var $, _flash, buffer, flash, ipc, numify, stringify;

ipc = require('electron').ipcRenderer;

$ = require('./node_modules/jquery/dist/jquery.js');

buffer = "";

_flash = $('#flash');

flash = function(content) {
  return _flash.html(content);
};

ipc.on('challenge', function(event, response) {
  console.log("Response: " + response);
  _flash.html(response);
  return _flash.attr("class", "user");
});

ipc.on('submission-response', function(event, response) {
  console.log(response.status);
  flash(response.message);
  window.setTimeout(function() {
    return ipc.send('challenge-request');
  }, 2000);
  if (response.status === 200) {
    _flash.attr("class", "success");
  } else if (response.status === 400) {
    _flash.attr("class", "error");
  }
});

ipc.send('challenge-request');

numify = function(char) {
  return char.charCodeAt();
};

stringify = function(num) {
  return String.fromCharCode(num);
};

$(document).on('keypress', function(e) {
  var ascii;
  console.log(e.which);
  ascii = stringify(e.which);
  if (e.which >= numify("0") && e.which <= numify("9")) {
    buffer += ascii;
  } else if (e.which === 13) {
    ipc.send('submission', buffer);
    buffer = "";
  }
  return flash(buffer);
});
