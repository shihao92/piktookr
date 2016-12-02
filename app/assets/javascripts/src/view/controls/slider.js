// Date : 25 August 2016
// JS File cater for slider control only.

define(['plugins/jquery-nouislider/jquery.nouislider.min','plugins/jquery-nouislider/jquery.liblink'],
function(){

    function contributionSliderControl(current_progress)
    {
      // Contribution Popup Related Controls
      $("#contribution_sliders").noUiSlider({
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
        if ( value < current_progress ) 
        {
        	$("#contribution_sliders").val(current_progress);
        }
        else
        {
          // Enable the save button after the contribution is being filled in
          if($('#contribution_textarea').val() != "")
          {
            $('#btn_update_progress').prop( "disabled", false );
          }
          else
          {
            $('#contribution_textarea').change(function(){
              $('#btn_update_progress').prop( "disabled", false );
            });
          }
        }
      });
      $("#contribution_sliders").Link('lower').to('-inline-<div class="tooltip fade top in" style="top: -33px;left: -14px;opacity: 0.7;"></div>', function(value) {
        // The tooltip HTML is 'this', so additional
        // markup can be inserted here.
        $('#contribution_progress_update').text((value - current_progress).toFixed(2));
        $(this).html(
          '<div class="tooltip-inner">' +
            '<span id=\'slider-tooltip-inner\'>' + value + '</span>' +
          '</div>'
        );
      });
    }

    function recreateSlider(target){
      $(target).html('<div class="bg-master bg-complete-darker" id="contribution_sliders"></div>');
    }

    return {
      contributionSliderControl,
      recreateSlider
    }

})