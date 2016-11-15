SCENE = {
	create: (opts) ->
		lights = [
			create('DirectionalLight', 0xffdf80, 10).at(1000, 1000, 1000)
				.then('rotateY', 70)
				.then('rotateZ', 30)
			create('DirectionalLight', 0xffd480, 2).at(-1000, -1000, 1000)
		]
		misc = [
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
