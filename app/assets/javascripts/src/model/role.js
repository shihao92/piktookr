// Date : 26 July 2016
// This JS file that communicates with database for role module. 

define (['model/server_url'], function (urlParam) {

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
            xhttp.open("GET", urlParam.server_url() + "/app/check_role", true);
            xhttp.send();
        });
    }

    return {
        getRolePromise: getRolePromise
    };

});