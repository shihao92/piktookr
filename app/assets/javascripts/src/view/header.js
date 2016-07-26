// Date : 22 July 2016
// This JS file controls the dashboard page. 

define(function () {
    
    // Control the user utility dropdown on header
    function utilityVisibility()
    {
        window.onload = function () {
            document.getElementById('userUtility').style.display = "block";
        }
    }
    
    //Control the user role display 
    function roleDisplay(role)
    {
        document.getElementById('userRole').innerHTML = role;
    }

    //Control the admin related controls visibility
    function adminRole()
    {
        
    }

    return {
        utilityVisibility: utilityVisibility,
        roleDisplay: roleDisplay
    }
});


