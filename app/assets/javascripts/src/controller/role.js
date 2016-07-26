// Date : 26 July 2016
// This JS file that acts as controller for the role module. 

require(['jquery','model/role','view/header'], function(jqueryParam,roleParam,headerParam){
    
    //Set the utility dropdown visible
    headerParam.utilityVisibility();

    // Obtain user role data from database
    const userRoleDataPromise = roleParam.getRolePromise();
    let userRoleName = "";
    userRoleDataPromise.then(response => {
        //Filter the role data and obtain the role name only
        userRoleName = JSON.parse(response);
        headerParam.roleDisplay(userRoleName["name"]);
    });
    
    //Check if the user is admin, if yes enter admin mode
    let adminFlag = false;
    if(userRoleName["name"] == "Admin")
    {
        adminFlag == true;
    }
    else
    {
        adminFlag == false;
    }

});