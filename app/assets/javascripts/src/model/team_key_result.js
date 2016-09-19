// Date : 7 September 2016
// This JS file that communicates with database for team key result module. 

define (['model/server_url'], function (urlParam) {

    function newTeamKeyResult(key_result, objective_id)
    {
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
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/team_key_results", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          key_result                : key_result,
          team_objective_id         : objective_id
        }));
      });
    }

    function editTeamKeyResult(key_result_id, edited_key_result, original_key_result)
    {
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
          "POST", 
          urlParam.server_url() + "/team_key_results/edit_key_result", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          id                        : key_result_id,
          edited_key_result         : edited_key_result,
          original_key_result       : original_key_result
        }));
      });
    }

    return {
      newTeamKeyResult,
      editTeamKeyResult
    }

})