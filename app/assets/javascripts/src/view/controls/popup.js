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

    function setPopupKeyResult(key_result,key_result_id)
    {
        $('#personal_key_result').text(key_result);
        $('.edit_personal_key_result').attr('id','edit_personal_key_result_' + key_result_id);
        $('.edit_personal_key_result').attr('action','/personal_key_results/' + key_result_id);
    }
    
    return {
        loadPopup: loadPopup,
        setPopupKeyResult: setPopupKeyResult
    }

})