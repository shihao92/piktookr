// Date : 12 September 2016
// This JS file that controls company okr page only.

require([
'model/company_key_result', 'model/company_objective', 'model/timeframe',
'helper/d3_data_input_process',
'view/library/bootstrap-datepicker',
'view/controls/overlay', 'view/library/select2.min', 'view/controls/custom_modal',
'view/controls/input_textbox', 'view/controls/button', 'view/controls/custom_select2', 'view/controls/page_refresh'], 
function(
companyKeyResultModel, companyObjectiveModel, timeframeModel,
d3DataHelper,
datepicker,
overlay, select2, customModal,
textboxControl, btnControl, customSelect2, refreshPage) {

    const button_create_company_objective = '#btn_new_company_objective';
    const button_edit_company_objective = '.edit_company_objective';
    const button_edit_company_key_result = '.edit_company_key_result';
    const button_save_company_kr_due_date = '#btn_save_company_kr_due_date';
    const textbox_new_company_objective = '#add-new-company-objective';
    const textbox_new_company_key_result = '.form-new-key-result';
    const link_add_due_date_company_kr = '#link_add_due_date_company_kr';
    const modal_company_kr_due_date = '#company_kr_due_date_modal';
    const datepicker_company_kr = '#company_kr_datepicker';
    const page_company_objective_details = '#page_company_objective_details';
    const page_company_key_result_details = '#page_company_key_result_details';

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
      create_company_objective_promise.then(createdCompanyObjective, customModal.notificationModalToggle);
    }

    function createdCompanyObjective(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
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

    function editingCompanyObjective(event){
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
          edit_company_objective_promise.then(editedCompanyObjective, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    function editedCompanyObjective(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function getObjectiveCreatedDate(){
      $(page_company_objective_details).ready(function(event){
        let objective_id = $(page_company_objective_details).attr('data-id');
        alert(objective_id);
        if(objective_id != undefined) {
          let get_created_date_promise = new companyObjectiveModel.getCreatedDate(objective_id);
          get_created_date_promise.then(obtainObjectiveCreatedDate, customModal.notificationModalToggle);
        }
      });
    }

    function getObjectiveContribution(){
      $(page_company_objective_details).ready(function(event){
        let objective_id = $(page_company_objective_details).attr('data-id');
        if(objective_id != undefined) {
          let get_contribution_promise = new companyObjectiveModel.getContribution(objective_id);
          get_contribution_promise.then(obtainObjectiveContribution, customModal.notificationModalToggle);
        }
      });
    }

    function obtainObjectiveContribution(data){
      d3DataHelper.processData(created_date, data);
    }

    function obtainObjectiveCreatedDate(data){
      created_date = d3DataHelper.processCreatedDate(data);
      getObjectiveContribution();
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
          create_company_kr_promise.then(createdCompanyKeyResult, customModal.notificationModalToggle);
        }
      }
    }

    function createdCompanyKeyResult(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
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

    function editingCompanyKeyResult(event){
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
          edit_company_kr_promise.then(editedCompanyKeyResult, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    function editedCompanyKeyResult(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function getCurrentQuarterEndDate(){
      let get_current_quarter_end_date = new timeframeModel.getCurrentQuarterEndDate();
      get_current_quarter_end_date.then(initializeDatepicker, customModal.notificationModalToggle);
    }

    function initializeDatepicker(end_date){
      let nowDate = new Date();
      let today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
      $(datepicker_company_kr).datepicker({
        format: 'yyyy/mm/dd',
        startDate: today,
        endDate: end_date
      });
      $(modal_company_kr_due_date).modal('show');
    } 

    function saveCompanyKeyResultDueDate(event){
      let company_key_result_id = $(event.target).attr('data-id');
      let selected_due_date = $(modal_company_kr_due_date).find('.form-control').val();
      $(modal_company_kr_due_date).modal('hide');
      if(selected_due_date == ''){
        customModal.notificationModalToggle("Due date cannot be empty!");
      } else {
        let update_due_date_promise = new companyKeyResultModel.updateDueDate(company_key_result_id, selected_due_date);
        update_due_date_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
      }  
    }

    function getKeyResultCreationDate(){
      $(page_company_key_result_details).ready(function(){
        let key_result_id = $(page_company_key_result_details).attr('data-id');
        if(key_result_id !== undefined) {
          let get_created_date_promise = new companyKeyResultModel.getCreatedDate(key_result_id);
          get_created_date_promise.then(obtainKeyResultCreationDate, customModal.notificationModalToggle);
        }
      });
    }

    function getKeyResultContribution(){
      $(page_company_key_result_details).ready(function(){
        let key_result_id = $(page_company_key_result_details).attr('data-id');
        if(key_result_id !== undefined) {
          let get_contribution_promise = new companyKeyResultModel.getContribution(key_result_id);
          get_contribution_promise.then(obtainKeyResultContribution, customModal.notificationModalToggle);
        }
      });
    }

    function obtainKeyResultCreationDate(data){
      created_date = d3DataHelper.processCreatedDate(data);
      getKeyResultContribution();
    }

    function obtainKeyResultContribution(data){
      d3DataHelper.processData(created_date, data);
    } 

    $(document).ready(function() {
        
        // Key Result - Create new 
        textboxControl.addNewCompanyKeyResult(createNewCompanyKeyResult);

        // Key Result - Edit
        btnControl.resolveButtonClick(button_edit_company_key_result, editCompanyKeyResult);
        textboxControl.editCompanyKeyResult(editingCompanyKeyResult);

        // Key Result - Update due date
        btnControl.resolveButtonClick(link_add_due_date_company_kr, getCurrentQuarterEndDate);
        btnControl.resolveButtonClick(button_save_company_kr_due_date, saveCompanyKeyResultDueDate);

        // Company Objective - Create new
        textboxControl.addNewCompanyObjective(focusOutCreateNewCompanyObjective, enterCreateNewCompanyObjective);
        btnControl.resolveButtonClick(button_create_company_objective, createNewCompanyObjective);
        
        // Company Objective - Edit
        btnControl.resolveButtonClick(button_edit_company_objective, editCompanyObjective);
        textboxControl.editCompanyObjective(editingCompanyObjective);

        getObjectiveCreatedDate();
        getKeyResultCreationDate();

    })

})