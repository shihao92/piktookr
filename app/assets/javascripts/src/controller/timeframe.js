// Date : 28 September 2016
// This JS file that controls timeframe only.

require(['model/timeframe',
'view/controls/custom_select2',
'view/controls/button', 'view/controls/custom_modal', 'view/controls/page_refresh', 'view/controls/overlay'],
function(timeframeModel, customSelect2,
btnControl, customModal, refreshPage, overlay){

  const timeframe_log_selection = 'a[name=timeframe_log_selection]'; 
  const timeframes_index_page = '#timeframes_index_page';
  const button_new_timeframe_setting = '#btn_new_timeframe_overlay';
  const overlay_new_year_timeframe_setup = '#overlay_new_year_timeframe_setup';
  const select_year = '#year_selection';
  const select_timeframe_log_interval = '#timeframe_log_interval_selection';
  const button_new_timeframe_logs = '#btn_create_timeframe_log';
  const timeframe_status_reminder_bar = '#timeframe_status_reminder_bar';
  const timeframe_reminder_message = '#timeframe_reminder_message';
  const link_delete_timeframe = 'a[name=link_delete_timeframe]';


  function updateSystemTimeframeLog(event){
    let selected_timeframe_log_id = $(event.target).attr('data-id');
    let update_system_timeframe_promise = new timeframeModel.updateSystemTimeframeLogID(selected_timeframe_log_id);
    update_system_timeframe_promise.then(successUpdateSystemTimeframeLog, customModal.notificationModalToggle);
  }

  function successUpdateSystemTimeframeLog(message){
    customModal.toggleProgressRingModal(0);
    refreshPage.refreshPage();
  }

  // Check whether the timeframe intervals for next year had been set
  function checkNextYearLogStatus(){
    $(timeframe_status_reminder_bar).ready(function(){
      let check_next_year_log_promise = new timeframeModel.checkNextYearLogPromise();
      check_next_year_log_promise.then(setTimeframeReminder, customModal.notificationModalToggle);
    });
  }

  function setTimeframeReminder(message){
    $(timeframe_reminder_message).text(message);
  }

  function setNewTimeframe(event){
    $(select_year).select2();
    $(select_timeframe_log_interval).select2();
    overlay.toggleOverlay(overlay_new_year_timeframe_setup, 1);
  }

  function createTimeframeLogs(event){
    let selected_year = $(select_year).val();
    let selected_quarter = $(select_timeframe_log_interval).val();
    let new_timeframe_log_promise = new timeframeModel.createTimeframeLogPromise(selected_year, selected_quarter);
    new_timeframe_log_promise.then(createdTimeframeLogs, customModal.notificationModalToggle);
  }

  function createdTimeframeLogs(message){
    customModal.toggleProgressRingModal(0);
    refreshPage.refreshPage();
  }

  function removeTimeframe(event){
    let timeframe_id = $(event.target).attr('data-id');
    let remove_timeframe_promise = new timeframeModel.removeTimeframe(timeframe_id);
    remove_timeframe_promise.then(removedTimeframe, customModal.notificationModalToggle);
  }

  function removedTimeframe(message){
    customModal.toggleProgressRingModal(0);
    refreshPage.refreshPage();
  }


  $(document).ready(function(){

    checkNextYearLogStatus();

    // Update the system timeframe log ID
    btnControl.resolveButtonClick(timeframe_log_selection, updateSystemTimeframeLog);

    // Create new timeframe logs for coming years
    btnControl.resolveButtonClick(button_new_timeframe_setting, setNewTimeframe);
    btnControl.resolveButtonClick(button_new_timeframe_logs, createTimeframeLogs);

    // Remove timeframe - only future timeframe can be removed
    btnControl.resolveButtonClick(link_delete_timeframe, removeTimeframe);

  });

})