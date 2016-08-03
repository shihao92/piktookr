// Date : 2 Aug 2016
// This JS file controls the team key result of all the pages. 

require(['jquery','model/role','model/team_objective_key_result','view/header','view/team_key_result'], 
function(jqueryParam,roleParam,teamOKRModelParam,headerParam,teamKeyResultViewParam){
    
    $(document).ready(function(){
        $('#team_team_id').change(function(){
            let teamSelection = document.getElementById('team_team_id');
            let teamId = teamSelection.options[teamSelection.selectedIndex].value;
            teamObjectiveSelection(teamId);
        });

        function teamObjectiveSelection(team_id)
        {
            let teamObjectivesDataPromise = teamOKRModelParam.getTeamObjectivesPromise(team_id);
            let teamObjectives = "";
            teamObjectivesDataPromise.then(response => {
                teamObjectives = JSON.parse(response);
                teamKeyResultViewParam.populateTeamObjectives(teamObjectives);
            });
        }
    });

});