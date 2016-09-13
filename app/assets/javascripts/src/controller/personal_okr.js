// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['pages/pages.blank', 
'model/personal_key_result', 'model/personal_objective', 
'view/controls/modal', 'view/controls/popup', 'view/controls/slider', 'view/controls/spin-progress', 'view/controls/select2.min'],
function(blankParam, 
personalKeyResultModelParam, personalObjectiveModelParam, 
modalParam, popupParam, sliderParam, spinProgressParam, select2Param) {

    // Show the progress ring when start to load things
    spinProgressParam.defineSpin();
    $('#progress_ring_modal').modal({backdrop: 'static', keyboard: false})
    $('#progress_ring_modal').modal('show');

    $(document).ready(function(){

        // Hide the progress ring after everything been loaded
        $('#progress_ring_modal').modal('hide');

        // Contribution popup for update progress
        popupParam.loadPopup();        
        $('[data-toggle=\"search\"]').click(function(event){
            // Store initial progress value
            let initial_progress = 0;
            let initial_progress_int = 0;

            let temp_id = event.target.id;
            temp_id = temp_id.substring(temp_id.indexOf('_') + 1,temp_id.length);
            let key_result = $('#personal_key_result_' + temp_id).find('.checkbox-primary').find('label').text();
            let progress = $('#personal_key_result_' + temp_id).find('#personal_kr_progress_' + temp_id).text();
            progress = progress.substring(0,progress.indexOf('%'));

            // Call all the UI to display details related to the progress
            popupParam.setPopupKeyResult(key_result,temp_id);
            sliderParam.contributionSliderControl(progress);
            initial_progress = progress;
            initial_progress_int = parseInt(initial_progress);
            // Save initial progress value
            $('#popup_initial_progress').text(initial_progress_int);
            $('#key_result_id').text(temp_id);
        });

        //Personal Objective - Create new
        $('#add-new-personal-objective')
        .on({
            keypress: function(e){
              let key = e.which;
              if(key == 13){
                  if($(this).find('#new_personal_objective').val() != '') {
                      $('#new_objective_popup').attr('class','overlay');
                      $('#personal_objective_textarea').text($(this).find('#new_personal_objective').val());
                      $('#team_key_result_selection').select2();
                  }
              }
            },
            focusout: function(){
              if($(this).find('#new_personal_objective').val() != '') {
                    $('#new_objective_popup').attr('class','overlay');
                    $('#personal_objective_textarea').text($(this).find('#new_personal_objective').val());
                    $('#team_key_result_selection').select2();
                }
            }
        });
        $('#team_key_result_selection').on('change', function() {
            if($('#personal_objective_textarea').val() != "") {
                $('#btn_new_personal_objective').prop( "disabled", false );
            }
        });
        $('#btn_new_personal_objective').click(function() {
            let personal_objective = $('#personal_objective_textarea').val();
            let team_key_result_id = $('#team_key_result_selection').val();
            personalObjectiveModelParam.newPersonalObjective(personal_objective, team_key_result_id);
            $('#notification_message').text("Your personal objective is created successfully!");
            $('#notification_modal').modal('show');
        });
        // Personal Objective - Edit 
        let temp_original_objective = "";
        let temp_editing_objective_id = 0;
        $('.edit_personal_objective').click(function() {
            let button_name = $(this).attr('name');
            let underscore_index = button_name.indexOf('_');
            let objective_id = button_name.substring(underscore_index + 1, button_name.length);
            temp_editing_objective_id = parseInt(objective_id);
            let objective = $('#personal_objective_' + objective_id).find('.details-layout').text();
            objective = objective.trim();

            temp_original_objective = objective;
            temp_editing_objective_id = objective_id;
            $('.edit_personal_objective').attr('style', 'visibility: hidden;');  
            $('#personal_objective_' + objective_id).html('');
            $('#personal_objective_' + objective_id).html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result"/>');
            $('#personal_objective_' + objective_id).find('.form-new-key-result').val(objective);
        });
        $('.panel-heading-a')
        .on({
            keypress: function(e){
                let key = e.which;
                if(key == 13){
                    let updated_objective = $(this).val();
                    let original_objective = temp_original_objective;
                    let editing_objective_id = temp_editing_objective_id;
                    if(updated_objective != original_objective){
                        personalObjectiveModelParam.editPersonalObjective(editing_objective_id, updated_objective, original_objective);
                        $('#notification_message').text("Your personal objective is updated successfully!");
                        $('#notification_modal').modal('show');
                    }
                    else{
                        location.reload();
                    }
                }
            },
            focusout: function(){
                location.reload();
            }
        },'.add-new-personal-key-result');

        // Key result - Create new  
        $(".add-new-personal-key-result")
        .on({
            keypress: function(e){
                let key = e.which;
                if(key == 13){
                    if($(this).find('.form-new-key-result').val() != '') {
                        // Find out the personal objective id
                        let current_focus_id = $(this).find('.form-new-key-result').attr('id');
                        let id_index = current_focus_id.indexOf('objective_');
                        let id_substring = current_focus_id.substring(id_index + 10, current_focus_id.length);
                        let temp_personal_key_result = $(this).find('.form-new-key-result').val();

                        personalKeyResultModelParam.newPersonalKeyResult(
                            temp_personal_key_result, id_substring
                        ); 

                        $('#notification_message').text("Your personal key result is created successfully!");
                        $('#notification_modal').modal('show');
                    }
                    else{
                        //do nothing
                    }
                }
            },
            focusout: function(){
                location.reload();
            }
        }, '#new_key_result');
        // Key result - Update progress
        $('#btn_update_progress').click(function() {
            let progress = $('#slider-tooltips').val();
            let initial_progress = $('#popup_initial_progress').text();
            let key_result_id = $('#key_result_id').text();
            let contribution = $('#contribution_textarea').val();
            
            // AJAX call to update the personal key result progress
            personalKeyResultModelParam.updatePersonalKeyResultProgress(
                key_result_id, progress, initial_progress, contribution
            );

            $('#notification_message').text("Your personal key result is updated successfully!");
            $('#notification_modal').modal('show'); 
        
        });
        // Key result - Checked completed key result
        let checkbox_tick_amount = $('input[type=checkbox]:checked').length;
        $('input[type=checkbox]').click(function() {
            // 1 - checked 
            // 0 - not check
            let checked_value = $('input[type=checkbox]:checked').length;
            let key_result_id = $(this).attr('id');
            let underscore_index = key_result_id.indexOf('_');
            key_result_id = key_result_id.substring(underscore_index + 1, key_result_id.length);
            if(checked_value < checkbox_tick_amount)
            {
                personalKeyResultModelParam.updatePersonalKeyResultStatus(key_result_id, false);
                $('#notification_message').text("Your personal key result is marked as incomplete!");
            }
            else
            {
                personalKeyResultModelParam.updatePersonalKeyResultStatus(key_result_id, true);
                $('#notification_message').text("Your personal key result is marked as completed!");
            }

            $('#notification_modal').modal('show'); 

        });
        // Key Result - Edit 
        let temp_original_key_result = "";
        let temp_editing_key_result_id = 0;
        $('.edit_personal_key_result').click(function() {
            let button_name = $(this).attr('name');
            let underscore_index = button_name.indexOf('_');
            let key_result_id = button_name.substring(underscore_index + 1, button_name.length);
            temp_editing_key_result_id = parseInt(key_result_id);
            let key_result = $('#personal_kr_' + key_result_id).find('.details-layout').text();
            key_result = key_result.trim();
            $('#personal_kr_' + key_result_id).html('');
            $('#personal_kr_' + key_result_id).html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result"/>');
            $('#personal_kr_' + key_result_id).find('.form-new-key-result').val(key_result);
            temp_original_key_result = key_result;
            $('.edit_personal_key_result').attr('style', 'visibility: hidden;');
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
                        personalKeyResultModelParam.editPersonalKeyResult(editing_key_result_id, updated_key_result, original_key_result);
                        $('#notification_message').text("Your personal key result is updated successfully!");
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
        },'.add-new-personal-key-result');

        $('#notification_dismiss_btn').click(function() {
            location.reload();
        });
        
    });
        
}); 

