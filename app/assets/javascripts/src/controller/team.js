// Date : 24 September 2016
// This JS file that controls team related module.

require(['model/team',
'view/controls/overlay', 'view/controls/button', 'view/controls/custom_modal'], 
function(teamModel,
overlay, btnControl, customModal){

  const container_team_dashboard = '#team_page_container';
  const button_new_team_overlay = '#btn_create_new_team_overlay';
  const button_create_new_team = '#btn_create_new_team';
  const button_delete_team = '#btn_confirm_delete_team';
  const button_edit_team = '#btn_edit_team';
  const button_invite_team = '#btn_invite_new_member';
  const select_user_invite_team = '#user_invitation_selection';
  const overlay_create_new_team = '#overlay_create_new_team';
  const overlay_delete_team = '#overlay_team_deletion';
  const overlay_edit_team = '#overlay_team_edit';
  const link_delete_team = 'a[name=link_delete_team]';
  const link_edit_team = 'a[name=link_edit_team]';
  const span_deleting_team_name = '#name_deleting_team';
  const input_edit_team_name = '#edit_team_name';
  const input_edit_team_description = '#edit_team_description';

  // Create new team
  const input_new_team_name = '#new_team_name';
  const input_new_team_description = '#new_team_description';

  // Edit team
  let original_team_name = "";
  let original_team_description = "";



  // -------------------------
  // Team Details and Settings
  // -------------------------

  function displayNewTeamOverlay(){
    overlay.toggleOverlay(overlay_create_new_team, 1);
  }

  function createNewTeam(event){
    let team_name = $(input_new_team_name).val();
    let team_description = $(input_new_team_description).val();

    if(team_name !== '' && team_description !== ''){
      let create_new_team_promise = new teamModel.newTeamPromise(team_name, team_description);
      create_new_team_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    } else {
      customModal.notificationModalToggle("Team name or team description cannot be empty!");
    }
  }

  function displayDeleteTeamOverlay(event){
    let target_team_id = $(event.target).attr('data-id');
    $(button_delete_team).attr('data-id', target_team_id);

    let team_name = $(event.target).parents('tr[name=team_listing_' + target_team_id + ']').find('td[name=team_name]');
    $(span_deleting_team_name).html(team_name);

    overlay.toggleOverlay(overlay_delete_team, 1);
  }

  function deleteTeam(event){
    let target_team_id = $(event.target).attr('data-id');
    let delete_team_promise = new teamModel.deleteTeamPromise(target_team_id);
    delete_team_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
  }

  function getTeamInfoJSON(value){
    value = JSON.parse(value);
    original_team_name = value.name;
    original_team_description = value.description;

    $(input_edit_team_name).val(value.name);
    $(input_edit_team_description).val(value.description);
    $(overlay_delete_team).attr('data-id', value.id);

    overlay.toggleOverlay(overlay_edit_team, 1);
  }

  function displayEditTeamOverlay(event){
    let target_team_id = $(event.target).attr('data-id');
    let get_team_info_promise = new teamModel.getTeamInfoPromise(target_team_id);
    get_team_info_promise.then(getTeamInfoJSON, customModal.notificationModalToggle); 
  }

  function saveEditedTeamInfo(event){
    let edited_team_name = $(input_edit_team_name).val();
    let edited_team_description = $(input_edit_team_description).val();
    let edited_team_id = $(overlay_delete_team).attr('data-id');

    if(edited_team_name !== original_team_name || edited_team_description !== original_team_description){
      let update_team_info_promise = new teamModel.updateTeamInfoPromise(edited_team_id, edited_team_name, edited_team_description);
      update_team_info_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    } else {
      customModal.notificationModalToggle("Team information is not updated!");
    }
  }

  function sendTeamInvitation(event){
    let sender_id = $(event.target).attr('data-id');
    let selected_user_id = $(select_user_invite_team).val();
    let team_id = $(container_team_dashboard).attr('data-id');
    let team_invitation_promise = new teamModel.inviteToTeamPromise(team_id, sender_id, selected_user_id);
    team_invitation_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
  }

  $(document).ready(function(){

    // Create new team overlay
    btnControl.resolveButtonClick(button_new_team_overlay, displayNewTeamOverlay);
    btnControl.resolveButtonClick(button_create_new_team, createNewTeam);

    // Delete team overlay
    btnControl.resolveButtonClick(link_delete_team, displayDeleteTeamOverlay);
    btnControl.resolveButtonClick(button_delete_team, deleteTeam);

    // Edit team overlay
    btnControl.resolveButtonClick(link_edit_team, displayEditTeamOverlay);
    btnControl.resolveButtonClick(button_edit_team, saveEditedTeamInfo);

    // Send team invitation
    btnControl.resolveButtonClick(button_invite_team, sendTeamInvitation);


  });

})