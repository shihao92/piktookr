// Date : 26 September 2016
// This JS file that communicates with database for team module. 

define (['model/server_url'], function (urlParam) {

  function newTeamPromise(team_name, team_description){
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
        urlParam.server_url() + "/team", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        name                : team_name,
        description         : team_description
      }));
    });
  }

  function deleteTeamPromise(team_id){
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
        urlParam.server_url() + "/team/" + team_id, 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        id     : team_id
      }));
    });
  }

  function getTeamInfoPromise(team_id){
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
        urlParam.server_url() + "/team/" + team_id + "/get_team_info", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        id    : team_id
      }));
    });
  }

  function updateTeamInfoPromise(team_id, team_name, team_description){
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
        "PUT", 
        urlParam.server_url() + "/team/" + team_id, 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        id            : team_id,
        name          : team_name,
        description   : team_description
      }));
    });
  }

  return {
    newTeamPromise,
    deleteTeamPromise,
    getTeamInfoPromise,
    updateTeamInfoPromise
  }

})