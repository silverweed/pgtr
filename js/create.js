// Generated by IcedCoffeeScript 108.0.11

/*
	Functions used to create objects
 */

(function() {
  'use strict';
  var create, createModel,
    __slice = [].slice;

  create = function() {
    var constr, obj, objname, opts;
    objname = arguments[0], opts = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    constr = THREE[objname];
    constr.prototype || (constr.prototype = {});
    constr.prototype.at = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      (_ref = this.position).set.apply(_ref, args);
      return this;
    };
    constr.prototype.scaled = function(scale) {
      this.scale.set(scale, scale, scale);
      return this;
    };
    constr.prototype.then = function() {
      var args, name;
      name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      l("Calling " + name + " on " + obj + " with args " + args);
      this[name].apply(this, args);
      return this;
    };
    obj = (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return Object(result) === result ? result : child;
    })(constr, opts, function(){});
    l("Created " + objname + " with params " + opts);
    return obj;
  };

  createModel = function(_arg) {
    var geometry, material;
    material = _arg.material, geometry = _arg.geometry;
    return create('Object3D').add(create('Mesh', geometry, material));
  };

  window.create = create;

  window.createModel = createModel;

}).call(this);
