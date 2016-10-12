// Date : 12 October 2016
// This JS file that convert date format (yyyy-mm-dd) to MMMM dd.

define(function() {

  function formatConverter(input) {
    let underscore_index = input.indexOf('-');
    let month_str = input.substring(0, underscore_index);
    let month_int = parseInt(month_str);
    let month_string = monthRecognizer(month_int);
    let day_str = input.substring(underscore_index + 1, input.length);

    return month_string + ' ' + day_str;
  }

  function monthRecognizer(input) {
    let month = "";
    switch(input) {
      case 1: month = "Jan";
              break;
      case 2: month = "Feb";
              break;
      case 3: month = "Mac";
              break;
      case 4: month = "Apr";
              break;
      case 5: month = "May";
              break;
      case 6: month = "Jun";
              break;
      case 7: month = "Jul";
              break;
      case 8: month = "Aug";
              break;
      case 9: month = "Sep";
              break;
      case 10: month = "Oct";
               break;
      case 11: month = "Nov";
               break;
      case 12: month = "Dec";
               break;
    }
    return month;
  }

  return {
    formatConverter
  }

})