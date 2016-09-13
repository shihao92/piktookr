// Date : 8 September 2016
// This JS file that controls team okr page only.

require([
'model/team_key_result','model/team_objective',
'view/controls/modal', 'view/controls/popup', 'view/controls/select2.min'], 
function(
teamKeyResultModelParam, teamObjectiveModelParam,
modalParam, popupParam, select2Param) {

    $(document).ready(function() {
        
        // Key result - Create new  
        $('.add-new-team-key-result')
        .on({
            focusout: function(){
                location.reload();
            },
            keypress: function(e){
                let key = e.which;
                if(key == 13){
                    if($(this).find('.form-new-key-result').val() != '') {
                        // Find out the personal objective id
                        let current_focus_id = $(this).find('.form-new-key-result').attr('id');
                        let id_index = current_focus_id.indexOf('objective_');
                        let id_substring = current_focus_id.substring(id_index + 10, current_focus_id.length);
                        let temp_team_key_result = $(this).find('.form-new-key-result').val();
                    
                        teamKeyResultModelParam.newTeamKeyResult(
                            temp_team_key_result, id_substring
                        ); 
                    
                        $('#notification_message').text("Your team key result is created successfully!");
                        $('#notification_modal').modal('show');
                    }
                }
            }
        }, '#new_key_result');
        // Key result - Edit
        let temp_editing_key_result_id = 0;
        let temp_original_key_result = "";
        $('.edit_team_key_result').click(function() {
            let button_name = $(this).attr('name');
            let underscore_index = button_name.indexOf('_');
            let key_result_id = button_name.substring(underscore_index + 1, button_name.length);
            temp_editing_key_result_id = parseInt(key_result_id);
            let key_result = $('#team_kr_' + key_result_id).find('.details-layout').text();
            key_result = key_result.trim();
            $('#team_kr_' + key_result_id).html('');
            $('#team_kr_' + key_result_id).html('<input type="text" class="form-control form-new-key-result add-new-team-key-result"/>');
            $('#team_kr_' + key_result_id).find('.form-new-key-result').val(key_result);
            temp_original_key_result = key_result;
            $('.edit_team_key_result').attr('style', 'visibility: hidden;');
        });
        $('.checkbox-primary')
        .on({
            keypress: function(e) {
                let key = e.which;
                if(key == 13){
                    let updated_key_result = $(this).val();
                    let original_key_result = temp_original_key_result;
                    let editing_key_result_id = temp_editing_key_result_id;
                    if(updated_key_result != original_key_result && updated_key_result != ''){
                        teamKeyResultModelParam.editTeamKeyResult(editing_key_result_id, updated_key_result, original_key_result);
                        $('#notification_message').text("Your team key result is updated successfully!");
                        $('#notification_modal').modal('show');
                    }
                    else{
                        location.reload();
                    }
                }
            },
            focusout: function() {
                location.reload();
            }
        },'.add-new-team-key-result');

        // Team Objective - Create new
        $('#add-new-team-objective')
        .on({
            focusout: function(){
                location.reload();
            },
            keypress: function(e){
                let key = e.which;
                if(key == 13){
                    if($(this).find('#new_team_objective').val() != '') {
                        $('#new_objective_popup').attr('class','overlay');
                        $('#team_objective_textarea').text($(this).find('#new_team_objective').val());
                        $('#company_key_result_selection').select2();
                    }
                }
            }
        });
        $('#company_key_result_selection').on('change', function() {
            if($('#team_objective_textarea').val() != "") {
                $('#btn_new_team_objective').prop( "disabled", false );
            }
        });
        $('#btn_new_team_objective').click(function() {
            let team_objective = $('#team_objective_textarea').val();
            let company_key_result_id = $('#company_key_result_selection').val();
            let team_id = $(this).attr('name');
            teamObjectiveModelParam.newTeamObjective(team_objective, company_key_result_id, team_id);
            $('#notification_message').text("Your personal objective is created successfully!");
            $('#notification_modal').modal('show');
        });
        // Team Objective - Edit
        let temp_original_objective = "";
        let temp_editing_objective_id = 0;
        $('.edit_team_objective').click(function() {
            let button_name = $(this).attr('name');
            let underscore_index = button_name.indexOf('_');
            let objective_id = button_name.substring(underscore_index + 1, button_name.length);
            temp_editing_objective_id = parseInt(objective_id);
            let objective = $('#team_objective_' + objective_id).find('.details-layout').text();
            objective = objective.trim();

            temp_original_objective = objective;
            temp_editing_objective_id = objective_id;
            $('.edit_team_objective').attr('style', 'visibility: hidden;');  
            $('#team_objective_' + objective_id).html('');
            $('#team_objective_' + objective_id).html('<input type="text" class="form-control form-new-key-result add-new-team-key-result"/>');
            $('#team_objective_' + objective_id).find('.form-new-key-result').val(objective);
        });
        $('.panel-heading-a')
        .on({
            keypress: function(e) {
                let key = e.which;
                if(key == 13){
                    let updated_objective = $(this).val();
                    let original_objective = temp_original_objective;
                    let editing_objective_id = temp_editing_objective_id;
                    if(updated_objective != original_objective){
                        teamObjectiveModelParam.editTeamObjective(editing_objective_id, updated_objective, original_objective);
                        $('#notification_message').text("Your team objective is updated successfully!");
                        $('#notification_modal').modal('show');
                    }
                    else{
                        location.reload();
                    }
                }
            },
            focusout: function() {
                location.reload();
            }
        },'.add-new-team-key-result');

    })

})