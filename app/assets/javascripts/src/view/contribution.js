define(['jquery'], function(){

    // JQuery for the use of the pop up
    function showPopup()
    {
        $('[data-pages="search"]').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand',
             // Callback that will be run when you hit ENTER button on search box
            onSearchSubmit: function(searchString) {
                console.log("Search for: " + searchString);
            },
            // Callback that will be run whenever you enter a key into search box. 
            // Perform any live search here.  
            onKeyEnter: function(searchString) {
                console.log("Live search for: " + searchString);
                var searchField = $('#overlay-search');
                var searchResults = $('.search-results');

                /* 
                    Do AJAX call here to get search results
                    and update DOM and use the following block 
                    'searchResults.find('.result-name').each(function() {...}'
                    inside the AJAX callback to update the DOM
                */

                // Timeout is used for DEMO purpose only to simulate an AJAX call
                clearTimeout($.data(this, 'timer'));
                searchResults.fadeOut("fast"); // hide previously returned results until server returns new results
                var wait = setTimeout(function() {

                    searchResults.find('.result-name').each(function() {
                        if (searchField.val().length != 0) {
                            $(this).html(searchField.val());
                            searchResults.fadeIn("fast"); // reveal updated results
                        }
                    });
                }, 500);
                $(this).data('timer', wait);

            }
        });
    }
    
    function contributionSliderControl()
    {
        // Contribution Popup Related Controls
        $('#contribution_popup').ready(function() {
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
        });
    }
    
    return {
        showPopup: showPopup,
        contributionSliderControl: contributionSliderControl
    }

})