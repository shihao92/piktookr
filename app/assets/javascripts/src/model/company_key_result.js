// Date : 12 September 2016
// This JS file that communicates with database for company key result module. 

define (['model/server_url'], function (urlParam) {

    function newCompanyKeyResult(key_result, objective_id)
    {
        return new Promise((resolve, reject) => {
            const xhttp = new XMLHttpRequest();
            xhttp.open(
                "POST", 
                urlParam.server_url() + "/company_key_results/create_new_key_result", 
                true
            );
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(JSON.stringify({
                'key_result'                : key_result,
                'company_objective_id'      : objective_id
            }));
        });
    }

    return {
        newCompanyKeyResult
    }

})