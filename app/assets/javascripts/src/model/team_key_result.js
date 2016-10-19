// Date : 7 September 2016
// This JS file that communicates with database for team key result module. 

define (['model/server_url'], function (urlParam) {

    function newTeamKeyResult(key_result, objective_id, team_id)
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
          urlParam.server_url() + "/team/" + team_id + "/team_key_results", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          key_result                : key_result,
          team_objective_id         : objective_id
        }));
      });
    }

    function editTeamKeyResult(key_result_id, edited_key_result, original_key_result, team_id)
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
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/team/" + team_id + "/team_key_results/" + key_result_id + "/edit_key_result", 
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

    function updateDueDate(team_id, key_result_id, due_date)
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
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/team/" + team_id + "/team_key_results/" + key_result_id + "/insert_due_date", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          id                        : key_result_id,
          due_date                  : due_date
        }));
      });
    }

    function getCreatedDate(team_id, key_result_id)
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
          "GET", 
          urlParam.server_url() + "/team/" + team_id + "/team_key_results/" + key_result_id + "/get_created_date", 
          true
        );
        xhttp.send();           
      });
    }

    function getContribution(team_id, key_result_id)
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
          "GET", 
          urlParam.server_url() + "/team/" + team_id + "/team_key_results/" + key_result_id + "/get_contribution", 
          true
        );
        xhttp.send();           
      });
    }

    function searchKeyResult(keyword)
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
          urlParam.server_url() + "/team_key_results/search_key_result", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          keyword: keyword
        }));           
      });
    }

    return {
      newTeamKeyResult,
      editTeamKeyResult,
      updateDueDate,
      getCreatedDate,
      getContribution,
      searchKeyResult
    }

})