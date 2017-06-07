// Generated by IcedCoffeeScript 108.0.11
(function() {
  'use strict';
  window.l = console.log;

  window.createSunlightControls = function(sunlight) {
    return {
      update: function(delta) {
        var shift;
        shift = 1;
        if (Input.sunPitchLower) {
          l("pitch lower");
          sunlight.rotate(0, 0, -shift * delta);
        }
        if (Input.sunPitchRaise) {
          l("pitch raise");
          return sunlight.rotate(0, 0, shift * delta);
        }
      }
    };
  };

  window.createPhysicsControls = function(physics) {
    return window.addEventListener('keyup', function(e) {
      if (e.keyCode == CONF.CONTROLS.togglePhysics) {
        physics.enabled = !physics.enabled;
      }
      return true;
    });
  };

}).call(this);
