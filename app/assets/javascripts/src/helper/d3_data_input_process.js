// Date : 20 September 2016
// This JS file that process the data before being feed into the d3 engine.

define(['helper/date_converter', 'view/d3_engine', 'view/controls/spin-progress'], function(dateHelper, d3_engine, spinProgress){

  const graph_progress_overtime = '#graph_progress_overtime';
  const timeline_progress_ring = "#timeline-progress-ring";

  function processCreatedDate(input){
    spinProgress.defineProgressSpin();
    created_date = input;
    let created_at_time_index = created_date.indexOf('T');
    let created_at_underscore_index = created_date.indexOf('-');

    created_date = created_date.substring(1, created_at_time_index);
    created_date = created_date.substring(created_at_underscore_index + 1, created_date.length);
    created_date = dateHelper.formatConverter(created_date);

    return created_date;
  }

  function processData(created_date, data){
    data = JSON.parse(data);
    let counter = 0;
    let x_axis = [];
    let y_axis = [];

    x_axis.push(created_date);
    y_axis.push(0);

    let previous_progress = 0.00;
    let current_progress = 0.00;

    while(counter < data.length) {
      let created_at_time_index = data[counter].created_at.indexOf('T');
      let created_at_underscore_index = data[counter].created_at.indexOf('-');
      let log_content_plus_index = data[counter].log_content.indexOf('+');
      let log_content_percentage_index = data[counter].log_content.indexOf('%');
      data[counter].created_at = data[counter].created_at.substring(0, created_at_time_index);
      data[counter].created_at = data[counter].created_at.substring(created_at_underscore_index + 1, (data[counter].created_at).length);
      data[counter].log_content = data[counter].log_content.substring(log_content_plus_index + 1, log_content_percentage_index);
      data[counter].log_content = parseFloat(data[counter].log_content);
      
      if(counter == 0) {
        previous_progress = data[counter].log_content;
      } else {
        data[counter].log_content = previous_progress + data[counter].log_content;
        previous_progress = data[counter].log_content;
      }

      data[counter].created_at = dateHelper.formatConverter(data[counter].created_at);

      x_axis.push(data[counter].created_at);
      y_axis.push(data[counter].log_content);
      
      counter = counter + 1;
    }
    
    drawGraph(x_axis, y_axis);
  }

  function drawGraph(x_axis, y_axis){
    d3_engine.generateSimpleLineGraph(graph_progress_overtime, x_axis, y_axis);
    $(timeline_progress_ring).attr('style', 'display: none;');
  }

  return {
    processCreatedDate,
    processData
  }

})