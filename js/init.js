// Generated by IcedCoffeeScript 108.0.11
(function() {
  'use strict';
  var createDOM, iced, initWorld, requireWebgl, __iced_k, __iced_k_noop,
    __slice = [].slice;

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

  requireWebgl = function() {
    if (!Detector.webgl) {
      Detector.addGetWebGLMessage();
      return false;
    }
    return true;
  };

  createDOM = function() {
    var child, children, container, _i, _len;
    children = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    container = document.createElement('div');
    for (_i = 0, _len = children.length; _i < _len; _i++) {
      child = children[_i];
      container.appendChild(child);
    }
    document.body.appendChild(container);
    return container;
  };

  initWorld = function() {
    var world, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    l('Starting program');
    (function(_this) {
      return (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "/home/jacktommy/jack/inf/pgtr/proj/src/init.iced"
        });
        asyncBuildScene(__iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              return world = arguments[0];
            };
          })(),
          lineno: 18
        }));
        __iced_deferrals._fulfill();
      });
    })(this)((function(_this) {
      return function() {
        document.getElementById('loading-text').style.display = 'none';
        world.stats = createStats();
        world.debug = [createSunlightControls(world.objects.sunlight), createPhysicsControls(world.physics)];
        createDOM(world.renderer.domElement, world.stats.domElement);
        world.postprocess = postProcessInit(world.scene, world.camera, world.renderer);
        window.addEventListener('resize', resizeHandler(world.camera, world.controls, world.renderer));
        createPostProcessControls(world);
        world.updateBuoyancy = function(delta) {
          var depth, name, obj, x, _ref, _ref1, _ref2, _results;
          x = 0;
          _ref = world.entities.entities;
          _results = [];
          for (name in _ref) {
            obj = _ref[name];
            if (!((obj.rigidbody != null) && obj.buoyant)) {
              continue;
            }
            depth = CONF.PHYSICS.BUOYANCY_WATER_LEVEL - obj.position.y;
            x++;
            if (depth > 0) {
              obj.rigidbody.activate();
              _results.push(obj.rigidbody.applyCentralForce(new Ammo.btVector3(0, Math.pow(depth, 1.8) * ((_ref1 = (_ref2 = obj.physicsOpts) != null ? _ref2.mass : void 0) != null ? _ref1 : 1) * delta * CONF.PHYSICS.BUOYANCY, 0)));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
        return renderLoop(world);
      };
    })(this));
  };


  /* "Main" */

  if (!requireWebgl()) {
    return;
  }

  document.getElementById('ammojs').addEventListener('load', initWorld);

}).call(this);
