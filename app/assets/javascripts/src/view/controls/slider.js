// Date : 25 August 2016
// JS File cater for slider control only.

define(['plugins/jquery-nouislider/jquery.nouislider.min','plugins/jquery-nouislider/jquery.liblink'],
function(){

    function contributionSliderControl(current_progress)
    {
        // Contribution Popup Related Controls
        $(document).ready(function() {
            $("#slider-tooltips").noUiSlider({
                 start: current_progress,
                 direction: 'ltr',
                 behaviour: "drag",
                 connect: "lower",
                 range: {
                     'min': 0,
                     'max': 100
                 },
                 pips: {
	             	mode: 'values',
	             	values: [0, 100],
	             	density: 4
	             }
             })
             .on('change', function ( handle, value ) {
                if ( value < current_progress ) {
                	$("#slider-tooltips").val(current_progress);
                }
              });
            $("#slider-tooltips").Link('lower').to('-inline-<div class="tooltip fade top in" style="top: -33px;left: -14px;opacity: 0.7;"></div>', function(value) {
                // The tooltip HTML is 'this', so additional
                // markup can be inserted here.
                $(this).html(
                    '<div class="tooltip-inner">' +
                    '<span id=\'slider-tooltip-inner\'>' + value + '</span>' +
                    '</div>'
                );
            });
        });
    }

    return {
        contributionSliderControl: contributionSliderControl
    }

})