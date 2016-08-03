// Date : 28 July 2016
// This JS file controls the content of dashboard page. 

define(function(){

    // Control the admin related content visibility
    function adminControl()
    {
        document.getElementById('admin_register').style.display = "block";
    }

    //Control the team lead related content visibility
    function teamLeadControl()
    {
        document.getElementById('team_lead_functions').style.display = "block";
    }

    return {
        adminControl: adminControl,
        teamLeadControl: teamLeadControl
    }

});
