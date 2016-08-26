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

    function teamSelectionOnChange()
    {
        $('#team_team_id').change(function(){
            let teamSelection = document.getElementById('team_team_id');
            let teamId = teamSelection.options[teamSelection.selectedIndex].value;
            teamObjectiveSelections(teamId);
        });
    }

    function teamObjectiveSelectionOnChange()
    {
        $('#team_objective_id').change(function(){
            let teamObjectiveSelection = document.getElementById('team_objective_id');
            let teamObjectiveId = teamObjectiveSelection.options[teamObjectiveSelection.selectedIndex].value;
            teamKeyResultSelections(teamObjectiveId);
        });
    }

    return {
        populateTeamObjectives: populateTeamObjectives,
        populateTeamKeyResults: populateTeamKeyResults,
        teamSelectionOnChange: teamSelectionOnChange,
        teamObjectiveSelectionOnChange: teamObjectiveSelectionOnChange
    }

});