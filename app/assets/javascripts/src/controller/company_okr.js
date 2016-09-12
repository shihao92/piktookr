// Date : 12 September 2016
// This JS file that controls company okr page only.

require(['pages/pages.blank',
'model/company_key_result', 'model/company_objective',
'view/controls/modal', 'view/controls/popup', 'view/controls/select2.min'], 
function(blankParam,
companyKeyResultModelParam, companyObjectiveModelParam,
modalParam, popupParam, select2Param) {

    $(document).ready(function() {
        
        // Key Result - Create new 
        $(".add-new-company-key-result")
        .on('focusout', '#new_key_result', function() {
            if($(this).find('.form-new-key-result').val() != '') {
                // Find out the personal objective id
                let current_focus_id = $(this).find('.form-new-key-result').attr('id');
                let id_index = current_focus_id.indexOf('objective_');
                let id_substring = current_focus_id.substring(id_index + 10, current_focus_id.length);
                let temp_company_key_result = $(this).find('.form-new-key-result').val();

                companyKeyResultModelParam.newCompanyKeyResult(
                    temp_company_key_result, id_substring
                ); 

                $('#notification_message').text("Your team key result is created successfully!");
                $('#notification_modal').modal('show');
            }
            else{
                //do nothing
            }
        });

        // Company Objective - Create new
        $('#add-new-company-objective')
        .on('focusout', function() {
            if($(this).find('#new_company_objective').val() != '') {
                $('#new_objective_popup').attr('class','overlay');
                $('#company_objective_textarea').text($(this).find('#new_company_objective').val());
                $('#btn_new_company_objective').prop( "disabled", false );
            }
        });
        $('#btn_new_company_objective').click(function() {
            let company_objective = $('#company_objective_textarea').val();
            let team_id = $(this).attr('name');
            companyObjectiveModelParam.newCompanyObjective(company_objective);
            $('#notification_message').text("Company objective is created successfully!");
            $('#notification_modal').modal('show');
        });

    })

})