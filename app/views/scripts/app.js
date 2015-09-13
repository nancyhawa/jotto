$(function(){
  renderAlphabet($('#alphabet'));
  renderAlphabet2($('#alphabet2'));
  $('.letter_wrapper').on('click', rotateLetterImage)


});

function rotateLetterImage(){
  var letterImage = {
    'blank': "",
    'red': "<img id=\"letter_image_js\" src=\"images/red-x.png\">",
    'yellow': "<img id=\"letter_image_js\" src=\"images/yellow-question-mark.png\">",
    'green': "<img id=\"letter_image_js\" src=\"images/green-circle.png\">",
  };
  // debugger
  if (this.childNodes[0].innerHTML == letterImage['blank']){
    this.childNodes[0].innerHTML = letterImage['green']
  }else if (this.childNodes[0].innerHTML == letterImage['green']) {
    // debugger
    this.childNodes[0].innerHTML = letterImage['yellow']
  }else if (this.childNodes[0].innerHTML == letterImage['yellow']) {
    // debugger
    this.childNodes[0].innerHTML = letterImage['red']
  }else if (this.childNodes[0].innerHTML == letterImage['red']) {
    this.childNodes[0].innerHTML = letterImage['blank']
  };
}
// Letter.prototype.rotate = function(){
//   this.picIndex += 1
// };
//
// Letter.prototype.rotateImage = function(){
//
// };

function renderAlphabet(parent){
  // debugger
  var alphabet = "ABCDEFGHIJKLM".split("")

  alphabet.forEach(function(letter){
    parent.append(renderLetterTemplate(letter))
  })
}

function renderAlphabet2(parent){
  var alphabet = "NOPQRSTUVWXYZ".split("")

  alphabet.forEach(function(letter){
    parent.append(renderLetterTemplate(letter))
  })
}

function renderLetterTemplate(letter){
  return "<div class='letter_wrapper clearfix'>" +
        "<div class='background_image clearfix'>" +
          "" +
        "</div>" +
        "<div class='letter'>" +
          letter +
        "</div>" +
        "</div>"
}
