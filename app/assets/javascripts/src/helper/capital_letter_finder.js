// Date : 14 November 2016
// This JS file that find capital letter in the string.

define(function() {

  function findCapitalLetter(input){
    let capital_phrase = "";
    for(let count = 0 ; count < input.length ; count ++){
      if(input.charAt(count) == input.charAt(count).toUpperCase()){
        capital_phrase = capital_phrase + input.charAt(count);
      }
    }
    return capital_phrase;
  }

  return {
    findCapitalLetter
  }

})