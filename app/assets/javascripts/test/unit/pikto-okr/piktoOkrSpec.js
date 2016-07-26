'use strict';

describe('', function() {

  var module;
  var dependencies;
  dependencies = [];

  var hasModule = function(module) {
  return dependencies.indexOf(module) >= 0;
  };

  beforeEach(function() {

  // Get module
  module = angular.module('piktoOkr');
  dependencies = module.requires;
  });

  it('should load config module', function() {
    expect(hasModule('piktoOkr.config')).to.be.ok;
  });

  

  
  it('should load directives module', function() {
    expect(hasModule('piktoOkr.directives')).to.be.ok;
  });
  

  

});