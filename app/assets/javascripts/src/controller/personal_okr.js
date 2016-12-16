// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['pages/pages.blank', 
'model/personal_key_result', 'model/personal_objective', 'model/timeframe',
'helper/d3_data_input_process',
'view/controls/custom_modal', 'view/controls/overlay', 'view/controls/slider', 'view/controls/custom_select2', 
'view/controls/button', 'view/controls/input_textbox', 'view/controls/checkbox', 'view/controls/page_refresh',
'view/d3_engine', 'view/search_result',
'view/library/bootstrap-datepicker'],
function(pagesBlank, 
personalKeyResultModel, personalObjectiveModel, timeframeModel, 
d3DataHelper,
customModal, overlay, slider, customSelect2, 
btnControl, textboxInput, checkboxControl, refreshPage, d3_engine, searchResult, datepicker) {

    const button_new_personal_objective = '#btn_new_personal_objective';
    const button_close_creation_personal_objective = '#btn_close_creation_personal_objective';
    const button_edit_personal_objective = '.edit_personal_objective';
    const button_update_progress_key_result = '#btn_update_progress';
    const button_edit_personal_key_result = '.edit_personal_key_result';
    const button_save_personal_kr_due_date = '#btn_save_personal_kr_due_date';
    const link_add_due_date_personal_kr = '#link_add_due_date_personal_kr';
    const modal_personal_kr_due_date = '#personal_kr_due_date_modal';
    const modal_checked_personal_kr_confirmation = '#modal_checked_personal_kr_confirmation';
    const datepicker_personal_kr = '#personal_kr_datepicker';
    const page_personal_key_result_details = '#page_personal_key_result_details';
    const page_personal_objective_details = '#page_personal_objective_details';
    const radio_selection_kr_type = 'input[name=option_kr]:checked';
    const radio_company_kr = '#radio_company_kr';
    const radio_team_kr = '#radio_team_kr';
    const selection_team_kr = '#selection_team_kr';
    const selection_company_kr = '#selection_company_kr';
    const selection_team_key_result = '#team_key_result_selection';
    const selection_company_key_result = '#company_key_result_selection';
    const textarea_personal_objective = '#personal_objective_textarea';
    const new_personal_objective = '#new_personal_objective';
    const new_objective_popup = '#new_objective_popup';
    const button_close_contribution_overlay = '#btn_close_contribution_overlay';

    const link_contribution_overlay = 'a[name=link_contribution_overlay]';
    const contribution_overlay = '#contribution_overlay';
    const personal_key_result_contribution = '#personal_key_result_contribution';
    const contribution_sliders = '#contribution_sliders';
    const contribution_textarea = '#contribution_textarea';
    const aligned_company_objective = '#aligned_company_objective';

    const button_confirm_checked_kr = '#btn_confirm_checked_kr';
    const button_remove_checked_kr = '#btn_remove_checked_kr';

    // Search Module
    const input_overlay_search_user = '#overlay_search_user_input';
    const div_search_personal_objectives_results = '#div_search_personal_objectives_results';
    const div_search_personal_kr_results = '#div_search_personal_kr_results';

    // From Layout
    const lists_timeframe_logs = '#lists_timeframe_logs';

    let original_personal_objective = "";
    let checkbox_tick_amount = 0;
    let original_personal_key_result = "";
    let created_date = "";

    // ------------------
    // Personal Objective
    // ------------------

    function displayCreatePersonalObjectiveOverlay(event){
      let key = event.which;
      if($(new_personal_objective).val() !== '') {
        if(key == 13){
          let temp_personal_objective = $(new_personal_objective).val();
          overlay.loadNewPersonalObjectiveOverlayContent();
          $(textarea_personal_objective).text(temp_personal_objective);
          btnControl.toggleDisabledSaveNewPersonalObjectiveButton(0);
          textboxInput.checkPersonalObjectiveInput(checkPersonalObjectiveTextarea);
          $(selection_team_kr).css("display", "block");
          $(selection_company_kr).css("display", "none");
        }
      }   
    }

    function closePersonalObjectiveOverlay(event){
      overlay.toggleOverlay(new_objective_popup, 0);
    }

    function checkPersonalObjectiveTextarea(event){
      let personal_objective = $(event.target).val();
      if(personal_objective.length < 2){
        btnControl.toggleDisabledSaveNewPersonalObjectiveButton(1);
      } else {
        btnControl.toggleDisabledSaveNewPersonalObjectiveButton(0);
      }
    }

    function createNewPersonalObjective(){
      let personal_objective = $(textarea_personal_objective).val();
      let selected_radio_value = $(radio_selection_kr_type).val();
      if(personal_objective != ''){
        if(selected_radio_value === "team_kr"){
          let team_key_result_id = $(selection_team_key_result).val();
          team_key_result_id = parseInt(team_key_result_id);
          if($(selection_team_key_result).val() != null){
            let create_personal_objective = new personalObjectiveModel.newPersonalObjective(personal_objective, team_key_result_id);
            create_personal_objective.then(createdPersonalObjective, customModal.notificationModalToggle);
          } else {
            customModal.notificationModalToggle("Must aligned to Team Key Result!");
          }
        } else {
          let company_key_result_id = $(selection_company_key_result).val();
          company_key_result_id = parseInt(company_key_result_id);
          if($(selection_company_key_result).val() != null){
            let create_personal_objective_link_company = new personalObjectiveModel.newPersonalObjectiveLinkedCompany(personal_objective, company_key_result_id);
            create_personal_objective_link_company.then(createdPersonalObjective, customModal.notificationModalToggle);
          }
          else {
            customModal.notificationModalToggle("Must aligned to Company Key Result!");
          }
        }
      } else {
        customModal.notificationModalToggle("Personal objective cannot be empty!");
      }
    }

    function createdPersonalObjective(message){
      if(message == "Personal Objective must be more than 5 characters!"){
        customModal.notificationModalToggle(message);
      } else {
        customModal.toggleProgressRingModal(0);
        refreshPage.refreshPage();
      }
    }

    function editPersonalObjective(){
      let original_objective = "";
      let current_editing_objective_id = 0;
      let objective_id = $(this).attr('data-id');
      current_editing_objective_id = parseInt(objective_id);    
      let objective = $('#personal_objective_' + objective_id).find('.accordion-obj-title').text();
      objective = objective.trim();

      original_objective = objective;
      btnControl.hideButton(button_edit_personal_objective);

      textboxInput.createInputTextboxForEditPersonalObjective(current_editing_objective_id, original_objective);

      original_personal_objective = original_objective;
    }

    let current_editing_personal_objective_id = 0;
    function editingPersonalObjective(event){
      let updated_objective = $(event.target).val();
      current_editing_personal_objective_id = $(event.target).attr('data-id');
      let key = event.which;
      // When enter key is pressed
      if(key == 13){
        if(updated_objective !== original_personal_objective && updated_objective.length > 5){
          let edit_objective_promise = new personalObjectiveModel.editPersonalObjective(
            current_editing_personal_objective_id, updated_objective, original_personal_objective
          );
          edit_objective_promise.then(editedPersonalObjective, customModal.notificationModalToggle);
        }
        else if(updated_objective === original_personal_objective) {
          refreshPage.refreshPage();
        }
        else {
          customModal.notificationModalToggle('Personal Objective must have more than 5 characters!');
        }
      }
    }

    function editedPersonalObjective(message){
      $('#obj_loading_' + current_editing_personal_objective_id).css('display', 'block');
      refreshPage.refreshPage();
    }

    function getObjectiveCreatedDate(){
      $(page_personal_objective_details).ready(function(event){
        let objective_id = $(page_personal_objective_details).attr('data-id');
        if(objective_id != undefined) {
          let get_created_date_promise = new personalObjectiveModel.getCreatedDate(objective_id);
          get_created_date_promise.then(obtainObjectiveCreatedDate, customModal.notificationModalToggle);
        }
      });
    }

    function getObjectiveContribution(){
      $(page_personal_objective_details).ready(function(event){
        let objective_id = $(page_personal_objective_details).attr('data-id');
        if(objective_id != undefined) {
          let get_contribution_promise = new personalObjectiveModel.getContribution(objective_id);
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

    function radioButtonTeamKRSelectionChanged(event){
      $(selection_team_kr).css("display", "block");
      $(selection_company_kr).css("display", "none");
    }

    function radioButtonCompanyKRSelectionChanged(event){
      $(selection_team_kr).css("display", "none");
      $(selection_company_kr).css("display", "block");
    }

    function searchPersonalObjective(event){
      let key = event.which;
      if(key === 13){
        let search_keyword = $(input_overlay_search_user).val();
        let search_objective_promise = new personalObjectiveModel.searchObjective(search_keyword);
        search_objective_promise.then(obtainSearchObjectiveResults, customModal.notificationModalToggle);
      }
    }

    function obtainSearchObjectiveResults(results){
      customModal.toggleProgressRingModal(0);
      searchResult.generateSearchPersonalObjectiveResults(results, div_search_personal_objectives_results);
      customModal.toggleProgressRingModal(1);
    }

    // -------------------
    // Personal Key Result
    // -------------------

    let current_focus_objective_id = 0;
    function createNewPersonalKeyResult(event){
      let key = event.which;
      if($(event.target).val() !== ''){
        if(key == 13){
          // Find out the personal objective id
          current_focus_objective_id = $(event.target).attr('data-id');
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
      $('#plus_icon_' + current_focus_objective_id).css('display', 'none');
      $('#kr_creation_loading_' + current_focus_objective_id).css('display', 'inline-block');
      refreshPage.refreshPage();
    }

    function openContributionOverlay(event){
      let control_parent = $(event.target).parents('.accordion-item');
      let personal_key_result = $(control_parent).find('.key-result').text();
      let current_progress = $(control_parent).find('.key-result-progress').find('span').attr('data-progress');
      let due_date = $(control_parent).find('span[name=personal_kr_due_date]').attr('data-end-date');
      let key_result_id = $(event.target).attr('data-id');
      $('#popup_initial_progress').text(current_progress);
      $('#personal_key_result_due_date').text(due_date);
      $(personal_key_result_contribution).attr('data-id', key_result_id);
      $(personal_key_result_contribution).text(personal_key_result);
      slider.contributionSliderControl(current_progress);

      let linked_company_objective_promise = new personalKeyResultModel.getLinkedCompanyObjective(key_result_id);
      linked_company_objective_promise.then(getLinkedCompanyObjective, customModal.notificationModalToggle);

      overlay.toggleOverlay(contribution_overlay, 1);
    }

    function getLinkedCompanyObjective(data){
      $(aligned_company_objective).text(data);
    }

    function closeContributionOverlay(event){
      let parent_target = $(contribution_sliders).parents(".no-padding");
      $(contribution_sliders)[0].destroy();
      slider.recreateSlider(parent_target);
      overlay.toggleOverlay(contribution_overlay, 0);
    }

    function updateProgressPersonalKeyResult(){
      let progress = $(contribution_sliders).val();
      let initial_progress = $('#popup_initial_progress').text();
      let key_result_id = $(personal_key_result_contribution).attr('data-id');
      let contribution = $(contribution_textarea).val();
      key_result_id = parseInt(key_result_id);

      // AJAX call to update the personal key result progress
      if(contribution != ''){
        if(progress < parseInt(initial_progress)){
          customModal.notificationModalToggle("Progress increment cannot be negative!");
        } else {
          let update_kr_progress_promise = new personalKeyResultModel.updatePersonalKeyResultProgress(
            key_result_id, progress, initial_progress, contribution
          );  
          update_kr_progress_promise.then(updatedProgress, customModal.notificationModalToggle);
          btnControl.notificationDismissClick(1);
        }
      } else {
        customModal.notificationModalToggle("Contribution cannot be empty!");
      }
    } 

    function updatedProgress(message){
      customModal.notificationModalToggle(message);
      refreshPage.refreshPage();
    }

    function checkedUncheckedPersonalKeyResult(event){
      // 1 - checked 
      // 0 - not check
      let checked_value = $('input[type=checkbox]:checked').length;
      let key_result_id = $(event.target).attr('data-id');
      if(checked_value > checkbox_tick_amount)
      {
        $(button_confirm_checked_kr).attr('data-id', key_result_id);
        $(button_remove_checked_kr).attr('data-id', key_result_id);
        $(modal_checked_personal_kr_confirmation).modal('show');
      }
    }

    function confirmedCompletedKeyResult(event){
      $(modal_checked_personal_kr_confirmation).modal('hide');
      let key_result_id = $(event.target).attr("data-id");
      let update_kr_status_promise = new personalKeyResultModel.updatePersonalKeyResultStatus(key_result_id, true);
      update_kr_status_promise.then(doneConfirmedCompletedKeyResult, customModal.notificationModalToggle);
    }

    function doneConfirmedCompletedKeyResult(message){
      customModal.notificationModalToggle(message);
      refreshPage.refreshPage();
    }

    function removeCompletedKeyResult(event){
      let key_result_id = $(event.target).attr("data-id");
      $('#personalkrcompleted_' + key_result_id).removeProp('checked');
    }

    function editPersonalKeyResult(event){
      let key_result_id = $(this).attr('data-id');
      let key_result = $('#personal_kr_' + key_result_id).find('.key-result').text();
      key_result = key_result.trim();

      textboxInput.createInputTextboxForEditPersonalKeyResult(key_result_id, key_result);

      original_personal_key_result = key_result;
      btnControl.hideButton(button_edit_personal_key_result);
    }

    let editing_key_result_id = 0;
    function editingPersonalKeyResult(event){
      let key = event.which;
      if(key == 13){
        let updated_key_result = $(event.target).val();
        let original_key_result = original_personal_key_result;
        editing_key_result_id = $(event.target).attr('data-id');
        if(updated_key_result !== original_key_result && updated_key_result.length > 5){
          let edit_kr_promise = new personalKeyResultModel.editPersonalKeyResult(
            editing_key_result_id, updated_key_result, original_key_result
          );
          edit_kr_promise.then(editedPersonalKeyResult, customModal.notificationModalToggle);
        }
        else if(updated_key_result === original_key_result){
          refreshPage.refreshPage();
        }
        else {
          customModal.notificationModalToggle('Personal Key Result must have more than 5 characters!');
        }
      }
    }

    function editedPersonalKeyResult(message){
      $('#kr_loading_' + editing_key_result_id).css('display', 'block');
      refreshPage.refreshPage();
    }

    function getCurrentQuarterEndDate(){
      let system_timeframe_log_id = $(lists_timeframe_logs).attr('data-id');
      let get_current_quarter_end_date = new timeframeModel.getCurrentQuarterEndDate(system_timeframe_log_id);
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
        update_due_date_promise.then(successUpdateDueDate, customModal.notificationModalToggle);
      }  
    }

    function successUpdateDueDate(message){
      refreshPage.refreshPage();
    }

    function getKeyResultContribution(){
      $(page_personal_key_result_details).ready(function(event){
        let key_result_id = $(page_personal_key_result_details).attr('data-id');
        if(key_result_id != undefined) {
          let get_contribution_promise = new personalKeyResultModel.getContribution(key_result_id);
          get_contribution_promise.then(obtainedKeyResultContribution, customModal.notificationModalToggle);
        }
      });
    }

    function obtainedKeyResultContribution(data){
      d3DataHelper.processData(created_date, data);
    }

    function getKeyResultCreatedDate(){
      $(page_personal_key_result_details).ready(function(event){
        let key_result_id = $(page_personal_key_result_details).attr('data-id');
        if(key_result_id != undefined) {
          let get_created_date_promise = new personalKeyResultModel.getCreatedDate(key_result_id);
          get_created_date_promise.then(obtainKeyResultCreatedDate, customModal.notificationModalToggle);
        }
      });
    }

    function obtainKeyResultCreatedDate(data){
      created_date = d3DataHelper.processCreatedDate(data);
      getKeyResultContribution();
    }

    function searchPersonalKeyResult(event){
      let key = event.which;
      if(key === 13){
        let search_keyword = $(input_overlay_search_user).val();
        let search_kr_promise = new personalKeyResultModel.searchKeyResult(search_keyword);
        search_kr_promise.then(obtainSearchKRResults, customModal.notificationModalToggle);
      }
    }

    function obtainSearchKRResults(results){
      customModal.toggleProgressRingModal(0);
      searchResult.generateSearchPersonalKRResults(results, div_search_personal_kr_results);
      customModal.toggleProgressRingModal(1);
    }

    customModal.toggleProgressRingModal(0);

    $(document).ready(function(){

        // Load Contribution overlay for update personal key result progress
        overlay.loadOverlay();   
        overlay.clickProgressUpdateOverlay();

        //Personal Objective - Create new
        btnControl.resolveButtonClick(radio_company_kr, radioButtonCompanyKRSelectionChanged);
        btnControl.resolveButtonClick(radio_team_kr, radioButtonTeamKRSelectionChanged);

        textboxInput.addNewPersonalObjective(displayCreatePersonalObjectiveOverlay);
        customSelect2.teamKeyResultSelectionChanged();  
        btnControl.resolveButtonClick(button_new_personal_objective, createNewPersonalObjective);
        btnControl.resolveButtonClick(button_close_creation_personal_objective, closePersonalObjectiveOverlay);   
       
        // Personal Objective - Edit     
        btnControl.resolveButtonClick(button_edit_personal_objective, editPersonalObjective);
        textboxInput.editPersonalObjective(editingPersonalObjective);

        // Key result - Create new  
        textboxInput.addNewPersonalKeyResult(createNewPersonalKeyResult);     
        
        // Key result - Update progress
        btnControl.resolveButtonClick(link_contribution_overlay, openContributionOverlay);
        btnControl.resolveButtonClick(button_close_contribution_overlay, closeContributionOverlay);
        btnControl.resolveButtonClick(button_update_progress_key_result, updateProgressPersonalKeyResult);

        // Key result - Checked completed key result
        checkbox_tick_amount = $('input[type=checkbox]:checked').length;
        checkboxControl.checkUncheckPersonalKeyResult(checkedUncheckedPersonalKeyResult);
        btnControl.resolveButtonClick(button_confirm_checked_kr, confirmedCompletedKeyResult);
        btnControl.resolveButtonClick(button_remove_checked_kr, removeCompletedKeyResult);
        customModal.detectCheckedConfirmationModalClose();
        
        // Key Result - Edit 
        btnControl.resolveButtonClick(button_edit_personal_key_result, editPersonalKeyResult);
        textboxInput.editPersonalKeyResult(editingPersonalKeyResult);

        // Key Result - Add due date
        btnControl.resolveButtonClick(link_add_due_date_personal_kr, getCurrentQuarterEndDate);
        btnControl.resolveButtonClick(button_save_personal_kr_due_date, savePersonalKeyResultDueDate);

        getObjectiveCreatedDate();

        getKeyResultCreatedDate();

        // Search module
        textboxInput.searchingUser(searchPersonalObjective);
        textboxInput.searchingUser(searchPersonalKeyResult);
        
    });

    customModal.toggleProgressRingModal(1);
        
}); 

