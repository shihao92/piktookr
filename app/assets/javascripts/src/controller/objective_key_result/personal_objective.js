// Date : 3 Aug 2016
// This JS file controls the personal objective of all the pages. 

require(['jquery','model/role','model/team_objective_key_result','view/header','view/personal_objective'],
function(jqueryParam,roleParam,teamOKRModelParam,headerParam,personalObjectiveViewParam){

    $(document).ready(function(){
        $('#team_team_id').change(function(){
            let teamSelection = document.getElementById('team_team_id');
            let teamId = teamSelection.options[teamSelection.selectedIndex].value;
            teamObjectiveSelections(teamId);
        });

        $('#team_objective_id').change(function(){
            let teamObjectiveSelection = document.getElementById('team_objective_id');
            let teamObjectiveId = teamObjectiveSelection.options[teamObjectiveSelection.selectedIndex].value;
            teamKeyResultSelections(teamObjectiveId);
        });

        function teamObjectiveSelections(team_id)
        {
            let teamObjectivesDataPromise = teamOKRModelParam.getTeamObjectivesPromise(team_id);
            let teamObjectives = "";
            teamObjectivesDataPromise.then(response => {
                // return with team objectives 
                teamObjectives = JSON.parse(response);
                // use the team objective to find all related team key results for the team consists of the user
                personalObjectiveViewParam.populateTeamObjectives(teamObjectives);

            });
        }

        function teamKeyResultSelections(team_objective_id)
        {
            let teamKeyResultsDataPromise = teamOKRModelParam.getTeamKeyResultsPromise(team_objective_id);
            let teamKeyResults = "";
            teamKeyResultsDataPromise.then(response => {
                // return with team key results
                teamKeyResults = JSON.parse(response);
                // populate the combo box with team key results to be aligned
                personalObjectiveViewParam.populateTeamKeyResults(teamKeyResults);
            });
        }
    });
   
});