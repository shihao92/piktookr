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

  function checkPersonalObjectiveInput(){
    $('#personal_objective_textarea')
    .on({
      keypress: function(){
        btnControl.toggleDisabledSaveNewPersonalObjectiveButton(0);
      }
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
      focusout: function(){
        location.reload();
      },
      keypress: resolve      
    });
  }

  function editPersonalKeyResult(resolve){
    $('.checkbox-primary')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    },'.add-new-personal-key-result');
  }

  function createInputTextboxForEditPersonalObjective(objective_id, original_objective){
    $('#personal_objective_' + objective_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);
  }

  function createInputTextboxForEditPersonalKeyResult(key_result_id, original_key_result){
    $('#personal_kr_' + key_result_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result" data-id="' + key_result_id + '" />')
    .find('.form-new-key-result').val(original_key_result);
  }

  function createInputTextboxForEditTeamObjective(objective_id, original_objective){
    $('#team_objective_' + objective_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-team-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);
  }

  function createInputTextboxForEditTeamKeyResult(key_result_id, original_key_result){
    $('#team_kr_' + key_result_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-team-key-result" data-id="' + key_result_id + '"/>')
    .find('.form-new-key-result')
    .val(original_key_result);
  }

  function createInputTextboxForEditCompanyKeyResult(key_result_id, original_key_result){
    $('#company_kr_' + key_result_id)
    .empty()
    .html('<input name="edit_company_key_result" type="text" class="form-control form-new-key-result add-new-company-key-result" data-id="' + key_result_id + '"/>')
    .find('.form-new-key-result')
    .val(original_key_result);
  }

  function createInputTextboxForEditCompanyObjective(objective_id, original_objective){
    $('#company_objective_' + objective_id)
    .empty()
    .html('<input name="edit_company_objective" type="text" class="form-control form-new-key-result add-new-company-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);
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
      keypress: resolve,
      focusout: function(){
        location.reload();
      }
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
        focusout: function() {
            location.reload();
        },
        keypress: resolve
    });
  }

  function editCompanyKeyResult(resolve){
    $(".checkbox-primary")
    .on({
        focusout: function() {
            location.reload();
        },
        keypress: resolve
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
      keypress: resolve
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