// Date: 20 September 2016
// JS file to generate all search results HTML in the project.

define(['helper/avatar_finder', 'helper/capital_letter_finder', 'helper/random_color'], 
function(avatarFinder, capitalFinder, randomColor){

  function generateSearchUserResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";

    while(counter < data_count){   
      if(results_json[counter].avatar_file_name !== null) {
        temp_html = '<li class="m-t-20">' +
                      '<a href="/users/' + results_json[counter].id + '/personal_objectives/view_others_personal_okr" type="button">' +
                        '<span class="thumbnail-wrapper d48 circular inline m-r-10">' +
                          '<img src="/system/users/avatars/000/000/' + avatarFinder.processAvatarURL(results_json[counter].id) + '/original/' + results_json[counter].avatar_file_name + '">' +
                        '</span>' +
                        '<span class="search-title">' + results_json[counter].last_name + ' ' + results_json[counter].first_name + '</span>' +
                        '<p class="search-subtitle">' + results_json[counter].position + '</p>' +
                      '</a>' +
                    '</li>';
      } else {
        temp_html = '<li class="m-t-20">' +
                      '<a href="/users/' + results_json[counter].id + '/personal_objectives/view_others_personal_okr" type="button">' +
                        '<span class="thumbnail-wrapper d48 circular inline m-r-10">' +
                          '<img src="/searching-user.svg">' +
                        '</span>' +
                        '<span class="search-title">' + results_json[counter].last_name + ' ' + results_json[counter].first_name + '</span>' +
                        '<p class="search-subtitle">' + results_json[counter].position + '</p>' +
                      '</a>' +
                    '</li>';
      }
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    $(control_parent).html(generated_html);
  }

  function generateSearchTeamResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    while(counter < data_count){
      let team_name = results_json[counter][1];
      let capital_team_name = capitalFinder.findCapitalLetter(team_name);
      let gen_random_color = randomColor();
      temp_html = '<li class="m-t-20">' + 
                    '<a href="/team/' + results_json[counter][0] + '/team_objectives/team_dashboard" type="button">' + 
                      '<span class="thumbnail-wrapper d48 circular inline m-r-10 text-center" style="background: ' + gen_random_color + ';">' +
                        '<span class="search-shortform">' + capital_team_name[0] + '</span>' +
                      '</span>' +
                      '<span class="search-title">' + results_json[counter][1] + '</span>' + 
                      '<p class="search-subtitle">' + results_json[counter][2] + ' members</p>' + 
                    '</a>' +
                  '</li>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    $(control_parent).html(generated_html);
  }

  function generateSearchCompanyObjectiveResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    let panel_title = "Company Objectives";
    while(counter < data_count){
      temp_html = '<a href="/company_objectives/' + results_json[counter].id + '/details" type="button" class="btn btn-default">' +
                    '<p class="semi-bold">' + results_json[counter].objective + '</p>' +
                  '</a><br/>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="panel panel-default">' + 
                      '<div class="panel-heading bold">' +
                        panel_title +
                      '</div>' +
                      '<div class="panel-body">' +
                        generated_html + 
                      '</div>' +
                     '</div>';
    $(control_parent).html(generated_html);
  } 

  function generateSearchCompanyKRResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    let panel_title = "Company Key Results";
    while(counter < data_count){
      temp_html = '<a href="/company_key_results/' + results_json[counter].id + '/details" type="button" class="btn btn-default">' +
                    '<p class="semi-bold">' + results_json[counter].key_result + '</p>' +
                  '</a><br/>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="panel panel-default">' + 
                      '<div class="panel-heading bold">' +
                        panel_title +
                      '</div>' +
                      '<div class="panel-body">' +
                        generated_html + 
                      '</div>' +
                     '</div>';
    $(control_parent).html(generated_html);
  }

  function generateSearchTeamObjectiveResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    let panel_title = "Team Objectives";
    while(counter < data_count){
      temp_html = '<a href="/team/' + results_json[counter].okr_team_id + '/team_objectives/' + results_json[counter].id + '/details" type="button" class="btn btn-default">' +
                    '<p class="semi-bold">' + results_json[counter].objective + '</p>' +
                  '</a><br/>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="panel panel-default">' + 
                      '<div class="panel-heading bold">' +
                        panel_title +
                      '</div>' +
                      '<div class="panel-body">' +
                        generated_html + 
                      '</div>' +
                     '</div>';
    $(control_parent).html(generated_html);
  } 

  function generateSearchTeamKRResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    let panel_title = "Team Key Results";
    while(counter < data_count){
      temp_html = '<a href="/team/' + results_json[counter].okr_team_id + '/team_key_results/' + results_json[counter].id + '/details" type="button" class="btn btn-default">' +
                    '<p class="semi-bold">' + results_json[counter].key_result + '</p>' +
                  '</a><br/>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="panel panel-default">' + 
                      '<div class="panel-heading bold">' +
                        panel_title +
                      '</div>' +
                      '<div class="panel-body">' +
                        generated_html + 
                      '</div>' +
                     '</div>';
    $(control_parent).html(generated_html);
  }

  function generateSearchPersonalObjectiveResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    let panel_title = "Personal Objectives";
    while(counter < data_count){
      temp_html = '<a href="/personal_objectives/' + results_json[counter].id + '/details" type="button" class="btn btn-default">' +
                    '<p class="semi-bold">' + results_json[counter].objective + '</p>' +
                  '</a><br/>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="panel panel-default">' + 
                      '<div class="panel-heading bold">' +
                        panel_title +
                      '</div>' +
                      '<div class="panel-body">' +
                        generated_html + 
                      '</div>' +
                     '</div>';
    $(control_parent).html(generated_html);
  }

  function generateSearchPersonalKRResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    let panel_title = "Personal Key Results";
    while(counter < data_count){
      temp_html = '<a href="/personal_key_results/' + results_json[counter].id + '/details" type="button" class="btn btn-default">' +
                    '<p class="semi-bold">' + results_json[counter].key_result + '</p>' +
                  '</a><br/>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="panel panel-default">' + 
                      '<div class="panel-heading bold">' +
                        panel_title +
                      '</div>' +
                      '<div class="panel-body">' +
                        generated_html + 
                      '</div>' +
                     '</div>';
    $(control_parent).html(generated_html);
  }


  return {
    generateSearchUserResults,
    generateSearchTeamResults,
    generateSearchCompanyObjectiveResults,
    generateSearchCompanyKRResults,
    generateSearchTeamObjectiveResults,
    generateSearchTeamKRResults,
    generateSearchPersonalObjectiveResults,
    generateSearchPersonalKRResults
  }

})