
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
		barrelExtent = [10, 14, 10]
		misc = [
			sunlight.gizmo
			sunlight.targetGizmo
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshPhongMaterial',
					shininess: 30
					color: 0x000000
					specular: 0x999999
					envMap: opts.envMap
				)
			)	.scaled(10, 100, 10)
				.with('name', 'cube_black1')
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: cache.models.barrel
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x333333
					map: cache.textures.barrel
					envMap: opts.envMap
				)
			).at(20, 0, 0)
				.scaled(3)
				.with('name', 'cube_shark1')
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1
					static: true
					collisionShape: 'btCylinderShape'
					collisionShapeArgs: barrelExtent
				})
			createModel(
				geometry: cache.models.barrel
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x333333
					map: cache.textures.barrel
					envMap: opts.envMap
				)
			).at(20, 2*barrelExtent[1] + 1, 0)
				.scaled(3)
				.with('name', 'cube_shark2')
				.with('physics', on)
				.with('physicsOpts', {
					buoyant: yes
					mass: 0.4
					collisionShape: 'btCylinderShape'
					collisionShapeArgs: barrelExtent
				})
			createModel(
				geometry: cache.models.barrel
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x333333
					map: cache.textures.barrel
					envMap: opts.envMap
				)
			).at(20, barrelExtent[1]*4 + 2, 0)
				.scaled(3)
				.with('name', 'cube_shark3')
				.with('physics', on)
				.with('physicsOpts', {
					buoyant: yes
					mass: 0.1
					collisionShape: 'btCylinderShape'
					collisionShapeArgs: barrelExtent
				})
			createModel(
				geometry: cache.models.barrel
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x333333
					map: cache.textures.barrel
					envMap: opts.envMap
				)
			).at(20, barrelExtent[1]*6 + 3, 0)
				.scaled(3)
				.with('name', 'cube_shark4')
				.with('physics', on)
				.with('physicsOpts', {
					buoyant: yes
					mass: 1
					collisionShape: 'btCylinderShape'
					collisionShapeArgs: barrelExtent
				})
		]
		console.assert(typeof(sunlight.target.position.x) == 'number' and not isNaN(sunlight.target.position.x),
			"sunlight.target.position = " +
			"#{sunlight.target.position.x}, #{sunlight.target.position.y}, #{sunlight.target.position.z}")
		#THREE.Material.prototype.addToListAndReturn = undefined
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
						specular: {value: create('Vector4', 1.0, 0.0, 0.0, 1.0)}
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
					buoyancyOffset: 8
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
			l "sunlight position = #{sunlight.target.position.x}"
			sunlight._direction = [ax, ay, az]
			l "direction = #{sunlight._direction}"
		sunlight.rotate = (ax, ay, az) ->
			[x, y, z] = sunlight._direction
			sunlight.setDirection(x + ax, y + ay, z + az)
		sunlight
}


## Exports
window.OBJECTS = OBJECTS
