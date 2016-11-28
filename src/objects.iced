SCENE = {
	create: (opts) ->
		sunlight = create('DirectionalLight', 0xffdf80, 12).at(-1000, 600, 1000)
				.then('rotateY', -2)
				.then('rotateZ', 0)
		sunlight.gizmo = createModel(
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshLambertMaterial'
				color: 0xffff00
				emissive: 0xffff00
			)
		)	.at(-50, 50, 50)
			.scaled(3, 3, 3)
			.then('rotateX', sunlight.rotation.x)
			.then('rotateY', sunlight.rotation.y)
			.then('rotateZ', sunlight.rotation.z)
		lights = [
			sunlight
			create('AmbientLight', 0xffdf80, 3)
		]
		misc = [
			sunlight.gizmo
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
			sunlight: sunlight
		}
}


## Exports
window.SCENE = SCENE
