// Date : 7 September 2016
// This JS file that communicates with database for team objective module. 

define (['model/server_url'], function (urlParam) {

    function newTeamObjective(objective, company_key_result_id, team_id)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 4 && this.status !== 200){
            reject("Team Objective must have more than 5 characters!");
          }
        };
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/team/" + team_id + "/team_objectives", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          objective                : objective,
          company_key_result_id    : company_key_result_id,
          team_id                  : team_id
        }));
      });
    }

    function editTeamObjective(objective_id, edited_objective, original_objective, team_id)
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
          urlParam.server_url() + "/team/" + team_id + "/team_objectives/" + objective_id + "/edit_objective", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          id                       : objective_id,
          edited_objective         : edited_objective,
          original_objective       : original_objective
        }));           
      });
    }

    function getCreatedDate(team_id, objective_id)
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
          urlParam.server_url() + "/team/" + team_id + "/team_objectives/" + objective_id + "/get_created_date", 
          true
        );
        xhttp.send();           
      });
    }

    function getContribution(team_id, objective_id)
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
          urlParam.server_url() + "/team/" + team_id + "/team_objectives/" + objective_id + "/get_contribution", 
          true
        );
        xhttp.send();           
      });
    } 

    function searchObjective(keyword)
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
          urlParam.server_url() + "/team_objectives/search_objective", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          keyword                  : keyword
        }));
      });
    }

    return {
      newTeamObjective,
      editTeamObjective,
      getCreatedDate,
      getContribution,
      searchObjective
    }

})