// Generated by IcedCoffeeScript 108.0.11

/*
	The object holding the entities, useful for having them available globally
 */

(function() {
  'use strict';
  var Entities,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Entities = {
    "new": function(scene) {
      this.scene = scene;
      this.entities = {};
      return this;
    },
    add: function(name, e) {
      if (__indexOf.call(this.entities, name) >= 0) {
        destroy(name);
      }
      this.entities[name] = e;
      return this;
    },
    destroy: function(name) {
      this.scene.remove(this.entities[name]);
      return this;
    },
    get: function(name) {
      return this.entities[name];
    },
    player: function() {
      return this.entities['player'];
    }
  };

  window.Entities = Entities;

}).call(this);
