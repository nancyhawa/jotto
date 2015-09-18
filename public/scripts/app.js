$(function(){
  renderAlphabet($('#alphabet'));
  renderAlphabet2($('#alphabet2'));

  // $("#submit_button").attr("disabled", "true");

  $('#guess_form').submit(function(e){
    e.preventDefault();
    validateWord();
  });


  $('.letter_wrapper').on('click', rotateLetterImage);

  $('.help_image_js').click(function(){
    $('#directions').slideToggle(2000);
  });

});

function sendItToBackend(){
    $('.ind-error').remove()

    var input = $('#input_field').val().toLowerCase()
    var computerWord = $('#computer_word').val()

    if (input == computerWord){
      congratulateWinner()
    }else {$.post( '/guesses', {guess: {word: input, computer_word: computerWord}}, function(data){
      var word = data.word.toUpperCase()
      var count = data.count
      $('#guesses').append(renderTableRow(word, count))
    }, 'json');

    $('#input_field').val("");
    $('.error').remove();
    $('#guesslist_hash').animate({ scrollTop: $('#guesslist_hash')[0].scrollHeight}, 3000)
  };
};

function congratulateWinner(){
  $('#guess_form').remove;

  $('#guess_form_wrapper').html(
    "<div id='winner'>Congratulations!  You Win!!" +
    "<div id='play_again_button'>" +
    "<a href='/'>Play Again!</a>" +
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
  var letters = $('#input_field').val().toLowerCase().split("")
  var n = [];
  for(var i = 0; i < letters.length; i++)
      {
    if (n.indexOf(letters[i]) == -1) n.push(letters[i]);
      }
  if (n.length != letters.length){
    return true
  }else {
    return false
  }
}

function validateLetterCount(word){
  // debugger
  var word = $('#input_field').val().toLowerCase()

  if (word.split("").length != 5){
    $('#errors').append("<div class='ind-error' id='repeat'>" +
      "Your word must be five letters long." +
      "</div>")
      return false
  } else {return true};
}

function validateRepeatLetters(word){
  if (repeatLetters($('#input_field').val())){
      $('#errors').append("<div class='ind-error' id='repeat'>" +
      "Your word must not contain repeat letters." +
      "</div>")
      return false
    } else {return true};
}

function validateWord(){

  var word = $('#input_field').val().toLowerCase()
  // debugger
  $('.ind-error').remove()

  if (validateLetterCount(word) && validateRepeatLetters(word)){
      validateIsWord(word)
    };
}

function validateIsWord(input){
    $.post( '/words', {guess: {word: input}}).done(function(message){
      if (message == "false"){
        $('#errors').append("<div class='ind-error' id='dictionary'>" +
          "That word is not in our dictionary." +
          "</div>")
      }else {
        $('.ind-error').remove();
        sendItToBackend();
      }
    });
}

// function submitWord(){
//   if (typeOf validateWord() === "undefined"){
//
//   };
// }
//
// function returnTrue(){
//   return true
// }
// }
