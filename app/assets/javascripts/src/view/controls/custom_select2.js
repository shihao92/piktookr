// Date: 20 September 2016
// JS file to customize the control - select2.

define(['view/library/select2.min',
'view/controls/button', 'view/controls/input_textbox'],
function(select2LibraryParam, btnControl, textboxControl){

  function teamKeyResultSelectionChanged(){
    $('#team_key_result_selection').on('change', function() {
      textboxControl.checkPersonalObjectiveInput();
    }); 
  }

  function companyKeyResultSelectionChanged(){
    $('#company_key_result_selection').on('change', function() {
      if($('#team_objective_textarea').val() != "") {
        btnControl.toggleDisabledSaveNewTeamObjectiveButton(0);
      }
    });
  }

  return{
    teamKeyResultSelectionChanged,
    companyKeyResultSelectionChanged
  }

})