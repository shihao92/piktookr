// Date : 12 September 2016
// This JS file that controls company okr page only.

require([
'model/company_key_result', 'model/company_objective',
'view/controls/overlay', 'view/library/select2.min'], 
function(
companyKeyResultModelParam, companyObjectiveModelParam,
overlayParam, select2Param) {

    $(document).ready(function() {
        
        // Key Result - Create new 
        $(".add-new-company-key-result")
        .on({
            focusout: function() {
                location.reload();
            },
            keypress: function(e) {
              let key = e.which;
              if(key == 13){
                if($(this).find('.form-new-key-result').val() != '') {
                  // Find out the personal objective id
                  let current_focus_id = $(this).find('.form-new-key-result').attr('id');
                  let id_index = current_focus_id.indexOf('objective_');
                  let id_substring = current_focus_id.substring(id_index + 10, current_focus_id.length);
                  let temp_company_key_result = $(this).find('.form-new-key-result').val();  
                  let create_company_kr_promise = new companyKeyResultModelParam.newCompanyKeyResult(
                      temp_company_key_result, id_substring
                  ); 
                  create_company_kr_promise.then(function(value) {
                      $('#notification_message').text(value);
                      $('#notification_modal').modal('show');
                  }, function(reason) {
                      $('#notification_message').text(reason);
                      $('#notification_modal').modal('show');
                  });
                }
                else{
                    //do nothing
                }
              }
            }
        }, '#new_key_result');
        // Key Result - Edit
        let temp_editing_key_result_id = 0;
        let temp_original_key_result = "";
        $('.edit_company_key_result').click(function() {
            let button_name = $(this).attr('name');
            let underscore_index = button_name.indexOf('_');
            let key_result_id = button_name.substring(underscore_index + 1, button_name.length);
            temp_editing_key_result_id = parseInt(key_result_id);
            let key_result = $('#company_kr_' + key_result_id).find('.details-layout').text();
            key_result = key_result.trim();
            $('#company_kr_' + key_result_id).html('');
            $('#company_kr_' + key_result_id).html('<input type="text" class="form-control form-new-key-result add-new-company-key-result"/>');
            $('#company_kr_' + key_result_id).find('.form-new-key-result').val(key_result);
            temp_original_key_result = key_result;
            $('.edit_company_key_result').attr('style', 'visibility: hidden;');
        });
        $('.checkbox-primary')
        .on({
            focusout: function() {
                location.reload();
            },
            keypress: function(e) {
                let key = e.which;
                if(key == 13){
                  let updated_key_result = $(this).val();
                  let original_key_result = temp_original_key_result;
                  let editing_key_result_id = temp_editing_key_result_id;
                  if(updated_key_result != original_key_result && updated_key_result != ''){
                      let edit_company_kr_promise = new companyKeyResultModelParam.editCompanyKeyResult(
                          editing_key_result_id, updated_key_result, original_key_result
                      );
                      edit_company_kr_promise.then(function(value){
                          $('#notification_message').text(value);
                          $('#notification_modal').modal('show');
                      }, function(reason) {
                          $('#notification_message').text(reason);
                          $('#notification_modal').modal('show');
                      });
                  }
                  else{
                      location.reload();
                  }
                }
            }
        },'.add-new-company-key-result');

        // Company Objective - Create new
        $('#add-new-company-objective')
        .on({
            focusout: function() {
                if($(this).find('#new_company_objective').val() != '') {
                    $('#new_objective_popup').attr('class','overlay');
                    $('#company_objective_textarea').text($(this).find('#new_company_objective').val());
                    $('#btn_new_company_objective').prop( "disabled", false );
                }                
            },
            keypress: function(e) {
                let key = e.which;
                if(key == 13){
                    if($(this).find('#new_company_objective').val() != '') {
                        $('#new_objective_popup').attr('class','overlay');
                        $('#company_objective_textarea').text($(this).find('#new_company_objective').val());
                        $('#btn_new_company_objective').prop( "disabled", false );
                    }
                }
            }
        });
        $('#btn_new_company_objective').click(function() {
            let company_objective = $('#company_objective_textarea').val();
            let create_company_objective_promise = new companyObjectiveModelParam.newCompanyObjective(company_objective);
            create_company_objective_promise.then(function(value) {
                $('#notification_message').text(value);
                $('#notification_modal').modal('show');
            }, function(reason) {
                $('#notification_message').text(value);
                $('#notification_modal').modal('show');
            });
        });
        // Company Objective - Edit
        let temp_original_objective = "";
        let temp_editing_objective_id = 0;
        $('.edit_company_objective').click(function() {
            let button_name = $(this).attr('name');
            let underscore_index = button_name.indexOf('_');
            let objective_id = button_name.substring(underscore_index + 1, button_name.length);
            temp_editing_objective_id = parseInt(objective_id);
            let objective = $('#company_objective_' + objective_id).find('.details-layout').text();
            objective = objective.trim();

            temp_original_objective = objective;
            temp_editing_objective_id = objective_id;
            $('.edit_company_objective').attr('style', 'visibility: hidden;');  
            $('#company_objective_' + objective_id).html('');
            $('#company_objective_' + objective_id).html('<input type="text" class="form-control form-new-key-result add-new-company-key-result"/>');
            $('#company_objective_' + objective_id).find('.form-new-key-result').val(objective);
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
                  let edit_company_objective_promise = new companyObjectiveModelParam.editCompanyObjective(
                    editing_objective_id, updated_objective, original_objective
                  );
                  edit_company_objective_promise.then( function(value) {
                    $('#notification_message').text(value);
                    $('#notification_modal').modal('show');
                  }, function(reason) {
                    $('#notification_message').text(value);
                    $('#notification_modal').modal('show');
                  });
                }
                else{
                    location.reload();
                }
              }
            },
            focusout: function() {
                location.reload();
            }
        },'.add-new-company-key-result');

    })

})