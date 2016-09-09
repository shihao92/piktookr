// Date : 2 August 2016
// This JS file that communicates with database for team OKR module. 

define (['model/server_url'], function (urlParam) {

    // Get team objectives for the use of team key results alignment
    function getTeamObjectivesPromise(okr_team_id)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.onload = function() {
              if (xhttp.readyState == 4 && xhttp.status == 200) {
                resolve(xhttp.responseText);
              }
            };
            xhttp.open("GET", urlParam.server_url() + "/team_key_results/get_team_objective/" + okr_team_id, true);
            xhttp.send();
        });
    }

    function getTeamKeyResultsPromise(team_objective_id)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.onload = function() {
              if (xhttp.readyState == 4 && xhttp.status == 200) {
                resolve(xhttp.responseText);
              }
            };
            xhttp.open("GET", urlParam.server_url() + "/personal_objectives/get_team_key_results/" + team_objective_id, true);
            xhttp.send();
        });
    }

    return {
        getTeamObjectivesPromise: getTeamObjectivesPromise,
        getTeamKeyResultsPromise: getTeamKeyResultsPromise
    };

});