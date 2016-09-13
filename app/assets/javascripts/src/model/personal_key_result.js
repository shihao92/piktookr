// Date : 2 August 2016
// This JS file that communicates with database for personal_key_results module. 

define (['model/server_url'], function (urlParam) {

    function newPersonalKeyResult(key_result, personal_objective_id)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/personal_key_results/create_new_key_result", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                'key_result'                : key_result,
                'personal_objective_id'     : personal_objective_id
            }));
        });
    }

    function updatePersonalKeyResultProgress(key_result_id, progress, initial_progress, contribution)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/personal_key_results/update_progress_key_result", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                'id'           : key_result_id,
                'progress'     : progress,
                'initial'      : initial_progress,
                'contribution' : contribution
            }));           
        });
    }

    function updatePersonalKeyResultStatus(key_result_id, is_completed)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
            xhttp.onload = function() {
              if (xhttp.readyState == 4 && xhttp.status == 200) {
                resolve(xhttp.responseText);
              }
            };
            xhttp.open(
                "GET", 
                urlParam.server_url() + "/personal_key_results/update_key_result_status/" + key_result_id + "&" + is_completed, 
                true
            );
            xhttp.send();
        });
    }

    function editPersonalKeyResult(key_result_id, edited_key_result, original_key_result)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/personal_key_results/edit_key_result", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                'id'                        : key_result_id,
                'edited_key_result'         : edited_key_result,
                'original_key_result'       : original_key_result
            }));           
        });
    }

    return {
        newPersonalKeyResult: newPersonalKeyResult,
        updatePersonalKeyResultProgress: updatePersonalKeyResultProgress,
        updatePersonalKeyResultStatus: updatePersonalKeyResultStatus,
        editPersonalKeyResult: editPersonalKeyResult
    }

})