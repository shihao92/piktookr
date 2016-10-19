// Date : 8 September 2016
// This JS file that controls team okr page only.

require(['model/team_key_result','model/team_objective', 'model/timeframe',
'helper/d3_data_input_process',
'view/library/bootstrap-datepicker', 'view/d3_engine',
'view/controls/overlay', 'view/library/select2.min', 'view/controls/custom_modal',
'view/controls/input_textbox', 'view/controls/button', 'view/controls/custom_select2', 'view/controls/page_refresh',
'view/search_result'], 
function(teamKeyResultModel, teamObjectiveModel, timeframeModel,
d3DataHelper,
datepicker, d3_engine,
overlay, select2, customModal,
textboxControl, btnControl, customSelect2, refreshPage, searchResult) {

    const container_team_dashboard = '#team_page_container';
    const button_create_team_objective = '#btn_new_team_objective';
    const button_edit_team_objective = '.edit_team_objective';
    const button_edit_team_key_result = '.edit_team_key_result';
    const button_team_setting = '#team_setting';
    const button_save_team_kr_due_date = '#btn_save_team_kr_due_date';
    const link_due_date_team_kr = '#link_add_due_date_team_kr';
    const modal_team_kr_due_date = '#team_kr_due_date_modal';
    const datepicker_team_kr = '#team_kr_datepicker';
    const page_team_objective_details = '#page_team_objective_details';
    const page_team_key_result_details = '#page_team_key_result_details';
    const input_overlay_search_user = '#overlay_search_user_input';
    const div_search_team_objectives_results = '#div_search_team_objectives_results';
    const div_search_team_kr_results = '#div_search_team_kr_results';

    let original_team_objective = "";
    let original_team_key_result = "";
    let creation_date = "";

    // --------------
    // Team Objective
    // --------------

    function focusOutCreateNewTeamObjective(event){
      if($('#new_team_objective').val() != '') {
        $('#new_objective_popup').attr('class','overlay');
        $('#team_objective_textarea').text($('#new_team_objective').val());
        $('#company_key_result_selection').select2();
        btnControl.toggleDisabledSaveNewTeamObjectiveButton(0);
      }
    }

    function enterCreateNewTeamObjective(event){
      let key = event.which;
      if(key == 13){
        if($('#new_team_objective').val() != '') {
          $('#new_objective_popup').attr('class','overlay');
          $('#team_objective_textarea').text($('#new_team_objective').val());
          $('#company_key_result_selection').select2();
        }
      }
    }

    function createTeamObjective(event){
      let team_objective = $('#team_objective_textarea').val();
      let company_key_result_id = $('#company_key_result_selection').val();
      let team_id = $(container_team_dashboard).attr('data-id');
      company_key_result_id = parseInt(company_key_result_id);
      team_id = parseInt(team_id);
      let create_objective_promise = new teamObjectiveModel.newTeamObjective(
          team_objective, company_key_result_id, team_id
      );
      create_objective_promise.then(createdTeamObjective, customModal.notificationModalToggle);
    }

    function createdTeamObjective(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function editTeamObjective(event){
      let team_objective_id = event.currentTarget.getAttribute('data-id');   
      let objective = $('#team_objective_' + team_objective_id).find('.details-layout').text();
      objective = objective.trim();  
      original_team_objective = objective;     
      btnControl.hideButton(button_edit_team_objective);
      textboxControl.createInputTextboxForEditTeamObjective(team_objective_id, objective);
    }

    function editingTeamObjective(event){
      let key = event.which;
      if(key == 13){
        let updated_objective = $(event.target).val();
        let original_objective = original_team_objective;
        if(updated_objective !== original_objective){
          let editing_objective_id = $(event.target).attr('data-id');
          let team_id = $(container_team_dashboard).attr('data-id');
          let edit_objective_promise = new teamObjectiveModel.editTeamObjective(
            editing_objective_id, updated_objective, original_objective, team_id
          );
          edit_objective_promise.then(editedTeamObjective, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    function editedTeamObjective(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function getObjectiveCreatedDate(){
      $(page_team_objective_details).ready(function(event){
        let team_id = $(page_team_objective_details).attr('data-team');
        let objective_id = $(page_team_objective_details).attr('data-id');
        if(objective_id != undefined) {
          let get_created_date_promise = new teamObjectiveModel.getCreatedDate(team_id, objective_id);
          get_created_date_promise.then(obtainObjectiveCreatedDate, customModal.notificationModalToggle);
        }
      });
    }

    function getObjectiveContribution(){
      $(page_team_objective_details).ready(function(event){
        let team_id = $(page_team_objective_details).attr('data-team');
        let objective_id = $(page_team_objective_details).attr('data-id');
        if(objective_id != undefined) {
          let get_contribution_promise = new teamObjectiveModel.getContribution(team_id, objective_id);
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

    function searchTeamObjective(event){
      let key = event.which;
      if(key === 13){
        let search_keyword = $(input_overlay_search_user).val();
        let search_objective_promise = new teamObjectiveModel.searchObjective(search_keyword);
        search_objective_promise.then(obtainSearchObjectiveResults, customModal.notificationModalToggle);
      }
    }

    function obtainSearchObjectiveResults(results){
      customModal.toggleProgressRingModal(0);
      searchResult.generateSearchTeamObjectiveResults(results, div_search_team_objectives_results);
      customModal.toggleProgressRingModal(1);
    }

    // ---------------
    // Team Key Result
    // ---------------

    function createNewTeamKeyResult(event){
      let key = event.which;
      if(key == 13){
        if($(event.target).val() !== '') {
          let team_objective_id = $(event.target).attr('data-id');
          let temp_team_key_result = $(event.target).val();
          let team_id = $(container_team_dashboard).attr('data-id');
          let create_key_result_promise = new teamKeyResultModel.newTeamKeyResult(
            temp_team_key_result, team_objective_id, team_id
          ); 
          create_key_result_promise.then(createdTeamKeyResult, customModal.notificationModalToggle);
        }
      }
    }  

    function createdTeamKeyResult(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function editTeamKeyResult(event){
      let team_key_result_id = event.currentTarget.getAttribute('data-id');
      team_key_result_id = parseInt(team_key_result_id);
      let team_key_result = $('#team_kr_' + team_key_result_id).find('.details-layout').text();    
      team_key_result = team_key_result.trim();
      original_team_key_result = team_key_result;
      textboxControl.createInputTextboxForEditTeamKeyResult(team_key_result_id, team_key_result);
    }

    function editingTeamKeyResult(event){
      let key = event.which;
      if(key == 13){
        let updated_key_result = $(event.target).val();
        let original_key_result = original_team_key_result;
        let team_id = $(container_team_dashboard).attr('data-id');
        if(updated_key_result !== original_key_result){
          let editing_key_result_id = event.currentTarget.getAttribute('data-id');
          let edit_key_result_promise = new teamKeyResultModel.editTeamKeyResult(
            editing_key_result_id, updated_key_result, original_key_result
          );
          edit_key_result_promise.then(editedTeamKeyResult, customModal.notificationModalToggle);
        }
        else{
          location.reload();
        }
      }
    }

    function editedTeamKeyResult(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function openTeamSettingOverlay(event){
      $('#user_invitation_selection').select2();
      $('#teammate_list').attr('class','overlay');
    }

    function getCurrentQuarterEndDate(){
      let get_current_quarter_end_date = new timeframeModel.getCurrentQuarterEndDate();
      get_current_quarter_end_date.then(initializeDatepicker, customModal.notificationModalToggle);
    }

    function initializeDatepicker(end_date){
      let nowDate = new Date();
      let today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
      $(datepicker_team_kr).datepicker({
        format: 'yyyy/mm/dd',
        startDate: today,
        endDate: end_date
      });
      $(modal_team_kr_due_date).modal('show');
    }

    function saveTeamKeyResultDueDate(event){
      let team_id = $(modal_team_kr_due_date).attr('data-id');
      let key_result_id = $(event.target).attr('data-id');
      let due_date = $(datepicker_team_kr).find('.form-control').val();
      $(modal_team_kr_due_date).modal('hide');
      if(due_date == ''){
        customModal.notificationModalToggle("Due date cannot be empty!");
      } else {
        let update_due_date_promise = new teamKeyResultModel.updateDueDate(team_id, key_result_id, due_date);
        update_due_date_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle); 
      } 
    }

    function getKeyResultCreationDate(){
      $(page_team_key_result_details).ready(function(){
        let team_id = $(modal_team_kr_due_date).attr('data-id');
        let key_result_id = $(page_team_key_result_details).attr('data-id');
        if(key_result_id !== undefined) {
          let get_created_date_promise = new teamKeyResultModel.getCreatedDate(team_id, key_result_id);
          get_created_date_promise.then(obtainKeyResultCreationDate, customModal.notificationModalToggle);
        }
      });
    }

    function getKeyResultContribution(){
      $(page_team_key_result_details).ready(function(){
        let team_id = $(modal_team_kr_due_date).attr('data-id');
        let key_result_id = $(page_team_key_result_details).attr('data-id');
        if(key_result_id !== undefined) {
          let get_contribution_promise = new teamKeyResultModel.getContribution(team_id, key_result_id);
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

    function searchTeamKeyResult(event){
      let key = event.which;
      if(key === 13){
        let search_keyword = $(input_overlay_search_user).val();
        let search_kr_promise = new teamKeyResultModel.searchKeyResult(search_keyword);
        search_kr_promise.then(obtainSearchKRResults, customModal.notificationModalToggle);
      }
    }

    function obtainSearchKRResults(results){
      customModal.toggleProgressRingModal(0);
      searchResult.generateSearchTeamKRResults(results, div_search_team_kr_results);
      customModal.toggleProgressRingModal(1);
    }

    $(document).ready(function() {
        
        // Key result - Create new  
        textboxControl.addNewTeamKeyResult(createNewTeamKeyResult);
        
        // Key result - Edit
        btnControl.resolveButtonClick(button_edit_team_key_result, editTeamKeyResult);
        textboxControl.editTeamKeyResult(editingTeamKeyResult);

        // Key result - Set due Date
        btnControl.resolveButtonClick(link_due_date_team_kr, getCurrentQuarterEndDate);
        btnControl.resolveButtonClick(button_save_team_kr_due_date, saveTeamKeyResultDueDate);

        // Team Objective - Create new
        textboxControl.addNewTeamObjective(focusOutCreateNewTeamObjective, enterCreateNewTeamObjective);
        customSelect2.companyKeyResultSelectionChanged();  
        btnControl.resolveButtonClick(button_create_team_objective, createTeamObjective);
        
        // Team Objective - Edit
        btnControl.resolveButtonClick(button_edit_team_objective, editTeamObjective);
        textboxControl.editTeamObjective(editingTeamObjective);

        // Setting for the team
        btnControl.resolveButtonClick(button_team_setting, openTeamSettingOverlay);

        getObjectiveCreatedDate();

        getKeyResultCreationDate();

        // Search Module
        textboxControl.searchingUser(searchTeamObjective);
        textboxControl.searchingUser(searchTeamKeyResult);

    })

})