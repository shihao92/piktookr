webpackJsonp([5],{

/***/ 3:
/***/ function(module, exports, __webpack_require__) {

	eval("var __WEBPACK_AMD_DEFINE_RESULT__;// Date : 26 July 2016\n// This JS file that communicates with database for role module. \n\n// Declarations here\nconst serverURL = \"http://localhost:3000\";\n\n!(__WEBPACK_AMD_DEFINE_RESULT__ = function () {\n\n    // Get role after user login \n    function getRolePromise() {\n        return new Promise((resolve, reject) => {\n            const xhttp = new XMLHttpRequest();\n            xhttp.onload = function () {\n                if (xhttp.readyState == 4 && xhttp.status == 200) {\n                    resolve(xhttp.responseText);\n                }\n            };\n            xhttp.open(\"GET\", serverURL + \"/app/check_role\", true);\n            xhttp.send();\n        });\n    }\n\n    return {\n        getRolePromise: getRolePromise\n    };\n}.call(exports, __webpack_require__, exports, module), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));\n\n/*****************\n ** WEBPACK FOOTER\n ** /Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/model/role.js\n ** module id = 3\n ** module chunks = 1 5 7\n **/\n//# sourceURL=webpack:////Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/model/role.js?");

/***/ },

/***/ 5:
/***/ function(module, exports, __webpack_require__) {

	eval("var __WEBPACK_AMD_DEFINE_RESULT__;// Date : 22 July 2016\n// This JS file controls the header of all the pages. \n\n!(__WEBPACK_AMD_DEFINE_RESULT__ = function () {\n\n    // Control the user utility dropdown on header\n    function utilityVisibility() {\n        document.getElementById('user_utility').style.display = \"block\";\n    }\n\n    // Control the user role display \n    function roleDisplay(role) {\n        document.getElementById('user_role').innerHTML = role;\n    }\n\n    // Control the admin related header controls visibility\n    function adminControl() {}\n\n    return {\n        utilityVisibility: utilityVisibility,\n        roleDisplay: roleDisplay,\n        adminControl: adminControl\n    };\n}.call(exports, __webpack_require__, exports, module), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));\n\n/*****************\n ** WEBPACK FOOTER\n ** /Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/view/header.js\n ** module id = 5\n ** module chunks = 1 5 7\n **/\n//# sourceURL=webpack:////Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/view/header.js?");

/***/ },

/***/ 14:
/***/ function(module, exports, __webpack_require__) {

	eval("var __WEBPACK_AMD_DEFINE_RESULT__;// Date : 28 July 2016\n// This JS file controls the content of dashboard page. \n\n!(__WEBPACK_AMD_DEFINE_RESULT__ = function () {\n\n    // Control the admin related content visibility\n    function adminControl() {\n        document.getElementById('admin_register').style.display = \"block\";\n    }\n\n    //Control the team lead related content visibility\n    function teamLeadControl() {\n        document.getElementById('team_lead_functions').style.display = \"block\";\n    }\n\n    return {\n        adminControl: adminControl,\n        teamLeadControl: teamLeadControl\n    };\n}.call(exports, __webpack_require__, exports, module), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));\n\n/*****************\n ** WEBPACK FOOTER\n ** /Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/view/dashboard.js\n ** module id = 14\n ** module chunks = 5\n **/\n//# sourceURL=webpack:////Users/piktochart/Desktop/PiktoChart_Works/project/PiktoOKR/app/assets/javascripts/src/view/dashboard.js?");

/***/ }

});