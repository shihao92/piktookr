// Date : 9 November 2016
// JS file for side bar menu control only.

define(function(){

  function controlBorderVisibility(){
    $('body').mouseover(function(){
      let body_classes = $('body').attr('class');
      if(body_classes.indexOf('sidebar-visible') > 0){
        $('#sidebar-shortline').css('display', 'none');
        $('#sidebar-longline').css('display', 'block');
      } else {
        $('#sidebar-shortline').css('display', 'block');
        $('#sidebar-longline').css('display', 'none');
      }
    });
  }

  return {
    controlBorderVisibility
  }
})