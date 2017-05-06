// Generated by IcedCoffeeScript 108.0.11

/*
	Functions dealing with loading stuff
 */

(function() {
  'use strict';
  var asyncLoadGeometry, asyncLoadOcean, asyncLoadPlayerPlane, asyncLoadSkybox, asyncLoadTexture, asyncLoadTexturesAndModels, cache, iced, modpath, texpath, __iced_k, __iced_k_noop,
    __slice = [].slice,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  iced = {
    Deferrals: (function() {
      function _Class(_arg) {
        this.continuation = _arg;
        this.count = 1;
        this.ret = null;
      }

      _Class.prototype._fulfill = function() {
        if (!--this.count) {
          return this.continuation(this.ret);
        }
      };

      _Class.prototype.defer = function(defer_params) {
        ++this.count;
        return (function(_this) {
          return function() {
            var inner_params, _ref;
            inner_params = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
            if (defer_params != null) {
              if ((_ref = defer_params.assign_fn) != null) {
                _ref.apply(null, inner_params);
              }
            }
            return _this._fulfill();
          };
        })(this);
      };

      return _Class;

    })(),
    findDeferral: function() {
      return null;
    },
    trampoline: function(_fn) {
      return _fn();
    }
  };
  __iced_k = __iced_k_noop = function() {};

  cache = {
    textures: {},
    models: {}
  };

  texpath = function(basename) {
    return "textures/" + basename + ".png";
  };

  modpath = function(basename) {
    return "models/" + basename + ".json";
  };

  asyncLoadTexture = function(name, cb) {
    var tex, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    (function(_this) {
      return (function(__iced_k) {
        if (__indexOf.call(cache.textures, name) < 0) {
          l("Loading texture " + (texpath(name)));
          (function(__iced_k) {
            __iced_deferrals = new iced.Deferrals(__iced_k, {
              parent: ___iced_passed_deferral,
              filename: "/home/jacktommy/jack/inf/pgtr/proj/src/load.iced"
            });
            create('TextureLoader').load(texpath(name), __iced_deferrals.defer({
              assign_fn: (function() {
                return function() {
                  return tex = arguments[0];
                };
              })(),
              lineno: 17
            }));
            __iced_deferrals._fulfill();
          })(function() {
            return __iced_k(cache.textures[name] = tex);
          });
        } else {
          return __iced_k();
        }
      });
    })(this)((function(_this) {
      return function() {
        return cb(cache.textures[name]);
      };
    })(this));
  };

  asyncLoadGeometry = function(name, cb) {
    var mod, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    (function(_this) {
      return (function(__iced_k) {
        if (__indexOf.call(cache.models, name) < 0) {
          l("Loading model " + (modpath(name)));
          (function(__iced_k) {
            __iced_deferrals = new iced.Deferrals(__iced_k, {
              parent: ___iced_passed_deferral,
              filename: "/home/jacktommy/jack/inf/pgtr/proj/src/load.iced"
            });
            create('JSONLoader').load(modpath(name), __iced_deferrals.defer({
              assign_fn: (function() {
                return function() {
                  return mod = arguments[0];
                };
              })(),
              lineno: 25
            }));
            __iced_deferrals._fulfill();
          })(function() {
            return __iced_k(cache.models[name] = mod);
          });
        } else {
          return __iced_k();
        }
      });
    })(this)((function(_this) {
      return function() {
        return cb(cache.models[name]);
      };
    })(this));
  };

  asyncLoadTexturesAndModels = function(textures, models, cb) {
    var mod, modname, tex, texname, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    tex = {};
    mod = {};
    l("Start loading textures and models");
    (function(_this) {
      return (function(__iced_k) {
        var _i, _j, _len, _len1;
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "/home/jacktommy/jack/inf/pgtr/proj/src/load.iced"
        });
        for (_i = 0, _len = textures.length; _i < _len; _i++) {
          texname = textures[_i];
          asyncLoadTexture(texname, __iced_deferrals.defer({
            assign_fn: (function(__slot_1, __slot_2) {
              return function() {
                return __slot_1[__slot_2] = arguments[0];
              };
            })(tex, texname),
            lineno: 37
          }));
        }
        for (_j = 0, _len1 = models.length; _j < _len1; _j++) {
          modname = models[_j];
          asyncLoadGeometry(modname, __iced_deferrals.defer({
            assign_fn: (function(__slot_1, __slot_2) {
              return function() {
                return __slot_1[__slot_2] = arguments[0];
              };
            })(mod, modname),
            lineno: 39
          }));
        }
        __iced_deferrals._fulfill();
      });
    })(this)((function(_this) {
      return function() {
        l("Loaded textures and models.");
        return cb(tex, mod);
      };
    })(this));
  };

  asyncLoadSkybox = function(urls, size, cb) {
    var cubemap, shader, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    l("Start loading sky");
    (function(_this) {
      return (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "/home/jacktommy/jack/inf/pgtr/proj/src/load.iced"
        });
        create('CubeTextureLoader').load(urls, __iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              return cubemap = arguments[0];
            };
          })(),
          lineno: 46
        }));
        __iced_deferrals._fulfill();
      });
    })(this)((function(_this) {
      return function() {
        cubemap.format = THREE.RGBFormat;
        shader = THREE.ShaderLib.cube;
        shader.uniforms.tCube.value = cubemap;
        l("Loaded sky");
        return cb(create('Mesh', create('BoxGeometry', size, size, size), create('ShaderMaterial', {
          fragmentShader: shader.fragmentShader,
          vertexShader: shader.vertexShader,
          uniforms: shader.uniforms,
          depthWrite: false,
          side: THREE.BackSide
        })), cubemap);
      };
    })(this));
  };

  asyncLoadOcean = function(waternormal_url, renderer, camera, scene, sunlight, cb) {
    var mirrorMesh, water, waternormal, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    (function(_this) {
      return (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "/home/jacktommy/jack/inf/pgtr/proj/src/load.iced"
        });
        create('TextureLoader').load(waternormal_url, __iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              return waternormal = arguments[0];
            };
          })(),
          lineno: 68
        }));
        __iced_deferrals._fulfill();
      });
    })(this)((function(_this) {
      return function() {
        waternormal.wrapS = waternormal.wrapT = THREE.RepeatWrapping;
        water = create('Water', renderer, camera, scene, {
          textureWidth: 512,
          textureHeight: 512,
          waterNormals: waternormal,
          alpha: 1.0,
          sunDirection: sunlight.position.clone().normalize(),
          sunColor: sunlight.color.getHex(),
          waterColor: 0x535b23,
          distortionScale: 50.0
        });
        mirrorMesh = create('Mesh', create('PlaneBufferGeometry', 10000, 10000), water.material).at(0, CONF.OCEAN.Y, 0).then('rotateX', -Math.PI / 2.0).add(water);
        return cb(water, mirrorMesh);
      };
    })(this));
  };

  asyncLoadPlayerPlane = function(waternormal_url, renderer, camera, scene, sunlight, cb) {
    var mirrorMesh, water, waternormal, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    (function(_this) {
      return (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "/home/jacktommy/jack/inf/pgtr/proj/src/load.iced"
        });
        create('TextureLoader').load(waternormal_url, __iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              return waternormal = arguments[0];
            };
          })(),
          lineno: 93
        }));
        __iced_deferrals._fulfill();
      });
    })(this)((function(_this) {
      return function() {
        waternormal.wrapS = waternormal.wrapT = THREE.RepeatWrapping;
        water = create('WaterRippled', renderer, camera, scene, {
          textureWidth: 512,
          textureHeight: 512,
          waterNormals: waternormal,
          alpha: 1.0,
          sunDirection: sunlight.position.clone().normalize(),
          sunColor: sunlight.color.getHex(),
          waterColor: 0x535b23,
          distortionScale: 50.0
        });
        mirrorMesh = create('Mesh', create('PlaneBufferGeometry', 300, 300, 1000, 1000), water.material).at(0, CONF.OCEAN.Y - 1, 0).then('rotateX', -Math.PI / 2.0).add(water);
        return cb(water, mirrorMesh);
      };
    })(this));
  };

  window.cache = cache;

  window.asyncLoadTexturesAndModels = asyncLoadTexturesAndModels;

  window.asyncLoadSkybox = asyncLoadSkybox;

  window.asyncLoadOcean = asyncLoadOcean;

  window.asyncLoadPlayerPlane = asyncLoadPlayerPlane;

}).call(this);
