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
/******/ 		4:0
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

	eval("// Date : 26 July 2016\n// This JS file that acts as controller for the role module. \n\n__webpack_require__.e/* require */(5, function(__webpack_require__) { var __WEBPACK_AMD_REQUIRE_ARRAY__ = [__webpack_require__(3), __webpack_require__(5), __webpack_require__(14)]; (function (roleParam, headerParam, dashboardParam) {\n\n    //Set the utility dropdown visible\n    //headerParam.utilityVisibility();\n\n    // Obtain user role data from database\n    const userRoleDataPromise = roleParam.getRolePromise();\n    let userRoleName = \"\";\n    userRoleDataPromise.then(response => {\n        //Filter the role data and obtain the role name only\n        userRoleName = JSON.parse(response);\n        //headerParam.roleDisplay(userRoleName[\"name\"]);\n\n        //Check if the user is admin, if yes enter admin mode\n        if (userRoleName[\"name\"] == \"Admin\") {\n            //Activate all admin controls\n            //headerParam.adminControl();\n            dashboardParam.adminControl();\n            //Admin also able to view team lead controls\n            dashboardParam.teamLeadControl();\n        } else if (userRoleName[\"name\"] == \"Team Lead\") {\n            //Activate all team lead controls\n            dashboardParam.teamLeadControl();\n        }\n    });\n}.apply(null, __WEBPACK_AMD_REQUIRE_ARRAY__));});\n\n/*****************\n ** WEBPACK FOOTER\n ** /Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/controller/role.js\n ** module id = 0\n ** module chunks = 4\n **/\n//# sourceURL=webpack:////Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/controller/role.js?");

/***/ }
/******/ ]);