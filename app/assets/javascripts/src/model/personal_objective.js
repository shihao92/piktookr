// Date : 7 September 2016
// This JS file that communicates with database for personal objective module. 
define(['model/server_url'], function(urlParam) {

    function newPersonalObjective(objective, team_key_result_id) {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/personal_objectives/create_new_objective", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                "objective"                 : objective,
                "team_key_result_id"        : parseInt(team_key_result_id)
            }));
        });
    }

    function editPersonalObjective(objective_id, edited_objective, original_objective)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/personal_objectives/edit_objective", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                'id'                       : objective_id,
                'edited_objective'         : edited_objective,
                'original_objective'       : original_objective
            }));           
        });
    } 

    return {
        newPersonalObjective,
        editPersonalObjective
    }

})