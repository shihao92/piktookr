// Date : 26 July 2016
// This JS file that communicates with database for role module. 

// Declarations here
const serverURL = "http://localhost:3000";

define (function () {

    // Get role after user login 
    function getRolePromise()
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.onload = function() {
              if (xhttp.readyState == 4 && xhttp.status == 200) {
                resolve(xhttp.responseText);
              }
            };
            xhttp.open("GET", serverURL + "/app/check_role", true);
            xhttp.send();
        });
    }

    return {
        getRolePromise: getRolePromise
    };

});