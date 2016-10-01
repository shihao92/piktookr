// Date : 20 September 2016
// This JS file that convert string to int (Numbers only).

define(function() {

  function processAvatarURL(input){
    let avatar_id_string = "";
    let temp_input_string = String(input);
    if(temp_input_string.length === 1){
      avatar_id_string = '00' + temp_input_string;
    } else if(temp_input_string.length === 2) {
      avatar_id_string = '0' + temp_input_string;
    } else {
      avatar_id_string = temp_input_string;
    } 

    return avatar_id_string;
  }

  return{
    processAvatarURL
  }

})