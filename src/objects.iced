
OBJECTS = {
	create: (opts) ->
		toonShadedMats = []
		THREE.Material.prototype.addToListAndReturn = (list) ->
			list.push(this)
			this
		
		sunlight = OBJECTS.createSunlight()
		lights = [
			sunlight
			create('AmbientLight', CONF.SUN.COLOR, 3).with('name', 'ambient_light')
		]
		barrelMaterial = create("ShaderMaterial",
			uniforms: {
				directionalLightColor:{value: create('Vector4', 1.0,0.0,1.0,1.0)},
				directionalLightDirection:{value:create('Vector3', sunlight._direction...)},
				directionalLightIntensity:{value: 1.0},
				ambientColor:{value: create("Vector4",0.2,0.1,0.1,1.0)},
				ambientIntensity:{value: 0.1},
				shininess: {value:20}
				reflectivity:{value: 0.4}
				color: {value: create('Vector4', 1.0, 1.0, 1.0, 1.0)}
				specular: {value: create('Vector4', 1.0, 1.0, 0.2, 1.0)}
				nBands: {value:3}
				map: {value: cache.textures.barrel}
			},
			vertexShader:window.cache.shaders["toonshading.vert"],
			fragmentShader: window.cache.shaders["toonshading.frag"]
		).addToListAndReturn(toonShadedMats)

		iBarrel = 1
		barrelExtent = [12, 14, 12]
		createBarrel = ->
			createModel(
				geometry: cache.models.barrel
				material: barrelMaterial
			)	.scaled(3)
				.with('name', "barrel#{iBarrel++}")
				.with('physics', on)
				.with('physicsOpts', {
					buoyant: yes
					mass: 1
					collisionShape: 'btCylinderShape'
					collisionShapeArgs: barrelExtent
				})
		createBarrels = (n) ->
			for i in [0..n]
				createBarrel()
					.at((nextRand() - 0.5) * 5000, 0, (nextRand() - 0.5) * 5000)
					.then('rotateX', nextRand() * Math.PI * 2)
					.then('rotateY', nextRand() * Math.PI * 2)
					.then('rotateZ', nextRand() * Math.PI * 2)
		_static = (obj) ->
			obj.physicsOpts.static = yes
			obj

		createBarrelPyramid = (base, x, z) ->
			barrels = []
			for i in [0..base]
				barrels.push(_static(createBarrel().at(x, 0, z + 2 * barrelExtent[2] * i + i)))
			for i in [0..base-1]
				for j in [0..base-i-1]
					barrels.push(
						createBarrel().at(
							x,
							barrelExtent[1] * 2 * (i+1) + (i+1),
							z + barrelExtent[2] * (i+1 + 2 * j)))
			barrels
		misc = [
			sunlight.gizmo
			sunlight.targetGizmo
			_static createBarrel().at(20, 0, 0)
			createBarrel().at(20, 2*barrelExtent[1] + 1, 0)
			createBarrel().at(20, barrelExtent[1]*4 + 2, 0)
			createBarrel().at(20, barrelExtent[1]*6 + 3, 0)
			createBarrels(50)...
			createBarrelPyramid(10, 50, 50)...
		]
		console.assert(typeof(sunlight.target.position.x) == 'number' and not isNaN(sunlight.target.position.x),
			"sunlight.target.position = " +
			"#{sunlight.target.position.x}, #{sunlight.target.position.y}, #{sunlight.target.position.z}")
		return {
			ambientLight:{
					ambientIntensity: 0.1,
					ambientColor:create("Vector4", 1.0,0.5,0.0,1.0)
				},
			lights: lights
			objects: [
				lights...
				misc...
			]
			sunlight: sunlight
			toonShadedMats: toonShadedMats,
			player: createPlayer(createModel(
				geometry: cache.models.turtle
				material: create('ShaderMaterial',
					uniforms: {
						directionalLightColor:{value: create('Vector4', 1.0,0.0,1.0,1.0)},
						directionalLightDirection:{value:create('Vector3', sunlight._direction...)},
						directionalLightIntensity:{value: 1.0},
						ambientColor:{value: create("Vector4",0.2,0.1,0.1,1.0)},
						ambientIntensity:{value: 0.1},
						shininess: {value:20}
						reflectivity:{value: 0.4}
						color: {value: create('Vector4', 0.13, 0.13, 0.13, 1.0)}
						specular: {value: create('Vector4', 1.0, 1.0, 0.0, 1.0)}
						nBands: {value:4}
						map: {value: cache.textures.turtle}
						#envMap: opts.envMap
					},
					vertexShader:window.cache.shaders["toonshading.vert"],
					fragmentShader: window.cache.shaders["toonshading.frag"]
				).addToListAndReturn(toonShadedMats)
			)
				.at(-20, 5, 0)
				.scaled(3)
				.with('name', 'player')
				.with('physics', on)
				.with('physicsOpts', {
					buoyant: yes
					lockedAxes: ['x', 'z']
					mass: 10
					collisionShape: 'btSphereShape'
					collisionShapeArgs: 5
					#buoyancyOffset: 8
				})
			)
		}

	createSunlight: ->
		sunlight = create('DirectionalLight', CONF.SUN.COLOR, 12).at(0, 100, 0)
				.then('rotateY', -2)
				.then('rotateZ', 0)
				.with('name', 'sunlight')
		sunlight.targetGizmo = createModel(
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshLambertMaterial'
				color: 0xffff00
				emissive: 0xffff00
			)
		).scaled(3)
		sunlight.intensity = 1.0
		sunlight.gizmo = createModel(
			geometry: create('SphereGeometry', 10)
			material: create('MeshLambertMaterial'
				color: 0xffff00
				emissive: 0xffff00
			)
		)
		sp = sunlight.position
		sunlight.gizmo.position.set(sp.x, sp.y, sp.z)
		sunlight.targetGizmo.position.set(sp.x, sp.y, sp.z)
			.add((new THREE.Vector3(1, 0, 0)).normalize().multiplyScalar(200))
		sunlight._direction = [0, 0, 0]
		sunlight.target = sunlight.targetGizmo
		sunlight.setDirection = (ax, ay, az) ->
			v = new THREE.Vector3(
				Math.cos(ax) * Math.cos(az)
				Math.sin(ax) * Math.cos(az)
				Math.sin(az)
			)
			sunlight.target.position.set(
				sunlight.position.x + 200 * v.x
				sunlight.position.y + 200 * v.y
				sunlight.position.z + 200 * v.z
			)
			#l "sunlight position = #{sunlight.target.position.x}"
			sunlight._direction = [ax, ay, az]
			#l "direction = #{sunlight._direction}"
		sunlight.rotate = (ax, ay, az) ->
			[x, y, z] = sunlight._direction
			sunlight.setDirection(x + ax, y + ay, z + az)
		sunlight
}


## Exports
window.OBJECTS = OBJECTS
