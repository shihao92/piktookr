// Date : 26 July 2016
// This JS file that communicates with database for role module. 

define (['model/server_url'], function (urlParam) {

    // Create new role
    function createNewRole(name, description)
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
          urlParam.server_url() + "/role", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          role_name          : name,
          description        : description
        }));
      });
    }

    // Create new control for the role
    function createRoleControl(okr_role_id, control_id)
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
          urlParam.server_url() + "/role/insert_new_role_control", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          okr_role_id           : okr_role_id,
          control_id            : control_id
        }));
      });
    }

    function removeRoleControl(okr_role_control_id)
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
          urlParam.server_url() + "/role/remove_role_control", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          okr_role_control_id           : okr_role_control_id
        }));
      });
    }

    return {
        createNewRole,
        createRoleControl,
        removeRoleControl
    };

});