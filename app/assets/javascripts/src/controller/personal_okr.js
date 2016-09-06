// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['pages/pages.blank','model/personal_key_result','view/controls/popup','view/controls/slider'],
function(blankParam,personalKeyResultModelParam,popupParam,sliderParam){

    $(document).ready(function(){

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

        // Key result - Create new  
        $(".add-new-personal-key-result")
        .on('focusout', '#new_key_result', function() {
            if($(this).find('.form-new-key-result').val() != ''){
                // Find out the personal objective id
                let current_focus_id = $(this).find('.form-new-key-result').attr('id');
                let id_index = current_focus_id.indexOf('objective_');
                let id_substring = current_focus_id.substring(id_index + 10, current_focus_id.length);
                let temp_personal_key_result = $(this).find('.form-new-key-result').val();
                
                personalKeyResultModelParam.newPersonalKeyResult(
                    temp_personal_key_result, id_substring
                ); 

                sessionStorage.reloadAfterPageLoad = true;
                location.reload();                   
            }
            else{
                //do nothing
            }
        });
        $( function () {
            if ( sessionStorage.reloadAfterPageLoad ) {
                alert( "Personal Key Result created!" );
                sessionStorage.reloadAfterPageLoad = false;
            }
        });

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

            // $('#notification_message').text("Your personal key result is updated successfully!");
            // $('#notification_modal').modal('show'); 

            alert("Your personal key result is updated successfully!");

            location.reload();         
        });

    });
        
}); 

