// Date: 25 August 2016
// JS File cater for no UI Slider control only.

define(['view/controls/slider', 'view/library/select2.min'],
function(sliderParam, select2LibraryParam){

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

        $('#overlay_create_new_user').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        }); 
        
        $('#overlay_user_profile').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        }); 

        $('#user_search_result').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });

        $('#overlay_new_role').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });

        $('#overlay_new_year_timeframe_setup').search({
            // Bind elements that are included inside search overlay
            searchField: '#overlay-search',
            closeButton: '.overlay-close',
            suggestions: '#overlay-suggestions',
            brand: '.brand'
        });

        $('#overlay_new_year_timeframe_setup').search({
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
          initial_progress_int = parseInt(initial_progress);
          // Save initial progress value
          $('#popup_initial_progress').text(initial_progress_int);
          $('#key_result_id').text(temp_id);       
        });
    }

    function loadNewPersonalObjectiveOverlayContent(){
      $('#new_objective_popup').attr('class','overlay');
      $('#new_objective_popup').attr('style','display: block;');
      $('#team_key_result_selection').select2();
      $('#company_key_result_selection').select2();
    }

    function loadNewUserOverlayContent(){
      $('#overlay_create_new_user').attr('class','overlay');
      $('#overlay_create_new_user').attr('style','display: block;');
      $('#role_role_id').select2();
    }

    function displayUserCreationSuccessfulOverlay(){
      $('#overlay_user_created_notification').attr('class','overlay');
    }

    function displayUserDeletionConfirmationOverlay(){
      $('#overlay_user_deletion').attr('class', 'overlay');
    }

    function displayUserEditOverlay(){
      $('#overlay_user_edit').attr('class', 'overlay');
    }

    function toggleUserDetailsOverlay(input){
      switch(input){
        case 0: $('#overlay_user_profile').attr('class', 'overlay hide');
                break;
        case 1: $('#overlay_user_profile').attr('class', 'overlay');
                $('#overlay_user_profile').attr('style', 'display: block;');
                break;
      }
    }

    function toggleOverlay(control_info, input){
      switch(input){
        case 0: $(control_info).attr('class', 'overlay hide');
                break;
        case 1: $(control_info).attr('class', 'overlay');
                $(control_info).attr('style', 'display: block;');
                break;
      }
    }
    
    return {
        loadOverlay,
        setOverlayKeyResult,
        clickProgressUpdateOverlay,
        loadNewPersonalObjectiveOverlayContent,
        loadNewUserOverlayContent,
        displayUserCreationSuccessfulOverlay,
        displayUserDeletionConfirmationOverlay,
        displayUserEditOverlay,
        toggleUserDetailsOverlay,
        toggleOverlay
    }

})