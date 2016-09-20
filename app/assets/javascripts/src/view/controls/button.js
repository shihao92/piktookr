// Date: 20 September 2016
// JS file to control all the buttons in the project.

define(['view/controls/overlay', 'model/personal_objective'],
function(overlay, personalObjectiveModel){

  function toggleDisabledSaveNewPersonalObjectiveButton(input){
    switch(input){
      case 0: $('#btn_new_personal_objective').prop( "disabled", false );
              break;
      case 1: $('#btn_new_personal_objective').prop( "disabled", true );
              break;
    }
  }

  // --------------------
  // Button Click Section
  // --------------------
  function newPersonalObjectiveButtonClick(resolve){ 
    $('#btn_new_personal_objective').click(resolve);
  }

  function editPersonalObjectiveButtonClick(resolve){ 
    $('.edit_personal_objective').click(resolve); 
  }

  function updatePersonalKeyResultProgressClick(resolve){
    $('#btn_update_progress').click(resolve);
  }

  function editPersonalKeyResultButtonClick(resolve){
    $('.edit_personal_key_result').click(resolve);
  }

  function hideEditPersonalObjectiveButton(){
    $('.edit_personal_objective').attr('style', 'visibility: hidden;');
  }

  function hideEditPersonalKeyResultButton(){
    $('.edit_personal_key_result').attr('style', 'visibility: hidden;');
  }

  function notificationDismissClick(){
    $('#notification_dismiss_btn').click(function() {
        location.reload();
    });
  }

  return{
    toggleDisabledSaveNewPersonalObjectiveButton,
    newPersonalObjectiveButtonClick,
    editPersonalObjectiveButtonClick,
    updatePersonalKeyResultProgressClick,
    editPersonalKeyResultButtonClick,
    hideEditPersonalObjectiveButton,
    hideEditPersonalKeyResultButton,
    notificationDismissClick
  }

})