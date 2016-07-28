// Date : 28 July 2016
// This JS file controls the content of dashboard page. 

define(function(){

    // Control the admin related content visibility
    function adminControl()
    {
        document.getElementById('adminRegister').style.display = "block";
    }

    return {
        adminControl: adminControl
    }

});
