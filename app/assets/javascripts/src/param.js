// Declaration here
let serverURL = "localhost:3000";

define(function(){

    function returnServerURL()
    {
        return serverURL;
    }

    return {
        returnServerURL: returnServerURL
    };
});


