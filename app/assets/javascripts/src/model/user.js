// Date : 26 September 2016
// This JS file that communicates with database for user module. 

define (['model/server_url'], function (urlParam) {

  function removeUserFromSystem(user_id)
  {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "DELETE", 
        urlParam.server_url() + "/users/" + user_id, 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        id    : user_id
      }));
    });
  }

  function removeUserFromTeam(okr_user_team_id)
  {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "POST", 
        urlParam.server_url() + "/team/remove_user_from_team", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        id    : okr_user_team_id
      }));
    });
  }

  function checkFirstTimeLogin(user_id)
  {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "GET", 
        urlParam.server_url() + "/users/" + user_id + "/check_first_time", 
        true
      );
      xhttp.send();
    });
  }

  function addFavouriteUser(user_id, fav_user_id)
  {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "POST", 
        urlParam.server_url() + "/users/" + user_id + "/favourite_user", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        fav_user_id    : fav_user_id
      }));
    });
  }

  function removeFavouriteUser(user_id, okr_user_fav_id)
  {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "POST", 
        urlParam.server_url() + "/users/" + user_id + "/remove_favourite_user", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        okr_user_fav_id    : okr_user_fav_id
      }));
    });
  }

  function searchUsersLists(keyword)
  {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "POST", 
        urlParam.server_url() + "/users/search_user_results", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        keyword    : keyword
      }));
    });
  }

  function insertFeedback(feedback) {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "POST", 
        urlParam.server_url() + "/users/insert_feedback", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        content    : feedback
      }));
    });
  }

  function removeFeedback(feedback_id) {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "DELETE", 
        urlParam.server_url() + "/feedbacks/" + feedback_id, 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        feedback_id    : feedback_id
      }));
    });
  }

  function updateStatusFeedback(feedback_id, status_id) {
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "POST", 
        urlParam.server_url() + "/feedbacks/update_status", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        id             : feedback_id,
        status_id      : status_id
      }));
    });
  }

  return {
    removeUserFromSystem,
    removeUserFromTeam,
    checkFirstTimeLogin,
    addFavouriteUser,
    removeFavouriteUser,
    searchUsersLists,
    insertFeedback,
    removeFeedback,
    updateStatusFeedback
  }

})