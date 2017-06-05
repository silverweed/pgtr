SCENE = {
	create: (opts) ->
		sunlight = create('DirectionalLight', CONF.SUN.COLOR, 12).at(-1000, 600, 1000)
				.then('rotateY', -2)
				.then('rotateZ', 0)
		sunlight.gizmo = createModel(
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshLambertMaterial'
				color: 0xffff00
				emissive: 0xffff00
			)
		)	.at(-50, 50, 50)
			.scaled(3)
			.then('rotateX', sunlight.rotation.x)
			.then('rotateY', sunlight.rotation.y)
			.then('rotateZ', sunlight.rotation.z)
		lights = [
			sunlight
			create('AmbientLight', CONF.SUN.COLOR, 3)
		]
		misc = [
			sunlight.gizmo
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshPhongMaterial',
					shininess: 30
					color: 0x000000
					specular: 0x999999
					envMap: opts.envMap
				)
			)	.scaled(10, 10, 10)
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					#static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.shark
					envMap: opts.envMap
				)
			).at(20, 0, 0)
				.scaled(10, 10, 10)
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
					map: cache.textures.shark
					envMap: opts.envMap
				)
			).at(20, 12, 0)
				.scaled(10, 10, 10)
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					#static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.shark
					envMap: opts.envMap
				)
			).at(20, 34, 0)
				.scaled(10, 10, 10)
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					#static: true,
					collisionShape: 'btBoxShape',
				})
			createModel(
				geometry: create('BoxGeometry', 1, 1, 1)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.shark
					envMap: opts.envMap
				)
			).at(20, 56, 0)
				.scaled(10, 10, 10)
				.with('physics', on)
				.with('physicsOpts', {
					mass: 1,
					#static: true,
					collisionShape: 'btBoxShape',
				})
		]
		{
			objects: [
				lights...
				misc...
			]
			sunlight: sunlight
			player: createPlayer(createModel(
				geometry: cache.models.shark
				material: create('MeshPhongMaterial',
					shininess: 20
					reflectivity: 0.4
					color: 0x222222
					specular: 0x111111
					map: cache.textures.shark
					envMap: opts.envMap
				)
			)
				.at(-20, 5, 0)
				.scaled(3)
				.with('physics', on)
				.with('physicsOpts', {
					lockedAxes: ['x', 'z']
				})
			)
		}
}


## Exports
window.SCENE = SCENE
