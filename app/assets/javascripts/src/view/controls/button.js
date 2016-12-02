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

  function toggleDisabledSaveNewTeamObjectiveButton(input){
    switch(input){
      case 0: $('#btn_new_team_objective').prop( "disabled", false );
              break;
      case 1: $('#btn_new_team_objective').prop( "disabled", true );
              break;
    }
  }

  function toggleButtonDisability(btn_info, input){
    switch(input){
      case 0: $(btn_info).prop( "disabled", false );
              break;
      case 1: $(btn_info).prop( "disabled", true );
              break;
    }
  }

  // --------------------
  // Button Click Section
  // --------------------

  function resolveButtonClick(btn_info, resolve){
    $(btn_info).click(resolve);
  }

  function hideButton(btn_info){
    $(btn_info).attr('style', 'visibility: hidden;');
  }

  function notificationDismissClick(input){
    if(input == 1){
      $('#notification_dismiss_btn').click(function(event) {
        // location.reload();
      });
    }
  }

  return{
    toggleButtonDisability,
    toggleDisabledSaveNewPersonalObjectiveButton,
    toggleDisabledSaveNewTeamObjectiveButton,
    resolveButtonClick,
    hideButton,
    notificationDismissClick
  }

})