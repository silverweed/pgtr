// Generated by IcedCoffeeScript 108.0.11

/*
	Constants and configuration
 */

(function() {
  'use strict';
  var CONF;

  CONF = {
    PLAYER: {
      SPEED: 100,
      JUMP_FORCE: 10
    },
    CONTROLS: {
      forward: [87],
      backward: [83],
      right: [68],
      left: [65],
      jump: [32],
      sunPitchRaise: [107],
      sunPitchLower: [109],
      togglePhysics: [80]
    },
    SKYBOX: {
      URLS: ['textures/skybox/px.jpg', 'textures/skybox/nx.jpg', 'textures/skybox/py.jpg', 'textures/skybox/ny.jpg', 'textures/skybox/pz.jpg', 'textures/skybox/nz.jpg'],
      SIZE: 10000
    },
    OCEAN: {
      URL: 'textures/waternormals.jpg',
      Y: 0
    },
    PHYSICS: {
      GRAVITY: -10,
      SUBSTEPS: 7,
      DFLT_LIN_DAMPING: 0.7,
      DFLT_ANG_DAMPING: 0.99999
    }
  };

  Object.freeze(CONF);

  window.CONF = CONF;

}).call(this);
