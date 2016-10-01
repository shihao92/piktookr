// Date: 20 September 2016
// JS file to generate all search results HTML in the project.

define(['helper/avatar_finder'], function(avatarFinder){

  function generateSearchResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    while(counter < data_count){   
      temp_html =   '<div class="">' +
                      '<div class="thumbnail-wrapper d48 circular text-white inline m-t-10">' +
                        '<img width="50" height="50" src="/system/users/avatars/000/000/' + avatarFinder.processAvatarURL(results_json[counter].id) + '/original/' + results_json[counter].avatar_file_name + '">' +
                      '</div>' +
                      '<div class="p-l-10 inline p-t-5">' +
                        '<div class="col-md-10 col-sm-10">' +
                          '<h5 class="m-b-5"><span class="semi-bold result-name">' + results_json[counter].last_name + ' ' + results_json[counter].first_name + '</span></h5>' +
                          '<p class="hint-text">' + results_json[counter].position + '</p>' +
                        '</div>' +
                        '<div class="col-md-2 col-sm-2">' +
                          '<div class="pull-right p-t-15">' +
                            '<a href="/users/' + results_json[counter].id + '/personal_objectives/view_others_personal_okr" class="btn btn-complete btn-rounded">View Profile</a>' +
                          '</div>' +
                        '</div>' +
                      '</div>' +
                    '</div>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    $(control_parent).html(generated_html);
  }

  return {
    generateSearchResults
  }

})