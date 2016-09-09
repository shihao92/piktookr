// Date : 8 September 2016
// This JS file that controls team okr page only.

require(['pages/pages.blank',
'model/team_key_result','model/team_objective',
'view/controls/modal', 'view/controls/popup', 'view/controls/select2.min'], 
function(blankParam,
teamKeyResultModelParam, teamObjectiveModelParam,
modalParam, popupParam, select2Param) {

    $(document).ready(function() {
        
        // Key result - Create new  
        $(".add-new-team-key-result")
        .on('focusout', '#new_key_result', function() {
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
            else{
                //do nothing
            }
        });

        // Team Objective - Create new
        $('#add-new-team-objective')
        .on('focusout', function() {
            if($(this).find('#new_team_objective').val() != '') {
                $('#new_objective_popup').attr('class','overlay');
                $('#team_objective_textarea').text($(this).find('#new_team_objective').val());
                $('#company_key_result_selection').select2();
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

    })

})