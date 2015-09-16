$(function(){
  renderAlphabet($('#alphabet'));
  renderAlphabet2($('#alphabet2'));

  $("#submit_button").attr("disabled", "true");

  $('.letter_wrapper').on('click', rotateLetterImage);

  $('#input_field').on('blur', validateWord);

  $('.help_image_js').click(function(){
    $('#directions').slideToggle(2000);
    // $('#directions_text').fadeToggle(2000);
  });

//This takes the users guess and puts it in the guesses table
  $('#guess_form').submit(function(e){
    e.preventDefault();
    // if (validateWord()){
      var input = $('#input_field').val().toLowerCase()
      var computerWord = $('#computer_word').val()

      if (input == computerWord){
        congratulateWinner()
      }else {$.post( '/guesses', {guess: {word: input, computer_word: computerWord}}, function(data){
        var word = data.word.toUpperCase
        var count = data.count
        $('#guesses').append(renderTableRow(word, count))
      }, 'json');

      this.reset();
      $('.error').remove();
      $("#submit_button").attr("disabled", "true");
    };
  });
});

function congratulateWinner(){
  $('#guess_form').remove;

  $('#guess_form_wrapper').html(
    "<div id='winner'>Congratulations!  You Win!!" +
    "<div id='play_again_button'>" +
    "<a href='/index'>Play Again!</a>" +
    "</div>" +
    "</div>")
}

function renderTableRow(word, count){
  return "<tr>" +
    "<td>" + word + "</td>" +
    "<td>" + count + "</td>" +
  "</tr>"
}

function rotateLetterImage(){
  var letterImage = {
    'blank': "",
    'red': "<img id=\"letter_image_js\" src=\"images/red-x.png\">",
    'yellow': "<img id=\"letter_image_js\" src=\"images/yellow-question-mark.png\">",
    'green': "<img id=\"letter_image_js\" src=\"images/green-circle.png\">",
  };

  if (this.childNodes[0].innerHTML == letterImage['blank']){
    this.childNodes[0].innerHTML = letterImage['green']
  }else if (this.childNodes[0].innerHTML == letterImage['green']) {
    this.childNodes[0].innerHTML = letterImage['yellow']
  }else if (this.childNodes[0].innerHTML == letterImage['yellow']) {
    this.childNodes[0].innerHTML = letterImage['red']
  }else if (this.childNodes[0].innerHTML == letterImage['red']) {
    this.childNodes[0].innerHTML = letterImage['blank']
  };
}

function Guess(word, computerWord){
  this.word = word
  this.computerWord = computerWord
}

function renderAlphabet(parent){
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

function repeatLetters(word){
  var letters = word.toLowerCase().split("")
  var n = [];
  for(var i = 0; i < letters.length; i++)
      {
    if (n.indexOf(letters[i]) == -1) n.push(letters[i]);
      }
  if (n.length != 5){
    return true
  }else {
    return false
  }
}

function validateWord(){
  var word = $('#input_field').val().toLowerCase()
  $('.error').remove()

  if (word.split("").length != 5){
    $('#input_field').before("<div class='error'>" +
      "Your word must be five letters long." +
      "</div>")
  }else if (repeatLetters(word)){
    $('.error').remove();
    $('#input_field').before("<div class='error'>" +
      "Your must not contain repeat letters." +
      "</div>")
  }else { isWord(word) }
}

function isWord(input){
    $.post( '/words', {guess: {word: input}}).done(function(message){
      if (message == "false"){
        $('.error').remove();
        $('#input_field').before("<div class='error'>" +
          "That word is not in our dictionary." +
          "</div>")
      }else {
        $('.error').remove()
        $("#submit_button").removeAttr('disabled')
      }
    });
}

function isWordOutcome(message){
  debugger
  if (message == "true"){
    return true
  }else {
    return false
  }
}
