// Date: 20 September 2016
// JS file to control all the inputs in the project.

define(['view/controls/overlay'],
function(overlayParam){

  function addNewPersonalObjective(){
    $('#add-new-personal-objective')
    .on({
      keypress: function(event){
        let key = event.which;
        if($('#new_personal_objective').val() !== '') {
          if(key == 13){
            let temp_personal_objective = "";
            temp_personal_objective = $('#new_personal_objective').val();
            overlayParam.loadNewPersonalObjectiveOverlayContent();
            $('#personal_objective_textarea').text(temp_personal_objective);
          }
        }       
      }
    });
  }

  function editPersonalObjective(resolve){
    $('.panel-heading-a')
    .on({
      keypress: resolve,
      focusout: function(){
        location.reload();
      }
    },'.add-new-personal-key-result');
  }

  function addNewPersonalKeyResult(resolve){
    $('#new_key_result')
    .on({
      focusout: function(){
        location.reload();
      },
      keypress: resolve      
    });
  }

  function editPersonalKeyResult(resolve){
    $('.checkbox-primary')
    .on({
      keypress: resolve,
      focusout: function() {
        location.reload();
      }
    },'.add-new-personal-key-result');
  }

  function createInputTextboxForEditPersonalObjective(objective_id, original_objective){
    $('#personal_objective_' + objective_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result" data-id="' + objective_id + '"/>')
    .find('.form-new-key-result')
    .val(original_objective);
  }

  function createInputTextboxForEditPersonalKeyResult(key_result_id, original_key_result){
    $('#personal_kr_' + key_result_id)
    .empty()
    .html('<input type="text" class="form-control form-new-key-result add-new-personal-key-result" data-id="' + key_result_id + '" />')
    .find('.form-new-key-result').val(original_key_result);
  }

  return{
    addNewPersonalObjective,
    editPersonalObjective,
    addNewPersonalKeyResult,
    editPersonalKeyResult,
    createInputTextboxForEditPersonalObjective,
    createInputTextboxForEditPersonalKeyResult
  }

})