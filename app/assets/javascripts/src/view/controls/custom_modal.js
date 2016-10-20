// Date: 20 September 2016
// JS file to customize the control - Modal.

define(['view/library/modal', 'view/controls/spin-progress'],
function(modalLibraryParam, spinProgressParam){

  function toggleProgressRingModal(input)
  {
    switch(input){
      case 0: spinProgressParam.defineSpin(); 
              $('#progress_ring_modal').modal({backdrop: 'static', keyboard: false})
              $('#progress_ring_modal').modal('show');
              break;

      case 1: $('#progress_ring_modal').modal('hide');
              break;
    }
  }

  function detectCheckedConfirmationModalClose(){
    $("#modal_checked_personal_kr_confirmation").on('hidden.bs.modal', function(){
      let key_result_id = $('#btn_remove_checked_kr').attr('data-id');
      $('#personalkrcompleted_' + key_result_id).removeProp('checked');
    });
  }

  function notificationModalToggle(message)
  {
    $('#notification_message').text(message);
    $('#notification_modal').modal('show');
  }

  return {
    toggleProgressRingModal,
    notificationModalToggle,
    detectCheckedConfirmationModalClose
  }

})