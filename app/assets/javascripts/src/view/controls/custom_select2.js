// Date: 20 September 2016
// JS file to customize the control - select2.

define(['view/library/select2.min',
'view/controls/button'],
function(select2LibraryParam, btnParam){

  function teamKeyResultSelectionChanged(){
    $('#team_key_result_selection').on('change', function() {
      if($('#personal_objective_textarea').val() != "") {
        btnParam.toggleDisabledSaveNewPersonalObjectiveButton(0);
      }
    }); 
  }

  function companyKeyResultSelectionChanged(){
    $('#company_key_result_selection').on('change', function() {
      if($('#team_objective_textarea').val() != "") {
        btnParam.toggleDisabledSaveNewTeamObjectiveButton(0);
      }
    });
  }

  return{
    teamKeyResultSelectionChanged,
    companyKeyResultSelectionChanged
  }

})