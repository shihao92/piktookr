/******/ (function(modules) { // webpackBootstrap
/******/ 	// install a JSONP callback for chunk loading
/******/ 	var parentJsonpFunction = window["webpackJsonp"];
/******/ 	window["webpackJsonp"] = function webpackJsonpCallback(chunkIds, moreModules) {
/******/ 		// add "moreModules" to the modules object,
/******/ 		// then flag all "chunkIds" as loaded and fire callback
/******/ 		var moduleId, chunkId, i = 0, callbacks = [];
/******/ 		for(;i < chunkIds.length; i++) {
/******/ 			chunkId = chunkIds[i];
/******/ 			if(installedChunks[chunkId])
/******/ 				callbacks.push.apply(callbacks, installedChunks[chunkId]);
/******/ 			installedChunks[chunkId] = 0;
/******/ 		}
/******/ 		for(moduleId in moreModules) {
/******/ 			modules[moduleId] = moreModules[moduleId];
/******/ 		}
/******/ 		if(parentJsonpFunction) parentJsonpFunction(chunkIds, moreModules);
/******/ 		while(callbacks.length)
/******/ 			callbacks.shift().call(null, __webpack_require__);

/******/ 	};

/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// object to store loaded and loading chunks
/******/ 	// "0" means "already loaded"
/******/ 	// Array means "loading", array contains callbacks
/******/ 	var installedChunks = {
/******/ 		2:0
/******/ 	};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}

/******/ 	// This file contains only the entry chunk.
/******/ 	// The chunk loading function for additional chunks
/******/ 	__webpack_require__.e = function requireEnsure(chunkId, callback) {
/******/ 		// "0" is the signal for "already loaded"
/******/ 		if(installedChunks[chunkId] === 0)
/******/ 			return callback.call(null, __webpack_require__);

/******/ 		// an array means "currently loading".
/******/ 		if(installedChunks[chunkId] !== undefined) {
/******/ 			installedChunks[chunkId].push(callback);
/******/ 		} else {
/******/ 			// start chunk loading
/******/ 			installedChunks[chunkId] = [callback];
/******/ 			var head = document.getElementsByTagName('head')[0];
/******/ 			var script = document.createElement('script');
/******/ 			script.type = 'text/javascript';
/******/ 			script.charset = 'utf-8';
/******/ 			script.async = true;

/******/ 			script.src = __webpack_require__.p + "" + chunkId + "." + ({}[chunkId]||chunkId) + "-webpack.js";
/******/ 			head.appendChild(script);
/******/ 		}
/******/ 	};

/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/dist/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	eval("// Date : 25 August 2016\n// This JS file that controls personal okr page only.\n\n__webpack_require__.e/* require */(3, function(__webpack_require__) { /* WEBPACK VAR INJECTION */(function($) {var __WEBPACK_AMD_REQUIRE_ARRAY__ = [__webpack_require__(7), __webpack_require__(8), __webpack_require__(9), __webpack_require__(10)]; (function (blankParam, personalKeyResultModelParam, popupParam, sliderParam) {\n\n    $(document).ready(function () {\n\n        // Contribution popup for update progress\n        popupParam.loadPopup();\n        $('[data-toggle=\\\"search\\\"]').click(function (event) {\n            // Store initial progress value\n            let initial_progress = 0;\n            let initial_progress_int = 0;\n\n            let temp_id = event.target.id;\n            temp_id = temp_id.substring(temp_id.indexOf('_') + 1, temp_id.length);\n            let key_result = $('#personal_key_result_' + temp_id).find('.checkbox-primary').find('label').text();\n            let progress = $('#personal_key_result_' + temp_id).find('#personal_kr_progress_' + temp_id).text();\n            progress = progress.substring(0, progress.indexOf('%'));\n\n            // Call all the UI to display details related to the progress\n            popupParam.setPopupKeyResult(key_result, temp_id);\n            sliderParam.contributionSliderControl(progress);\n            initial_progress = progress;\n            initial_progress_int = parseInt(initial_progress);\n            // Save initial progress value\n            $('#popup_initial_progress').text(initial_progress_int);\n            $('#key_result_id').text(temp_id);\n        });\n\n        // Key result - Create new  \n        $(\".add-new-personal-key-result\").on('focusout', '#new_key_result', function () {\n            if ($(this).find('.form-new-key-result').val() != '') {\n                // Find out the personal objective id\n                let current_focus_id = $(this).find('.form-new-key-result').attr('id');\n                let id_index = current_focus_id.indexOf('objective_');\n                let id_substring = current_focus_id.substring(id_index + 10, current_focus_id.length);\n                let temp_personal_key_result = $(this).find('.form-new-key-result').val();\n\n                personalKeyResultModelParam.newPersonalKeyResult(temp_personal_key_result, id_substring);\n\n                sessionStorage.reloadAfterPageLoad = true;\n                location.reload();\n            } else {\n                //do nothing\n            }\n        });\n        $(function () {\n            if (sessionStorage.reloadAfterPageLoad) {\n                alert(\"Personal Key Result created!\");\n                sessionStorage.reloadAfterPageLoad = false;\n            }\n        });\n\n        // Key result - Update progress\n        $('#btn_update_progress').click(function () {\n            let progress = $('#slider-tooltips').val();\n            let initial_progress = $('#popup_initial_progress').text();\n            let key_result_id = $('#key_result_id').text();\n            let contribution = $('#contribution_textarea').val();\n\n            // AJAX call to update the personal key result progress\n            personalKeyResultModelParam.updatePersonalKeyResultProgress(key_result_id, progress, initial_progress, contribution);\n\n            // $('#notification_message').text(\"Your personal key result is updated successfully!\");\n            // $('#notification_modal').modal('show'); \n\n            alert(\"Your personal key result is updated successfully!\");\n\n            location.reload();\n        });\n    });\n}.apply(null, __WEBPACK_AMD_REQUIRE_ARRAY__));\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(1)))});\n\n/*****************\n ** WEBPACK FOOTER\n ** /Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/controller/personal_okr.js\n ** module id = 0\n ** module chunks = 2\n **/\n//# sourceURL=webpack:////Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/controller/personal_okr.js?");

/***/ }
/******/ ]);