OBJECTS = {
	create: (opts) ->
		sunlight = OBJECTS.createSunlight()
		lights = [
			sunlight
			create('AmbientLight', CONF.SUN.COLOR, 3).with('name', 'ambient_light')
		]
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
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.turtle
					envMap: opts.envMap
				)
			).at(20, 0, 0)
				.scaled(10, 10, 10)
				.with('name', 'cube_shark1')
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.turtle
					envMap: opts.envMap
				)
			).at(20, 12, 0)
				.scaled(10, 10, 10)
				.with('name', 'cube_shark2')
				.with('physics', on)
				.with('physicsOpts', {
					mass: 0.4,
					#static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.turtle
					envMap: opts.envMap
				)
			).at(20, 34, 0)
				.scaled(10, 10, 10)
				.with('name', 'cube_shark3')
				.with('physics', on)
				.with('buoyant', true)
				.with('physicsOpts', {
					mass: 0.1,
					#static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.turtle
					envMap: opts.envMap
				)
			).at(20, 56, 0)
				.scaled(10, 10, 10)
				.with('name', 'cube_shark4')
				.with('buoyant', true)
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					#static: true,
					collisionShape: 'btBoxShape',
				})
		]
		console.assert(typeof(sunlight.target.position.x) == 'number' and not isNaN(sunlight.target.position.x),
			"sunlight.target.position = " +
			"#{sunlight.target.position.x}, #{sunlight.target.position.y}, #{sunlight.target.position.z}")
		{
			lights: lights
			objects: [
				lights...
				misc...
			]
			sunlight: sunlight
			player: createPlayer(createModel(
				geometry: cache.models.turtle
				material: create('MeshPhongMaterial',
					shininess: 20
					reflectivity: 0.4
					color: 0x222222
					specular: 0x111111
					map: cache.textures.turtle
					envMap: opts.envMap
				)
			)
				.at(-20, 5, 0)
				.scaled(3)
				.with('name', 'player')
				.with('buoyant', true)
				.with('physics', on)
				.with('physicsOpts', {
					lockedAxes: ['x', 'z']
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
