// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['pages/pages.blank', 
'model/personal_key_result', 'model/personal_objective', 'model/timeframe',
'helper/date_converter',
'view/controls/custom_modal', 'view/controls/overlay', 'view/controls/slider', 'view/controls/custom_select2', 
'view/controls/button', 'view/controls/input_textbox', 'view/controls/checkbox', 'view/controls/page_refresh',
'view/d3_engine',
'view/library/bootstrap-datepicker'],
function(pagesBlank, 
personalKeyResultModel, personalObjectiveModel, timeframeModel, 
dateHelper,
customModal, overlay, slider, customSelect2, 
btnControl, textboxInput, checkboxControl, refreshPage, d3_engine, datepicker) {

    const button_new_personal_objective = '#btn_new_personal_objective';
    const button_edit_personal_objective = '.edit_personal_objective';
    const button_update_progress_key_result = '#btn_update_progress';
    const button_edit_personal_key_result = '.edit_personal_key_result';
    const button_save_personal_kr_due_date = '#btn_save_personal_kr_due_date';
    const textbox_new_personal_key_result = '.form-new-key-result';
    const link_add_due_date_personal_kr = '#link_add_due_date_personal_kr';
    const modal_personal_kr_due_date = '#personal_kr_due_date_modal';
    const datepicker_personal_kr = '#personal_kr_datepicker';
    const page_personal_key_result_details = '#page_personal_key_result_details';
    const graph_personal_key_result_progress_overtime = '#graph_personal_key_result_progress_overtime';

    // From layout page
    const button_timeframe_dropdown = "#btn_timeframe_dropdown";

    let original_personal_objective = "";
    let checkbox_tick_amount = 0;
    let original_personal_key_result = "";

    // ------------------
    // Personal Objective
    // ------------------

    function displayCreatePersonalObjectiveOverlay(event){
      let key = event.which;
      if($('#new_personal_objective').val() !== '') {
        if(key == 13){
          let temp_personal_objective = "";
          temp_personal_objective = $('#new_personal_objective').val();
          overlay.loadNewPersonalObjectiveOverlayContent();
          $('#personal_objective_textarea').text(temp_personal_objective);
        }
      }   
    }

    function createNewPersonalObjective(){
      let personal_objective = $('#personal_objective_textarea').val();
      let team_key_result_id = $('#team_key_result_selection').val();
      team_key_result_id = parseInt(team_key_result_id);
      let create_personal_objective = new personalObjectiveModel.newPersonalObjective(personal_objective, team_key_result_id);
      create_personal_objective.then(createdPersonalObjective, customModal.notificationModalToggle);
    }

    function createdPersonalObjective(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function editPersonalObjective(){
      let original_objective = "";
      let current_editing_objective_id = 0;
      let objective_id = $(this).attr('data-id');
      current_editing_objective_id = parseInt(objective_id);    
      let objective = $('#personal_objective_' + objective_id).find('.details-layout').text();
      objective = objective.trim();

      original_objective = objective;
      btnControl.hideButton(button_edit_personal_objective);

      textboxInput.createInputTextboxForEditPersonalObjective(current_editing_objective_id, original_objective);

      original_personal_objective = original_objective;
    }

    function editingPersonalObjective(event){
      let updated_objective = $(event.target).val();
      let current_editing_personal_objective_id = $(event.target).attr('data-id');
      let key = event.which;
      // When enter key is pressed
      if(key == 13){
        if(updated_objective !== original_personal_objective){
          let edit_objective_promise = new personalObjectiveModel.editPersonalObjective(
            current_editing_personal_objective_id, updated_objective, original_personal_objective
          );
          edit_objective_promise.then(editedPersonalObjective, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    function editedPersonalObjective(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    // -------------------
    // Personal Key Result
    // -------------------

    function createNewPersonalKeyResult(event){
      let key = event.which;
      if($(event.target).val() !== ''){
        if(key == 13){
          // Find out the personal objective id
          let current_focus_objective_id = $(event.target).attr('data-id');
          current_focus_objective_id = parseInt(current_focus_objective_id);
          let temp_personal_key_result = $(event.target).val();  
          if(temp_personal_key_result !== ''){
            let create_personal_kr_promise = new personalKeyResultModel.newPersonalKeyResult(
              temp_personal_key_result, current_focus_objective_id
            );   
            create_personal_kr_promise.then(createdPersonalKeyResult, customModal.notificationModalToggle);
          }
        }
      }
    }

    function createdPersonalKeyResult(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function updateProgressPersonalKeyResult(){
      let progress = $('#slider-tooltips').val();
      let initial_progress = $('#popup_initial_progress').text();
      let key_result_id = $('#key_result_id').text();
      let contribution = $('#contribution_textarea').val();
      key_result_id = parseInt(key_result_id);

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
      btnControl.hideButton(button_edit_personal_key_result);
    }

    function editingPersonalKeyResult(event){
      let key = event.which;
      if(key == 13){
        let updated_key_result = $(event.target).val();
        let original_key_result = original_personal_key_result;
        let editing_key_result_id = $(event.target).attr('data-id');
        if(updated_key_result != original_key_result && updated_key_result != ''){
          let edit_kr_promise = new personalKeyResultModel.editPersonalKeyResult(
              editing_key_result_id, updated_key_result, original_key_result
          );
          edit_kr_promise.then(editedPersonalKeyResult, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    function editedPersonalKeyResult(message){
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
      $(datepicker_personal_kr).datepicker({
        format: 'yyyy/mm/dd',
        startDate: today,
        endDate: end_date
      });
      $(modal_personal_kr_due_date).modal('show');
    }

    function savePersonalKeyResultDueDate(event){
      let personal_key_result_id = $(event.target).attr('data-id');
      personal_key_result_id = parseInt(personal_key_result_id);
      let selected_due_date = $(modal_personal_kr_due_date).find('.form-control').val();
      $(modal_personal_kr_due_date).modal('hide');
      if(selected_due_date == ''){
        customModal.notificationModalToggle("Due date cannot be empty!");
      } else {
        let update_due_date_promise = new personalKeyResultModel.updateDueDate(personal_key_result_id,selected_due_date);
        update_due_date_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
      }  
    }

    function getContribution(){
      $(page_personal_key_result_details).ready(function(event){
        let key_result_id = $(page_personal_key_result_details).attr('data-id');
        if(key_result_id != undefined) {
          let get_contribution_promise = new personalKeyResultModel.getContribution(key_result_id);
          get_contribution_promise.then(processContributionKeyResult, customModal.notificationModalToggle);
        }
      });
    }

    function getCreatedDate(){
      $(page_personal_key_result_details).ready(function(event){
        let key_result_id = $(page_personal_key_result_details).attr('data-id');
        if(key_result_id != undefined) {
          let get_created_date_promise = new personalKeyResultModel.getCreatedDate(key_result_id);
          get_created_date_promise.then(obtainCreatedDate, customModal.notificationModalToggle);
        }
      });
    }

    let created_date = "";
    function obtainCreatedDate(data){
      created_date = data;
      let created_at_time_index = created_date.indexOf('T');
      let created_at_underscore_index = created_date.indexOf('-');

      created_date = created_date.substring(1, created_at_time_index);
      created_date = created_date.substring(created_at_underscore_index + 1, created_date.length);
      created_date = dateHelper.formatConverter(created_date);

      getContribution();
    }

    function processContributionKeyResult(data){
      data = JSON.parse(data);
      let counter = 0;
      let x_axis = [];
      let y_axis = [];

      x_axis.push(created_date);
      y_axis.push(0);

      let previous_progress = 0.00;
      let current_progress = 0.00;

      while(counter < data.length) {
        let created_at_time_index = data[counter].created_at.indexOf('T');
        let created_at_underscore_index = data[counter].created_at.indexOf('-');
        let log_content_plus_index = data[counter].log_content.indexOf('+');
        let log_content_percentage_index = data[counter].log_content.indexOf('%');
        data[counter].created_at = data[counter].created_at.substring(0, created_at_time_index);
        data[counter].created_at = data[counter].created_at.substring(created_at_underscore_index + 1, (data[counter].created_at).length);
        data[counter].log_content = data[counter].log_content.substring(log_content_plus_index + 1, log_content_percentage_index);
        data[counter].log_content = parseFloat(data[counter].log_content);
        
        if(counter == 0) {
          previous_progress = data[counter].log_content;
        } else {
          data[counter].log_content = previous_progress + data[counter].log_content;
          previous_progress = data[counter].log_content;
        }

        data[counter].created_at = dateHelper.formatConverter(data[counter].created_at);

        x_axis.push(data[counter].created_at);
        y_axis.push(data[counter].log_content);
        
        counter = counter + 1;
      }

      d3_engine.generateSimpleLineGraph(graph_personal_key_result_progress_overtime, x_axis, y_axis);
    }

    customModal.toggleProgressRingModal(0);

    $(document).ready(function(){

        // Load Contribution overlay for update personal key result progress
        overlay.loadOverlay();   
        overlay.clickProgressUpdateOverlay();

        //Personal Objective - Create new
        textboxInput.addNewPersonalObjective(displayCreatePersonalObjectiveOverlay);
        customSelect2.teamKeyResultSelectionChanged();  
        btnControl.resolveButtonClick(button_new_personal_objective, createNewPersonalObjective);   
       
        // Personal Objective - Edit     
        btnControl.resolveButtonClick(button_edit_personal_objective, editPersonalObjective);
        textboxInput.editPersonalObjective(editingPersonalObjective);

        // Key result - Create new  
        textboxInput.addNewPersonalKeyResult(createNewPersonalKeyResult);     
        
        // Key result - Update progress
        btnControl.resolveButtonClick(button_update_progress_key_result, updateProgressPersonalKeyResult);

        // Key result - Checked completed key result
        checkbox_tick_amount = $('input[type=checkbox]:checked').length;
        checkboxControl.checkUncheckPersonalKeyResult(checkedUncheckedPersonalKeyResult);
        
        // Key Result - Edit 
        btnControl.resolveButtonClick(button_edit_personal_key_result, editPersonalKeyResult);
        textboxInput.editPersonalKeyResult(editingPersonalKeyResult);

        // Key Result - Add due date
        btnControl.resolveButtonClick(link_add_due_date_personal_kr, getCurrentQuarterEndDate);
        btnControl.resolveButtonClick(button_save_personal_kr_due_date, savePersonalKeyResultDueDate);

        btnControl.notificationDismissClick();

        getCreatedDate();
        
    });

    customModal.toggleProgressRingModal(1);
        
}); 

