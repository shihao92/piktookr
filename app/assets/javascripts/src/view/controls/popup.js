// Date: 25 August 2016
// JS File cater for no UI Slider control only.

define(function(){

    // JQuery for the use of the pop up
    function loadPopup()
    {
        $('[data-pages="search"]').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });
    }

    function setPopupKeyResult(key_result)
    {
        $('#personal_key_result').text(key_result);
    }
    
    return {
        loadPopup: loadPopup,
        setPopupKeyResult: setPopupKeyResult
    }

})