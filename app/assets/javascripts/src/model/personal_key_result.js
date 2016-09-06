// Date : 2 August 2016
// This JS file that communicates with database for team OKR module. 

// Declarations here
const serverURL = "http://localhost:3000"; 

define (function () {

    function newPersonalKeyResult(key_result, personal_objective_id)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.open(
                "POST", 
                serverURL + "/personal_key_results/create_new_key_result", 
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
                serverURL + "/personal_key_results/update_progress_key_result", 
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

    return {
        newPersonalKeyResult: newPersonalKeyResult,
        updatePersonalKeyResultProgress: updatePersonalKeyResultProgress
    }

})