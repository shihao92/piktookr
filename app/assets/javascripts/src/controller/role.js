// Date : 26 July 2016
// This JS file that acts as controller for the role module. 

require(['model/role',
'view/controls/button', 'view/controls/custom_modal', 'view/controls/page_refresh', 'view/controls/overlay', 
'view/controls/panel'], 
function(roleParam, btnControl, customModal, refreshPage, overlay, panel){
    
  const button_create_role_overlay = '#btn_create_role_overlay';
  const button_new_role = '#btn_new_role';
  const overlay_new_role = '#overlay_new_role';
  const input_new_role_name = '#new_role_name';
  const input_new_role_description = '#new_role_description';
  const input_checked_control_selection = 'input[name=checked_security_checkbox]';
  const input_check_control_selection = 'input[name=security_checkbox]';
  const radio_button_okr_role = 'label[name=radio_btn_okr_role]';
  const panel_role_control = 'div[name=okr_role_control_panel]';


  function createNewRole(event){
    overlay.toggleOverlay(overlay_new_role, 1);
  }

  function creatingNewRole(event){
    let role_name = $(input_new_role_name).val();
    let role_description = $(input_new_role_description).val();
    if(role_name == '' || role_description == ''){
      customModal.notificationModalToggle("Information is required to proceed!");
    } else {
      let new_role_promise = new roleParam.createNewRole(role_name, role_description);
      new_role_promise.then(createdNewRole, customModal.notificationModalToggle);
    }
  }

  function createdNewRole(event){
    customModal.toggleProgressRingModal(0);
    refreshPage.refreshPage();
  }

  function toggleRoleButtonGroup(event){
    let role_name = $(event.target).find('input[name=options]').attr('data-id');
    panel.togglePanelVisibility(panel_role_control, 0);
    let role_panel_id = '#' + role_name + '_panel';
    panel.togglePanelVisibility(role_panel_id, 1);
  }

  function checkSecurityControl(event){
    let role_id = $(event.target).parents(panel_role_control).attr('data-id');
    let control_id = $(event.target).attr('data-id');
    if($(event.target).attr('value') === '0'){
      $(event.target).attr('value', '1');
      let input_role_control_promise = new roleParam.createRoleControl(role_id, control_id);
      input_role_control_promise.then(checkedSecurityControl, customModal.notificationModalToggle);
    } else {
      $(event.target).attr('value', '0');
      let remove_role_control_promise = new roleParam.removeRoleControl(role_id, control_id);
      remove_role_control_promise.then(checkedSecurityControl, customModal.notificationModalToggle);
    }
  }

  function checkedSecurityControl(event){
    customModal.toggleProgressRingModal(0);
    setTimeout(doneCheckedSecurityControl, 1000);
  }

  function doneCheckedSecurityControl(event){
    customModal.toggleProgressRingModal(1);
  }


  $(document).ready(function(){

    btnControl.resolveButtonClick(button_create_role_overlay, createNewRole);
    btnControl.resolveButtonClick(button_new_role, creatingNewRole);

    // Role button group selection
    btnControl.resolveButtonClick(radio_button_okr_role, toggleRoleButtonGroup);

    // Role control checkbox checked or unchecked
    btnControl.resolveButtonClick(input_check_control_selection, checkSecurityControl);

  })
    
})