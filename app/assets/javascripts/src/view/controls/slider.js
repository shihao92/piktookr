// Date : 25 August 2016
// JS File cater for slider control only.

define(['jquery'], function(){

    function contributionSliderControl()
    {
        // Contribution Popup Related Controls
        $(document).ready(function() {
        $("#slider-tooltips").noUiSlider({
                 start: 40,
                 direction: 'ltr',
                 behaviour: "drag",
                 connect: "lower",
                 range: {
                     'min': 0,
                     'max': 100
                 },
                 pips: {
	             	mode: 'values',
	             	values: [20, 80],
	             	density: 4
	             }
             })
             .on('change', function ( handle, value ) {
                if ( value < 40 ) {
                	$("#slider-tooltips").val(40);
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
            // $( "#slider-tooltips" ).noUiSlider.on('options', true /* Allow destruction + rebuilding */ );
        });
    }

    return {
        contributionSliderControl: contributionSliderControl
    }

})