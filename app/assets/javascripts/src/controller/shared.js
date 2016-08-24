// Date : 16 August 2016
// This JS file that centralize all JS files from template.

require(['promise', 'plugins/jquery/jquery-1.11.1.min', 
'plugins/ion-slider/js/ion.rangeSlider.min', 'plugins/jquery-nouislider/jquery.nouislider.min', 'plugins/jquery-nouislider/jquery.liblink',
'pages/pages.blank','view/contribution'],
function(promiseParam,jqueryParam,ionParam,noUISliderParam,liblinkParam,blankParam,contributionParam){

    $(document).ready(function(){
        contributionParam.showPopup();
        contributionParam.contributionSliderControl();
    });
    
}); 

