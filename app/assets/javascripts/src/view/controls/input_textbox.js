// Date: 20 September 2016
// JS file to control all the inputs in the project.

define(['view/controls/overlay', 'view/controls/button'],
function(overlayParam, btnControl){

  function addNewPersonalObjective(resolve){
    $('#add-new-personal-objective')
    .on({
      keypress: resolve
    });
  }

  function checkPersonalObjectiveInput(resolve){
    $('#personal_objective_textarea')
    .on({
      keypress: resolve
    })
  }

  function editPersonalObjective(resolve){
    $('.panel-heading-a')
    .on({
      keypress: resolve,
      focusout: function(){
        location.reload();
      }
    },'.add-new-personal-key-result');
  }

  function addNewPersonalKeyResult(resolve){
    $('input[name=new_key_result]')
    .on({
      keypress: resolve      
    });
  }

  function editPersonalKeyResult(resolve){
    $('.accordion-item-title')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    }, '.add-new-personal-key-result');
  }

  function createInputTextboxForEditPersonalObjective(objective_id, original_objective){
    $('#personal_objective_' + objective_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);

    $('#personal_objective_' + objective_id)
    .find('.form-new-key-result')
    .focus();
    $('#personal_objective_' + objective_id)
    .find('.form-new-key-result')
    .select();
  }

  function createInputTextboxForEditPersonalKeyResult(key_result_id, original_key_result){
    $('#personal_kr_' + key_result_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result" data-id="' + key_result_id + '" />')
    .find('.form-new-key-result').val(original_key_result);

    $('#personal_kr_' + key_result_id)
    .find('.form-new-key-result')
    .focus();
    $('#personal_kr_' + key_result_id)
    .find('.form-new-key-result')
    .select();
  }

  function createInputTextboxForEditTeamObjective(objective_id, original_objective){
    $('#team_objective_' + objective_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-team-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);

    $('#team_objective_' + objective_id)
    .find('.form-new-key-result')
    .focus();
    $('#team_objective_' + objective_id)
    .find('.form-new-key-result')
    .select();
  }

  function createInputTextboxForEditTeamKeyResult(key_result_id, original_key_result){
    $('#team_kr_' + key_result_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-team-key-result" data-id="' + key_result_id + '"/>')
    .find('.form-new-key-result')
    .val(original_key_result);

    $('#team_kr_' + key_result_id)
    .find('.form-new-key-result')
    .focus();
    $('#team_kr_' + key_result_id)
    .find('.form-new-key-result')
    .select();
  }

  function createInputTextboxForEditCompanyKeyResult(key_result_id, original_key_result){
    $('#company_kr_' + key_result_id)
    .empty()
    .html('<input name="edit_company_key_result" type="text" class="form-control form-new-key-result add-new-company-key-result" data-id="' + key_result_id + '"/>')
    .find('.form-new-key-result')
    .val(original_key_result);

    $('#company_kr_' + key_result_id)
    .find('.form-new-key-result')
    .focus();
    $('#company_kr_' + key_result_id)
    .find('.form-new-key-result')
    .select();
  }

  function createInputTextboxForEditCompanyObjective(objective_id, original_objective){
    $('#company_objective_' + objective_id)
    .empty()
    .html('<input name="edit_company_objective" type="text" class="form-control form-new-key-result add-new-company-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);

    $('#company_objective_' + objective_id)
    .find('.form-new-key-result')
    .focus();
    $('#company_objective_' + objective_id)
    .find('.form-new-key-result')
    .select();
  }

  function addNewTeamObjective(resolveFocusOut, resolveKeypress){
    $('#add-new-team-objective')
    .on({
      focusout: resolveFocusOut,
      keypress: resolveKeypress
    });
  }

  function addNewTeamKeyResult(resolve){
    $('input[name=new_team_key_result]')
    .on({
      keypress: resolve
    });
  }

  function editTeamObjective(resolve){
    $('.panel-heading-a')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    },'.add-new-team-key-result');
  }

  function editTeamKeyResult(resolve){
    $('.accordion-item')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    },'.add-new-team-key-result');
  }

  function addNewCompanyKeyResult(resolve){
    $("input[name=new_company_key_result]")
    .on({
      keypress: resolve
    });
  }

  function editCompanyKeyResult(resolve){
    $(".checkbox-primary")
    .find('.key-result')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    });
  }

  function addNewCompanyObjective(resolveFocusOut, resolveKeypress){
    $("#add-new-company-objective")
    .on({
      focusout: resolveFocusOut,
      keypress: resolveKeypress
    });
  }

  function editCompanyObjective(resolve){
    $('.panel-heading-a')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    }, "input[name=edit_company_objective]");
  }

  function searchUser(resolve){
    $('#search_okr_users')
    .on({
      click: resolve
    });
  }

  function searchingUser(resolve){
    $('#overlay_search_user_input')
    .on({
      keypress: resolve
    });
  }


  return{
    addNewCompanyObjective,
    editCompanyObjective,
    addNewCompanyKeyResult,
    editCompanyKeyResult,
    addNewTeamObjective,
    editTeamObjective,
    addNewTeamKeyResult,
    editTeamKeyResult,
    addNewPersonalObjective,
    checkPersonalObjectiveInput,
    editPersonalObjective,
    addNewPersonalKeyResult,
    editPersonalKeyResult,
    createInputTextboxForEditPersonalObjective,
    createInputTextboxForEditPersonalKeyResult,
    createInputTextboxForEditTeamObjective,
    createInputTextboxForEditTeamKeyResult,
    createInputTextboxForEditCompanyKeyResult,
    createInputTextboxForEditCompanyObjective,
    searchUser,
    searchingUser
  }

})