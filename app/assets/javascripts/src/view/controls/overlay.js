// Date: 25 August 2016
// JS File cater for no UI Slider control only.

define(['helper/int_converter', 'view/controls/slider', 'view/library/select2.min'],
function(intConverter, sliderParam, select2LibraryParam){

    // JQuery for the use of the pop up
    function loadOverlay()
    {
        // Initialization of new overlay
        $('[data-pages="search"]').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });

        $('#new_objective_popup').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });

        $('#teammate_list').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });       
    }

    function setOverlayKeyResult(key_result,key_result_id)
    {
        $('#personal_key_result').text(key_result);
        $('.edit_personal_key_result').attr('id','edit_personal_key_result_' + key_result_id);
        $('.edit_personal_key_result').attr('action','/personal_key_results/' + key_result_id);
    }

    function clickProgressUpdateOverlay()
    {
        $('[data-toggle=\"search\"]').click(function(event){
          // Store initial progress value
          let initial_progress = 0;
          let initial_progress_int = 0;  
          let temp_id = event.target.id;
          temp_id = temp_id.substring(temp_id.indexOf('_') + 1,temp_id.length);
          let key_result = $('#personal_key_result_' + temp_id).find('.checkbox-primary').find('label').text();
          let progress = $('#personal_key_result_' + temp_id).find('#personal_kr_progress_' + temp_id).text();
          progress = progress.substring(0,progress.indexOf('%'));  
          // Call all the UI to display details related to the progress
          setOverlayKeyResult(key_result,temp_id);
          sliderParam.contributionSliderControl(progress);
          initial_progress = progress;
          initial_progress_int = intConverter.convertToInt(initial_progress);
          // Save initial progress value
          $('#popup_initial_progress').text(initial_progress_int);
          $('#key_result_id').text(temp_id);       
        });
    }

    function loadNewPersonalObjectiveOverlayContent(){
      $('#new_objective_popup').attr('class','overlay');
      $('#team_key_result_selection').select2();
    }
    
    return {
        loadOverlay,
        setOverlayKeyResult,
        clickProgressUpdateOverlay,
        loadNewPersonalObjectiveOverlayContent
    }

})