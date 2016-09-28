// Date : 26 September 2016
// This JS file that communicates with database for timeframe module. 

define (['model/server_url'], function (urlParam) {

  function updateSystemTimeframeLogID(timeframe_log_id){
    return new Promise((resolve, reject) => {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if(this.readyState === 4 && this.status === 200) {
          resolve(this.responseText);
        }
        else if(this.readyState === 4 && this.status !== 200){
          reject("Error!");
        }
      };
      xhttp.open(
        "GET", 
        urlParam.server_url() + "/timeframes/" + timeframe_log_id + "/set_system_timeframe_log_id", 
        true
      );
      xhttp.send();
    });
  }

  return {
    updateSystemTimeframeLogID
  }

})