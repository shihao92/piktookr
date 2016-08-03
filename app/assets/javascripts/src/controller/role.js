// Date : 26 July 2016
// This JS file that acts as controller for the role module. 

require(['jquery','model/role','view/header','view/dashboard'], 
function(jqueryParam,roleParam,headerParam,dashboardParam){
    
    //Set the utility dropdown visible
    headerParam.utilityVisibility();

    // Obtain user role data from database
    const userRoleDataPromise = roleParam.getRolePromise();
    let userRoleName = "";
    userRoleDataPromise.then(response => {
        //Filter the role data and obtain the role name only
        userRoleName = JSON.parse(response);
        headerParam.roleDisplay(userRoleName["name"]);
        
        //Check if the user is admin, if yes enter admin mode
        if(userRoleName["name"] == "Admin")
        {
            //Activate all admin controls
            headerParam.adminControl();
            dashboardParam.adminControl();
            //Admin also able to view team lead controls
            dashboardParam.teamLeadControl();
        }
        else if(userRoleName["name"] == "Team Lead")
        {
            //Activate all team lead controls
            dashboardParam.teamLeadControl();
        }
    });
    
   
    
    

});