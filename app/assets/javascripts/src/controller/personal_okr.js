// Date : 25 August 2016
// This JS file that controls personal okr page only.

require(['pages/pages.blank','view/controls/popup','view/controls/slider'],
function(blankParam,popupParam,sliderParam){

    $(document).ready(function(){
        // Contribution popup for update progress
        popupParam.loadPopup();
        $('[data-toggle=\"search\"]').click(function(event){
            let temp_id = event.target.id;
            temp_id = temp_id.substring(temp_id.indexOf('_') + 1,temp_id.length);
            let key_result = $('#personal_key_result_' + temp_id).find('.checkbox-primary').find('label').text();
            let progress = $('#personal_key_result_' + temp_id).find('#personal_kr_progress_' + temp_id).text();
            progress = progress.substring(0,progress.indexOf('%'));
            // Call all the UI to display details related to the progress
            popupParam.setPopupKeyResult(key_result);
            sliderParam.contributionSliderControl(progress);
        });
    });
    
}); 

