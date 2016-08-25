// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['view/controls/popup','view/controls/slider'],
function(popupParam,sliderParam){

    $(document).ready(function(){
        // Contribution popup for update progress
        popupParam.showPopup();
        sliderParam.contributionSliderControl();
    });
    
}); 

