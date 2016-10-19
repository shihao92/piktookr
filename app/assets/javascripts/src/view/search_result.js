// Date: 20 September 2016
// JS file to generate all search results HTML in the project.

define(['helper/avatar_finder'], function(avatarFinder){

  function generateSearchUserResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";

    while(counter < data_count){   
      temp_html = '<a href="/users/' + results_json[counter].id + '/personal_objectives/view_others_personal_okr" type="button" class="btn btn-default" style="max-width: 200px;">' +
                    '<div class="row p-t-5" style="padding-left: 50%;">' +
                      '<div class="thumbnail-wrapper d32 circular text-white">' +
                        '<img width="50" height="50" src="/system/users/avatars/000/000/' + avatarFinder.processAvatarURL(results_json[counter].id) + '/original/' + results_json[counter].avatar_file_name + '">' +
                      '</div>' +
                    '</div>' +
                    '<span class="m-b-5"><span class="semi-bold result-name">' + results_json[counter].last_name + ' ' + results_json[counter].first_name + '</span></h5>' +
                    '<p class="hint-text">' + results_json[counter].position + '</p>' +
                  '</a>';
      generated_html = temp_html + generated_html;
      counter = counter + 1;
    }
    generated_html = '<div class="btn-group">' + generated_html + '</div>';
    $(control_parent).html(generated_html);
  }

  function generateSearchTeamResults(results, control_parent){
    let results_json = JSON.parse(results);
    let data_count = results_json.length;
    let counter = 0;
    let generated_html = "";
    let temp_html = "";
    while(counter < data_count){
      temp_html = '<a href="/team/' + results_json[counter].id + '/team_objectives/team_dashboard" type="button" class="btn btn-default">' +
                    '<h5 class="m-b-5"><span class="semi-bold result-name">' + results_json[counter].name + '</span></h5>' +
                  '</a>';
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