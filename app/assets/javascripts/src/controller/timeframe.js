// Date : 28 September 2016
// This JS file that controls timeframe only.

require(['model/timeframe',
'view/controls/button', 'view/controls/custom_modal', 'view/controls/page_refresh'],
function(timeframeModel, btnControl, customModal, refreshPage){

  const timeframe_log_selection = 'a[name=timeframe_log_selection]'; 


  function updateSystemTimeframeLog(event){
    let selected_timeframe_log_id = $(event.target).attr('data-id');
    let update_system_timeframe_promise = new timeframeModel.updateSystemTimeframeLogID(selected_timeframe_log_id);
    update_system_timeframe_promise.then(successUpdateSystemTimeframeLog, customModal.notificationModalToggle);
  }

  function successUpdateSystemTimeframeLog(message){
    customModal.toggleProgressRingModal(0);
    refreshPage.refreshPage();
  }


  $(document).ready(function(){

    // Update the system timeframe log ID
    btnControl.resolveButtonClick(timeframe_log_selection, updateSystemTimeframeLog);

  });

})