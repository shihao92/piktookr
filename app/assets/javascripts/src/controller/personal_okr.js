// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['pages/pages.blank', 
'model/personal_key_result', 'model/personal_objective', 
'view/controls/custom_modal', 'view/controls/overlay', 'view/controls/slider', 'view/controls/custom_select2', 
'view/controls/button', 'view/controls/input_textbox', 'view/controls/checkbox'],
function(pagesBlank, 
personalKeyResultModel, personalObjectiveModel, 
customModal, overlay, slider, customSelect2, 
btnControl, textboxInput, checkboxControl) {

    let original_personal_objective = "";
    let checkbox_tick_amount = 0;
    let original_personal_key_result = "";

    // ------------------
    // Personal Objective
    // ------------------

    function createNewPersonalObjective(){
      let personal_objective = $('#personal_objective_textarea').val();
      let team_key_result_id = $('#team_key_result_selection').val();
      let create_personal_objective = new personalObjectiveModel.newPersonalObjective(personal_objective, team_key_result_id);
      create_personal_objective.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    }

    function editPersonalObjective(){
      let original_objective = "";
      let current_editing_objective_id = 0;
      let objective_id = $(this).attr('data-id');
      current_editing_objective_id = parseInt(objective_id);    
      let objective = $('#personal_objective_' + objective_id).find('.details-layout').text();
      objective = objective.trim();

      original_objective = objective;
      btnControl.hideEditPersonalObjectiveButton();

      textboxInput.createInputTextboxForEditPersonalObjective(current_editing_objective_id, original_objective);

      original_personal_objective = original_objective;
    }

    function editedPersonalObjective(event){
      let updated_objective = $(event.target).val();
      let current_editing_personal_objective_id = $(event.target).attr('data-id');
      let key = event.which;
      // When enter key is pressed
      if(key == 13){
        if(updated_objective !== original_personal_objective){
          let edit_objective_promise = new personalObjectiveModel.editPersonalObjective(
            current_editing_personal_objective_id, updated_objective, original_personal_objective
          );
          edit_objective_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    // -------------------
    // Personal Key Result
    // -------------------

    function createNewPersonalKeyResult(event){
      let key = event.which;
      if(key == 13){
        // Find out the personal objective id
        let current_focus_objective_id = $(event.target).attr('data-id');
        let temp_personal_key_result = $(event.target).val();  
        if(temp_personal_key_result !== ''){
          let create_personal_kr_promise = new personalKeyResultModel.newPersonalKeyResult(
            temp_personal_key_result, current_focus_objective_id
          );   
          create_personal_kr_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
        }
      }
    }

    function updateProgressPersonalKeyResult(){
      let progress = $('#slider-tooltips').val();
      let initial_progress = $('#popup_initial_progress').text();
      let key_result_id = $('#key_result_id').text();
      let contribution = $('#contribution_textarea').val();

      // AJAX call to update the personal key result progress
      let update_kr_progress_promise = new personalKeyResultModel.updatePersonalKeyResultProgress(
          key_result_id, progress, initial_progress, contribution
      );  
      update_kr_progress_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    }

    function checkedUncheckedPersonalKeyResult(){
      // 1 - checked 
      // 0 - not check
      let checked_value = $('input[type=checkbox]:checked').length;
      let key_result_id = $(this).attr('id');
      let underscore_index = key_result_id.indexOf('_');
      key_result_id = key_result_id.substring(underscore_index + 1, key_result_id.length);
      if(checked_value < checkbox_tick_amount)
      {
        let update_kr_status_promise = new personalKeyResultModel.updatePersonalKeyResultStatus(key_result_id, false);
        update_kr_status_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
      }
      else
      {
        let update_kr_status_promise = new personalKeyResultModel.updatePersonalKeyResultStatus(key_result_id, true);
        update_kr_status_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
      }
    }

    function editPersonalKeyResult(event){
      let key_result_id = $(this).attr('data-id');
      let key_result = $('#personal_kr_' + key_result_id).find('.details-layout').text();
      key_result = key_result.trim();

      textboxInput.createInputTextboxForEditPersonalKeyResult(key_result_id, key_result);

      original_personal_key_result = key_result;
      btnControl.hideEditPersonalKeyResultButton();
    }

    function editedPersonalKeyResult(event){
      let key = event.which;
      if(key == 13){
        let updated_key_result = $(event.target).val();
        let original_key_result = original_personal_key_result;
        let editing_key_result_id = $(event.target).attr('data-id');
        if(updated_key_result != original_key_result && updated_key_result != ''){
          let edit_kr_promise = new personalKeyResultModel.editPersonalKeyResult(
              editing_key_result_id, updated_key_result, original_key_result
          );
          edit_kr_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    customModal.toggleProgressRingModal(0);

    $(document).ready(function(){

        // Load Contribution overlay for update personal key result progress
        overlay.loadOverlay();   
        overlay.clickProgressUpdateOverlay();

        //Personal Objective - Create new
        textboxInput.addNewPersonalObjective();
        customSelect2.teamKeyResultSelectionChanged();  
        btnControl.newPersonalObjectiveButtonClick(createNewPersonalObjective);   
              
        // Personal Objective - Edit     
        btnControl.editPersonalObjectiveButtonClick(editPersonalObjective);
        textboxInput.editPersonalObjective(editedPersonalObjective);

        // Key result - Create new  
        textboxInput.addNewPersonalKeyResult(createNewPersonalKeyResult);     
        
        // Key result - Update progress
        btnControl.updatePersonalKeyResultProgressClick(updateProgressPersonalKeyResult);

        // Key result - Checked completed key result
        checkbox_tick_amount = $('input[type=checkbox]:checked').length;
        checkboxControl.checkUncheckPersonalKeyResult(checkedUncheckedPersonalKeyResult);
        
        // Key Result - Edit 
        btnControl.editPersonalKeyResultButtonClick(editPersonalKeyResult);
        textboxInput.editPersonalKeyResult(editedPersonalKeyResult);

        btnControl.notificationDismissClick();
        
    });

    customModal.toggleProgressRingModal(1);
        
}); 

