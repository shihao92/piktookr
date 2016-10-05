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

  function getCurrentQuarterEndDate(){
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
        urlParam.server_url() + "/timeframes/get_current_quarter_end_date", 
        true
      );
      xhttp.send();
    });
  }

  function checkNextYearLogPromise(){
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
        urlParam.server_url() + "/timeframes/is_next_year_log_presence", 
        true
      );
      xhttp.send();
    });
  }

  function createTimeframeLogPromise(year, type){
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
        "POST", 
        urlParam.server_url() + "/timeframes", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        year         : year,
        type         : type
      }));
    });
  }

  function removeTimeframe(timeframe_id){
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
        "POST", 
        urlParam.server_url() + "/timeframes/destroy_timeframe", 
        true
      );
      xhttp.setRequestHeader('Content-Type', 'application/json');
      xhttp.send(JSON.stringify({
        timeframe_id         : timeframe_id
      }));
    });
  }

  return {
    updateSystemTimeframeLogID,
    getCurrentQuarterEndDate,
    checkNextYearLogPromise,
    createTimeframeLogPromise,
    removeTimeframe
  }

})