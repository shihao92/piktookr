// Date : 24 September 2016
// This JS file that controls user creation only.

require(['model/user',
'view/controls/overlay', 'view/controls/button', 'view/controls/custom_modal'],
function(userModel, overlay, btnControl, customModal){

    const document_url = document.URL;
    const button_create_new_user = '#btn_create_new_user_overlay';
    const button_create_another_user = '#btn_create_another_user_overlay';
    const overlay_create_new_user = '#overlay_create_new_user';
    const link_delete_user = "a[name=link_delete_user]";
    const link_edit_user = "a[name=link_edit_user]";

    function loadContentNewUserOverlay(event){
      overlay.loadNewUserOverlayContent();
    }

    function checkUserCreationStatus(){
      let user_creation_status_index = document_url.indexOf(":user_created=");
      let user_creation_status = document_url.substring(42, document_url.length);
      if(user_creation_status === 'true'){
        overlay.displayUserCreationSuccessfulOverlay();
      } else if (user_creation_status === 'false') {
        customModal.notificationModalToggle("User creation failed!");
      }
    }

    function deleteUser(event){
      let target_user_id = $(event.target).attr('data-id');
      target_user_id = parseInt(target_user_id);
      let delete_user_promise = new userModel.removeUserFromSystem(target_user_id);
      delete_user_promise.then(customModal.notificationModalToggle, customModal.notificationModalToggle);
    }

    $(document).ready(function(){
      
      // Display create new user overlay
      btnControl.resolveButtonClick(button_create_new_user, loadContentNewUserOverlay);
      btnControl.resolveButtonClick(button_create_another_user, loadContentNewUserOverlay);

      checkUserCreationStatus();

      btnControl.resolveButtonClick(link_delete_user, deleteUser);

    });

})