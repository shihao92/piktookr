// Date : 24 September 2016
// This JS file that controls user creation only.

require(['model/user', 'model/notification', 'model/team',
'view/controls/overlay', 'view/controls/button', 'view/controls/custom_modal', 
'view/controls/input_textbox', 'view/controls/page_refresh', 'view/search_result'],
function(userModel, notificationModel, teamModel, overlay, btnControl, customModal, 
textboxControl, refreshPage, searchResult){

    const document_url = document.URL;
    const button_create_new_user = '#btn_create_new_user_overlay';
    const button_create_another_user = '#btn_create_another_user_overlay';
    const button_confirm_delete_user = '#btn_confirm_delete_user';
    const button_favourite_user = '#btn_fav_user';
    const button_remove_favourite_user = '#btn_remove_fav_user';
    const overlay_create_new_user = '#overlay_create_new_user';
    const link_delete_user = "a[name=link_delete_user]";
    const link_edit_user = "a[name=link_edit_user]";
    const html_user_deletion_img = "#img_deleting_user";
    const name_user_deletion = "#name_deleting_user";

    // Controls at Layout Page
    const link_user_profile = '#link_user_profile';
    const link_pending_team_invitation = 'a[name=link_pending_team_invitation]';
    const toggle_notifications = '#toggle_notifications';
    const bubble_new_notification = '#bubble_new_notification';
    const pending_notification = '.PENDING';
    const modal_team_invitation = '#team_invitation_modal';
    const button_accept_team_invite = '#btn_accept_team_invite';
    const overlay_search_user = '#user_search_result';
    const input_overlay_search_user = '#overlay_search_user_input';
    const div_search_users_results = '#div_search_users_results';

    // Controls at dashboard page
    const overlay_first_timer = '#overlay_first_timer';
    const overlay_first_timer_edit_profile = '#overlay_first_timer_edit_profile';
    const button_first_timer_edit_profile = '#btn_first_timer_edit_profile';

    // Controls at Team Settings Page
    const button_remove_team_user = 'button[name=btn_remove_team_user]';


    // -------------
    // Notifications
    // -------------

    function getNotificationsReadStatus(){
      let current_user_id = $(toggle_notifications).attr('data-id');
      let notification_status_promise = new notificationModel.checkNotificationsReadStatus(current_user_id);
      notification_status_promise.then(checkNotificationReadStatus, customModal.notificationModalToggle);
    }

    function checkNotificationReadStatus(reply){
      reply = parseInt(reply);
      if(reply === 0){
        $(bubble_new_notification).attr('style', 'display:none;');
      } else if (reply === 1) {
        $(bubble_new_notification).attr('style', 'display:inherit;');
      } 
    }

    function updateNotificationStatus(event){
      let unread_notification_count = $(pending_notification).length;
      let user_id = $(event.target).attr('data-id');
      if(unread_notification_count > 0){
        let counter = 0;
        $(bubble_new_notification).attr('style', 'display:none');
        while(counter < unread_notification_count){
          let notification_id = $(pending_notification).attr('data-id');
          $('[data-id=' + notification_id + ']').attr('class', 'alert-list READ');
          let index_underscore = notification_id.indexOf('_');
          let notification_int = notification_id.substring(index_underscore + 1, notification_id.length);
          notification_int = parseInt(notification_int);
          let update_notification_read_promise = new notificationModel.updateNotificationReadStatus(user_id, notification_int);
          counter = counter + 1;
        }      
      }
    }

    function acceptingTeamInvite(event){
      let notification_id = $(event.target).parents('.alert-list').attr('data-id');
      let index_underscore = notification_id.indexOf('_');
      let notification_int = notification_id.substring(index_underscore + 1, notification_id.length);
      notification_int = parseInt(notification_int);
      $(button_accept_team_invite).attr('data-id', notification_int);
    }

    function acceptTeamInvite(event){
      let notification_id = $(event.target).attr('data-id');
      let team_invite_accepted_promise = new teamModel.acceptIntoTeamPromise(notification_id);
      team_invite_accepted_promise.then(successAcceptionTeamInvitation, failedAcceptionTeamInvitation);
    }

    function successAcceptionTeamInvitation(message){
      $(modal_team_invitation).modal('hide');
      customModal.notificationModalToggle(message);
    }

    function failedAcceptionTeamInvitation(error){
      $(modal_team_invitation).modal('hide');
      customModal.notificationModalToggle(error);
    }

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

    function checkFirstTimeLogin(){
      let current_user_id = $(toggle_notifications).attr('data-id');
      let check_first_time_promise = new userModel.checkFirstTimeLogin(current_user_id);
      check_first_time_promise.then(isFirstTimeLogin, customModal.notificationModalToggle);
    }

    function isFirstTimeLogin(message){
      if(message === '1'){
        overlay.toggleOverlay(overlay_first_timer, 1);
      }
    }

    function firstTimerEditProfile(event){
      overlay.toggleOverlay(overlay_first_timer, 0);
      overlay.toggleOverlay(overlay_first_timer_edit_profile, 1);
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

    // ---------------------
    // User Favourite Module
    // ---------------------

    function addFavouriteUser(event){
      let fav_user_id = $(event.currentTarget).attr('data-id');
      let current_user_id = $(event.target).parents('.m-l-10').attr('data-id');
      let add_favourite_user_promise = new userModel.addFavouriteUser(current_user_id, fav_user_id);
      add_favourite_user_promise.then(addingFavouriteUser, customModal.notificationModalToggle);
    }

    function addingFavouriteUser(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    function removeFavouriteUser(event){
      let okr_user_fav_id = $(event.currentTarget).attr('data-id');
      let current_user_id = $(event.target).parents('.m-l-10').attr('data-id');
      let remove_favourite_user_promise = new userModel.removeFavouriteUser(current_user_id, okr_user_fav_id);
      remove_favourite_user_promise.then(removingFavouriteUser, customModal.notificationModalToggle);
    }

    function removingFavouriteUser(message){
      customModal.toggleProgressRingModal(0);
      refreshPage.refreshPage();
    }

    // ---------------------
    // User Searching Module
    // ---------------------

    function searchUser(event){
      overlay.toggleOverlay(overlay_search_user, 1);
    }

    function searchingUser(event){
      let key = event.which;
      if(key === 13){
        let search_keyword = $(input_overlay_search_user).val();
        let search_users_promise = new userModel.searchUsersLists(search_keyword);
        search_users_promise.then(obtainSearchResults, customModal.notificationModalToggle);
      }
    }

    function obtainSearchResults(results){
      customModal.toggleProgressRingModal(0);
      searchResult.generateSearchResults(results, div_search_users_results);
      customModal.toggleProgressRingModal(1);
    }


    $(document).ready(function(){
      
      checkFirstTimeLogin();
      btnControl.resolveButtonClick(button_first_timer_edit_profile, firstTimerEditProfile);

      // Search for user
      textboxControl.searchUser(searchUser);
      textboxControl.searchingUser(searchingUser);

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
         
      // Notifications related Section
      getNotificationsReadStatus();  

      // Update notification read status
      btnControl.resolveButtonClick(toggle_notifications, updateNotificationStatus);

      // When user try to accept team invitation
      btnControl.resolveButtonClick(link_pending_team_invitation, acceptingTeamInvite);
      // Accept team invite
      btnControl.resolveButtonClick(button_accept_team_invite, acceptTeamInvite);

      // User favourite module controls
      btnControl.resolveButtonClick(button_favourite_user, addFavouriteUser);
      btnControl.resolveButtonClick(button_remove_favourite_user, removeFavouriteUser);

    });

})