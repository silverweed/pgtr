SCENE = {
	create: (opts) ->
		sunlight = create('DirectionalLight', 0xffdf80, 12).at(-1000, 600, 1000)
				.then('rotateY', 0)
				.then('rotateZ', 0)
		lights = [
			sunlight
			create('DirectionalLight', 0xffd480, 2).at(-1000, -1000, 1000)
		]
		misc = [
			# Sunlight gizmo
			createModel(
				geometry: create('BoxGeometry', 10, 10, 10)
				material: opts.cubemat
			)	.at(-50, 50, 50)
				.scaled(5, 5, 5)
				.then('rotateX', sunlight.rotation.x)
				.then('rotateY', sunlight.rotation.y)
				.then('rotateZ', sunlight.rotation.z)
			createModel(
				geometry: create('BoxGeometry', 10, 10, 10)
				material: create('MeshPhongMaterial',
					shininess: 30
					color: 0x000000
					specular: 0x999999
					envMap: opts.envMap
				)
			)
			createModel(
				geometry: create('BoxGeometry', 10, 10, 10)
				material: create('MeshLambertMaterial',
					reflectivity: 0.2
					color: 0x44ff44
					map: cache.textures.shark
					envMap: opts.envMap
				)
			).at(20, 0, 0)
		]
		{
			objects: [
				lights...
				misc...
			]
		}
}


## Exports
window.SCENE = SCENE
