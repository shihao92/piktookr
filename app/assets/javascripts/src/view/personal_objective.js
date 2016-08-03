// Date : 2 Aug 2016
// This JS file controls the pages for the personal objective. 

define(function(){

    function populateTeamObjectives(team_objectives)
    {
        if(team_objectives == "")
        {
            document.getElementById('team_objective_id').innerHTML = "";
            let option = document.createElement("option");
            option.value = 0;
            option.innerHTML = "No objectives are presence in the team."
            document.getElementById('team_objective_id').appendChild(option);
            document.getElementsByName('commit')[0].disabled = true;
        }
        else
        {
            document.getElementsByName('commit')[0].disabled = false;
            document.getElementById('team_objective_id').innerHTML = "";
            for(element in team_objectives)
            {
                let option = document.createElement("option");
                option.value = team_objectives[element].id;
                option.innerHTML = team_objectives[element].objective;
                document.getElementById('team_objective_id').appendChild(option);
            }
        }
    }

    function populateTeamKeyResults(team_key_results)
    {
        if(team_key_results == "")
        {
            document.getElementById('team_key_result_id').innerHTML = "";
            let option = document.createElement('option');
            option.innerHTML = "No key results are presence for selected team objective."
            document.getElementById('team_key_result_id').appendChild(option);
            document.getElementsByName('commit')[0].disabled = true;
        }
        else
        {
            document.getElementsByName('commit')[0].disabled = false;
            document.getElementById('team_key_result_id').innerHTML = "";
            for(element in team_key_results)
            {
                let option = document.createElement("option");
                option.value = team_key_results[element].id;
                option.innerHTML = team_key_results[element].key_result;
                document.getElementById('team_key_result_id').appendChild(option);
            }
        }
    }

    return {
        populateTeamObjectives: populateTeamObjectives,
        populateTeamKeyResults: populateTeamKeyResults
    }

});