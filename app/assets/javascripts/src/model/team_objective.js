// Date : 7 September 2016
// This JS file that communicates with database for team objective module. 

define (['model/server_url'], function (urlParam) {

    function newTeamObjective(objective, company_key_result_id, team_id)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/team_objectives/create_new_objective", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                'objective'                : objective,
                'company_key_result_id'    : company_key_result_id,
                'team_id'                  : team_id
            }));
        });
    }

    function editTeamObjective(objective_id, edited_objective, original_objective)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            // WARNING : Decimal is not acceptable in the URL for rails as encoding will not work against it
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/team_objectives/edit_objective", 
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
        newTeamObjective,
        editTeamObjective
    }

})