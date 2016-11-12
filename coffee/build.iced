###
	Functions that build the scene
###

'use strict'

addAll = (scene, objects...) ->
	scene.add(obj) for obj in objects
	null

loadObjects = (scene, textures, models) ->
	null

asyncLoadSkybox = (urls, size, cb) ->
	l "Start loading sky"
	await create('CubeTextureLoader').load(urls, defer cubemap)
	cubemap.format = THREE.RGBFormat
	shader = THREE.ShaderLib.cube
	shader.uniforms.tCube.value = cubemap
	l "Loaded sky"
	cb(create('Mesh'
		create('BoxGeometry', size, size, size)
		create('ShaderMaterial',
			fragmentShader: shader.fragmentShader
			vertexShader: shader.vertexShader
			uniforms: shader.uniforms
			depthWrite: no
			side: THREE.BackSide
		)
	))

# Takes an empty Scene, fills it with the content and returns an object
# wrapping it along with its camera, renderer and clock
asyncBuildScene = (scene, cb) ->
	l "In buildScene(#{scene})"
	await
		asyncLoadTexturesAndModels(['shark'], ['shark'], defer(textures, models))
		asyncLoadSkybox(CONF.SKYBOX.URLS, CONF.SKYBOX.SIZE, defer sky)
	addAll(scene,
		sky
		create('DirectionalLight', 0xffffff, 4).at(1000, 1000, 1000)
			.then('rotateY', 20)
			.then('rotateZ', 30)
		create('DirectionalLight', 0xffffff, 5).at(-1000, -1000, 1000)
		createModel(
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshPhongMaterial',
				shininess: 20
				color: 0xffffff
				specular: 0x999999
				map: textures.shark
			)
		)
		createModel(
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshPhongMaterial',
				shininess: 3
				color: 0x44ff44
				specular: 0x222299
				map: textures.shark
			)
		).at(20, 0, 0)
		createModel(
			geometry: models.shark
			material: create('MeshPhongMaterial',
				shininess: 10
				color: 0x222222
				specular: 0x333333
				map: textures.shark
			)
		).at(-20, 0, 0).scaled(3)
	)
	camera = create('PerspectiveCamera', 60, windowRatio(), 1, 100000).at(0, 10, 25)
	create('OrbitControls', camera)
	cb(
		scene: scene
		camera: camera
		renderer: create('WebGLRenderer').then('setSize', window.innerWidth, window.innerHeight)
		clock: create('Clock')
	)


## Exports
window.asyncBuildScene = asyncBuildScene
