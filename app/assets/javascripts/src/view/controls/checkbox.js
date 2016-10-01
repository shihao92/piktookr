// Date: 20 September 2016
// JS file to control all the checkboxes in the project.

define(function(){

  function checkUncheckPersonalKeyResult(resolve)
  {
    $('input[name=personal_kr_checkbox]').click(resolve);
  }

  return{
    checkUncheckPersonalKeyResult
  }

})