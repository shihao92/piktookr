// Date : 2 August 2016
// This JS file that communicates with database for personal_key_results module. 

define (['model/server_url'], function (urlParam) {

    function newPersonalKeyResult(key_result, personal_objective_id)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 4 && this.status !== 200){
            reject("Personal Key Result must have more than 5 characters!");
          }
        };
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/personal_key_results", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          key_result                : key_result,
          personal_objective_id     : personal_objective_id
        }));
      });
    }

    function updatePersonalKeyResultProgress(key_result_id, progress, initial_progress, contribution)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 4 && this.status !== 200){
            reject("Failed to update key result progress contribution!");
          }
        };
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/update_progress_key_result", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          id           : key_result_id,
          progress     : progress,
          initial      : initial_progress,
          contribution : contribution
        }));           
      });
    }

    function updatePersonalKeyResultStatus(key_result_id, is_completed)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 0 && this.status !== 200){
            reject("Failed to update personal key result completion status!");
          }
        };
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/update_key_result_status", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          id           : key_result_id,
          completed    : is_completed
        }));
      });
    }

    function editPersonalKeyResult(key_result_id, edited_key_result, original_key_result)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 0 && this.status !== 200){
            reject("Failed to update personal key result!");
          }
        };
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/edit_key_result", 
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

    function updateDueDate(key_result_id, due_date)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 0 && this.status !== 200){
            reject("Failed to update due date for personal key result!");
          }
        };
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/insert_due_date", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          id                        : key_result_id,
          due_date                  : due_date
        }));           
      });
    }

    function getContribution(key_result_id)
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
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/get_contribution", 
          true
        );
        xhttp.send();           
      });
    }

    function getCreatedDate(key_result_id)
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
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/get_created_date", 
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
            reject("Unable to get personal key result!");
          }
        };
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "POST", 
          urlParam.server_url() + "/personal_key_results/search_key_result", 
          true
        );
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.send(JSON.stringify({
          keyword: keyword
        }));           
      });
    }

    function getLinkedCompanyObjective(key_result_id)
    {
      return new Promise((resolve, reject) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if(this.readyState === 4 && this.status === 200) {
            resolve(this.responseText);
          }
          else if(this.readyState === 0 && this.status !== 200){
            reject("Unabled to get linked Company Objective!");
          }
        };
        // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
        xhttp.open(
          "GET", 
          urlParam.server_url() + "/personal_key_results/" + key_result_id + "/get_linked_company_objective", 
          true
        );
        xhttp.send();           
      });
    }

    return {
      newPersonalKeyResult,
      updatePersonalKeyResultProgress,
      updatePersonalKeyResultStatus,
      editPersonalKeyResult,
      updateDueDate,
      getContribution,
      getCreatedDate,
      searchKeyResult,
      getLinkedCompanyObjective
    }

})