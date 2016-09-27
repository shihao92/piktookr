// Date : 24 September 2016
// This JS file that controls user creation only.

require(['model/user',
'view/controls/overlay', 'view/controls/button', 'view/controls/custom_modal'],
function(userModel, overlay, btnControl, customModal){

    const document_url = document.URL;
    const button_create_new_user = '#btn_create_new_user_overlay';
    const button_create_another_user = '#btn_create_another_user_overlay';
    const button_confirm_delete_user = '#btn_confirm_delete_user';
    const overlay_create_new_user = '#overlay_create_new_user';
    const link_delete_user = "a[name=link_delete_user]";
    const link_edit_user = "a[name=link_edit_user]";
    const html_user_deletion_img = "#img_deleting_user";
    const name_user_deletion = "#name_deleting_user";

    // Controls at Layout Page
    const link_user_profile = '#link_user_profile';

    // Controls at Team Settings Page
    const button_remove_team_user = 'button[name=btn_remove_team_user]';

    // -------------------------
    // User Details and Settings
    // -------------------------

    function loadContentNewUserOverlay(event){
      overlay.loadNewUserOverlayContent();
    }

    function checkUserCreationStatus(){
      let user_creation_status_index = document_url.indexOf(":user_created=");
      let user_creation_status = document_url.substring(42, document_url.length);
      if(user_creation_status_index !== -1){
        if(user_creation_status === 'true'){
          overlay.displayUserCreationSuccessfulOverlay();
        } else if (user_creation_status === 'false') {
          customModal.notificationModalToggle("User creation failed!");
        }
      }
    }

    function deleteUserLinkClick(event){
      let target_user_id = $(event.target).attr('data-id');
      target_user_id = parseInt(target_user_id);
      let img_url = $(event.target).parents('tr[name=user_listing_' + target_user_id + ']').find('.thumbnail-wrapper').html();
      let first_name = $(event.target).parents('tr[name=user_listing_' + target_user_id + ']').find('td[name=first_name]').text();
      let last_name = $(event.target).parents('tr[name=user_listing_' + target_user_id + ']').find('td[name=last_name]').text();

      $(button_confirm_delete_user).attr('data-id', target_user_id);
      
      // Load the content of the overlay
      $(html_user_deletion_img).html(img_url);
      $(name_user_deletion).text(first_name + ' ' + last_name);
      overlay.displayUserDeletionConfirmationOverlay();
    }

    function deleteUser(event){
      let target_user_id = $(event.target).attr('data-id');
      target_user_id = parseInt(target_user_id);
      let delete_user_promise = new userModel.removeUserFromSystem(target_user_id);
      delete_user_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    }

    function checkUserEditStatus(){
      let user_edit_status_index = document_url.indexOf(":edit_user=");
      let user_edit_status = document_url.substring(39, document_url.length);
      if(user_edit_status_index !== -1){
        if(user_edit_status === 'true'){
          overlay.displayUserEditOverlay();
        } else if (user_edit_status === 'false') {
          customModal.notificationModalToggle("System error!");
        }
      }
    }

    function displayUserDetailsOverlay(){
      overlay.toggleUserDetailsOverlay(1);
    }

    // --------------------------------------
    // User Related Team Details and Settings
    // --------------------------------------

    function removeUserFromTeam(event){
      let okr_user_team_id = $(event.currentTarget).attr('data-id');
      okr_user_team_id = parseInt(okr_user_team_id);
      let remove_user_from_team_promise = new userModel.removeUserFromTeam(okr_user_team_id);
      remove_user_from_team_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    }


    $(document).ready(function(){
      
      // Display create new user overlay
      btnControl.resolveButtonClick(button_create_new_user, loadContentNewUserOverlay);
      btnControl.resolveButtonClick(button_create_another_user, loadContentNewUserOverlay);

      checkUserCreationStatus();

      btnControl.resolveButtonClick(link_delete_user, deleteUserLinkClick);
      btnControl.resolveButtonClick(button_confirm_delete_user, deleteUser);

      checkUserEditStatus();   

      // User Profile Section
      btnControl.resolveButtonClick(link_user_profile, displayUserDetailsOverlay); 

      // User removal from team
      btnControl.resolveButtonClick(button_remove_team_user, removeUserFromTeam);

    });

})