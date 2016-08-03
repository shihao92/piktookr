// Date : 22 July 2016
// This JS file controls the header of all the pages. 

define(function () {
    
    // Control the user utility dropdown on header
    function utilityVisibility()
    {
        document.getElementById('user_utility').style.display = "block";
    }
    
    // Control the user role display 
    function roleDisplay(role)
    {
        document.getElementById('user_role').innerHTML = role;
    }

    // Control the admin related header controls visibility
    function adminControl()
    {
        
    }

    return {
        utilityVisibility: utilityVisibility,
        roleDisplay: roleDisplay,
        adminControl: adminControl
    }
});


