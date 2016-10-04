// Date : 2 October 2016
// JS file for panel control only.

define([], function(){

  function togglePanelVisibility(panel_info, input){
    switch(input){
      case 0: $(panel_info).attr('style','display:none;');
              break;
      case 1: $(panel_info).attr('style', 'display:inherit;');
              break;
    }
  }

  return {
    togglePanelVisibility
  }

})