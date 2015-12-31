var numify, stringify;

numify = function(char) {
  return char.charCodeAt();
};

stringify = function(num) {
  return String.fromCharCode(num);
};

module.exports = function() {
  this.level = 2;
  this.truth = "";
  this.challenge = function() {
    var num;
    this.truth = ((function() {
      var i, ref, results;
      results = [];
      for (num = i = 0, ref = level - 1; 0 <= ref ? i <= ref : i >= ref; num = 0 <= ref ? ++i : --i) {
        results.push(stringify(Math.floor(Math.random() * 10 + numify("0"))));
      }
      return results;
    })()).join("");
    console.log(this.truth);
    return this.truth;
  };
  this.check = function(data) {
    return new Promise(function(fulfill, reject) {
      if (data === this.truth) {
        fulfill({
          status: 200,
          message: "Correct."
        });
        return this.level += 1;
      } else {
        return reject({
          status: 400,
          message: "Incorrect. Answer was " + this.truth
        });
      }
    });
  };
  return this;
};