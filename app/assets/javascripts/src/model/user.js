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

  return {
    removeUserFromSystem,
    removeUserFromTeam
  }

})