// Date : 28 September 2016
// This JS file that communicates with database for user module. 

define (['model/server_url'], function (urlParam) {

  function checkNotificationsReadStatus(user_id){
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 0 && this.status !== 200){
          reject("Unable to obtain notifications from server!");
        }
      };
      // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
      xhttp.open(
        "GET", 
        urlParam.server_url() + "/users/" + user_id + "/notifications_read_status", 
        true
      );
      xhttp.send();
    })
  }

  function updateNotificationReadStatus(user_id, notification_id){
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 0 && this.status !== 200){
          reject("Error!");
        }
      };
      // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
      xhttp.open(
        "GET", 
        urlParam.server_url() + "/users/" + user_id + "/update_notification_read_status/" + notification_id, 
        true
      );
      xhttp.send();
    })
  }

  return {
    checkNotificationsReadStatus,
    updateNotificationReadStatus
  }

})