// Generated by IcedCoffeeScript 108.0.11
(function() {
  var OBJECTS,
    __slice = [].slice;

  OBJECTS = {
    create: function(opts) {
      var lights, misc, sunlight;
      sunlight = OBJECTS.createSunlight();
      lights = [sunlight, create('AmbientLight', CONF.SUN.COLOR, 3)["with"]('name', 'ambient_light')];
      misc = [
        sunlight.gizmo, sunlight.target, createModel({
          geometry: create('BoxGeometry', 1, 1, 1),
          material: create('MeshPhongMaterial', {
            shininess: 30,
            color: 0x000000,
            specular: 0x999999,
            envMap: opts.envMap
          })
        }).scaled(10, 100, 10)["with"]('name', 'cube_black1')["with"]('physics', true)["with"]('physicsOpts', {
          mass: 1,
          "static": true,
          collisionShape: 'btBoxShape'
        }), createModel({
          geometry: create('BoxGeometry', 1, 1, 1),
          material: create('MeshLambertMaterial', {
            reflectivity: 0.2,
            color: 0x44ff44,
            map: cache.textures.shark,
            envMap: opts.envMap
          })
        }).at(20, 0, 0).scaled(10, 10, 10)["with"]('name', 'cube_shark1')["with"]('physics', true)["with"]('physicsOpts', {
          mass: 1,
          "static": true,
          collisionShape: 'btBoxShape'
        }), createModel({
          geometry: create('BoxGeometry', 1, 1, 1),
          material: create('MeshLambertMaterial', {
            reflectivity: 0.2,
            color: 0x44ff44,
            map: cache.textures.shark,
            envMap: opts.envMap
          })
        }).at(20, 12, 0).scaled(10, 10, 10)["with"]('name', 'cube_shark2')["with"]('physics', true)["with"]('physicsOpts', {
          mass: 0.4,
          collisionShape: 'btBoxShape'
        }), createModel({
          geometry: create('BoxGeometry', 1, 1, 1),
          material: create('MeshLambertMaterial', {
            reflectivity: 0.2,
            color: 0x44ff44,
            map: cache.textures.shark,
            envMap: opts.envMap
          })
        }).at(20, 34, 0).scaled(10, 10, 10)["with"]('name', 'cube_shark3')["with"]('physics', true)["with"]('buoyant', true)["with"]('physicsOpts', {
          mass: 0.1,
          collisionShape: 'btBoxShape'
        }), createModel({
          geometry: create('BoxGeometry', 1, 1, 1),
          material: create('MeshLambertMaterial', {
            reflectivity: 0.2,
            color: 0x44ff44,
            map: cache.textures.shark,
            envMap: opts.envMap
          })
        }).at(20, 56, 0).scaled(10, 10, 10)["with"]('name', 'cube_shark4')["with"]('buoyant', true)["with"]('physics', true)["with"]('physicsOpts', {
          mass: 1,
          collisionShape: 'btBoxShape'
        })
      ];
      console.assert(typeof sunlight.target.position.x === 'number' && !isNaN(sunlight.target.position.x), "sunlight.target.position = " + ("" + sunlight.target.position.x + ", " + sunlight.target.position.y + ", " + sunlight.target.position.z));
      return {
        lights: lights,
        objects: __slice.call(lights).concat(__slice.call(misc)),
        sunlight: sunlight,
        player: createPlayer(createModel({
          geometry: cache.models.shark,
          material: create('MeshPhongMaterial', {
            shininess: 20,
            reflectivity: 0.4,
            color: 0x222222,
            specular: 0x111111,
            map: cache.textures.shark,
            envMap: opts.envMap
          })
        }).at(-20, 5, 0).scaled(3)["with"]('name', 'player')["with"]('buoyant', true)["with"]('physics', true)["with"]('physicsOpts', {
          lockedAxes: ['x', 'z']
        }))
      };
    },
    createSunlight: function() {
      var sunlight;
      sunlight = create('DirectionalLight', CONF.SUN.COLOR, 12).at(0, 0, 0).then('rotateY', -2).then('rotateZ', 0)["with"]('name', 'sunlight');
      sunlight.gizmo = createModel({
        geometry: create('BoxGeometry', 10, 10, 10),
        material: create('MeshLambertMaterial', {
          color: 0xffff00,
          emissive: 0xffff00
        })
      }).scaled(3);
      sunlight.gizmo.position = sunlight.position.clone().add((new THREE.Vector3(1, 0, 0)).multiplyScalar(200));
      sunlight._direction = [0, 0, 0];
      sunlight.target = sunlight.gizmo;
      sunlight.setDirection = function(ax, ay, az) {
        var v;
        v = new THREE.Vector3(Math.cos(ax) * Math.cos(az), Math.sin(ax) * Math.cos(az), Math.sin(az));
        l("v = " + v);
        l(sunlight.target.position);
        sunlight.target.position.set(sunlight.position.x + 200 * v.x, sunlight.position.y + 200 * v.y, sunlight.position.z + 200 * v.z);
        l("sunlight position = " + sunlight.target.position.x);
        return sunlight._direction = [ax, ay, az];
      };
      sunlight.rotate = function(ax, ay, az) {
        var x, y, z, _ref;
        _ref = sunlight._direction, x = _ref[0], y = _ref[1], z = _ref[2];
        return sunlight.setDirection(x + ax, y + ay, z + az);
      };
      return sunlight;
    }
  };

  window.OBJECTS = OBJECTS;

}).call(this);
