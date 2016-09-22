// Date : 12 September 2016
// This JS file that controls company okr page only.

require([
'model/company_key_result', 'model/company_objective',
'view/controls/overlay', 'view/library/select2.min', 'view/controls/custom_modal',
'view/controls/input_textbox', 'view/controls/button', 'view/controls/custom_select2'], 
function(
companyKeyResultModel, companyObjectiveModel,
overlay, select2, customModal,
textboxControl, btnControl, customSelect2) {

    const button_create_company_objective = '#btn_new_company_objective';
    const button_edit_company_objective = '.edit_company_objective';
    const button_edit_company_key_result = '.edit_company_key_result';
    const textbox_new_company_objective = '#add-new-company-objective';
    const textbox_new_company_key_result = '.form-new-key-result';

    let original_company_objective = "";
    let original_company_key_result = "";

    // -----------------
    // Company Objective
    // -----------------

    function focusOutCreateNewCompanyObjective(event){
      if($('#new_company_objective').val() != '') {
        $('#new_objective_popup').attr('class','overlay');
        $('#company_objective_textarea').text($('#new_company_objective').val());
        btnControl.toggleButtonDisability(button_create_company_objective, 0)
      } 
    }

    function enterCreateNewCompanyObjective(event){
      let key = event.which;
      if(key == 13){
        if($('#new_company_objective').val() != '') {
          $('#new_objective_popup').attr('class','overlay');
          $('#company_objective_textarea').text($('#new_company_objective').val());
          btnControl.toggleButtonDisability(button_create_company_objective, 0)
        }
      }  
    }

    function createNewCompanyObjective(event){
      let company_objective = $('#company_objective_textarea').val();
      let create_company_objective_promise = new companyObjectiveModel.newCompanyObjective(company_objective);
      create_company_objective_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    }

    function editCompanyObjective(event){
      let objective_id = event.currentTarget.getAttribute('data-id');
      objective_id = parseInt(objective_id);
      let objective = $('#company_objective_' + objective_id).find('.details-layout').text();
      objective = objective.trim();  
      original_company_objective = objective;
      btnControl.hideButton(button_edit_company_objective); 
      textboxControl.createInputTextboxForEditCompanyObjective(objective_id, objective);
    }

    function editedCompanyObjective(event){
      let key = event.which;
      if(key == 13){
        let updated_objective = $(event.target).val();
        let original_objective = original_company_objective;
        let editing_objective_id = $(event.target).attr('data-id');
        editing_objective_id = parseInt(editing_objective_id);
        if(updated_objective != original_objective){
          let edit_company_objective_promise = new companyObjectiveModel.editCompanyObjective(
            editing_objective_id, updated_objective, original_objective
          );
          edit_company_objective_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    // ------------------
    // Company Key Result
    // ------------------

    function createNewCompanyKeyResult(event){
      let key = event.which;
      if(key == 13){
        if($(this).find(textbox_new_company_key_result).val() != '') {
          // Find out the personal objective id
          let current_focus_id = $(event.target).attr('data-id');
          let company_key_result = $(event.target).val();  
         
          let create_company_kr_promise = new companyKeyResultModel.newCompanyKeyResult(
              company_key_result, current_focus_id
          ); 
          create_company_kr_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
        }
      }
    }

    function editCompanyKeyResult(event){
      let key_result_id = event.currentTarget.getAttribute('data-id');
      let key_result = $('#company_kr_' + key_result_id).find('.details-layout').text();
      key_result = key_result.trim();
      key_result_id = parseInt(key_result_id);
      textboxControl.createInputTextboxForEditCompanyKeyResult(key_result_id, key_result);
      original_company_key_result = key_result;
      btnControl.hideButton(button_edit_company_key_result);
    }

    function editedCompanyKeyResult(event){
      let key = event.which;
      if(key == 13){
        let updated_key_result = $(event.target).val();
        let original_key_result = original_company_key_result;
        let editing_key_result_id = $(event.target).attr('data-id');   
        editing_key_result_id = parseInt(editing_key_result_id);
        if(updated_key_result !== original_key_result && updated_key_result !== ''){
          let edit_company_kr_promise = new companyKeyResultModel.editCompanyKeyResult(
            editing_key_result_id, updated_key_result, original_key_result
          );
          edit_company_kr_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    $(document).ready(function() {
        
        // Key Result - Create new 
        textboxControl.addNewCompanyKeyResult(createNewCompanyKeyResult);

        // Key Result - Edit
        btnControl.resolveButtonClick(button_edit_company_key_result, editCompanyKeyResult);
        textboxControl.editCompanyKeyResult(editedCompanyKeyResult);

        // Company Objective - Create new
        textboxControl.addNewCompanyObjective(focusOutCreateNewCompanyObjective, enterCreateNewCompanyObjective);
        btnControl.resolveButtonClick(button_create_company_objective, createNewCompanyObjective);
        
        // Company Objective - Edit
        btnControl.resolveButtonClick(button_edit_company_objective, editCompanyObjective);
        textboxControl.editCompanyObjective(editedCompanyObjective);

    })

})