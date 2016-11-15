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
	cb(
		# Sky mesh
		create('Mesh'
			create('BoxGeometry', size, size, size)
			create('ShaderMaterial',
				fragmentShader: shader.fragmentShader
				vertexShader: shader.vertexShader
				uniforms: shader.uniforms
				depthWrite: no
				side: THREE.BackSide
			)
		)
		# Reflection cubemap
		cubemap
	)

# Takes an empty Scene, fills it with the content and returns an object
# wrapping it along with its camera, renderer and clock
asyncBuildScene = (scene, cb) ->
	l "In buildScene(#{scene})"
	await
		asyncLoadTexturesAndModels(['shark'], ['shark'], defer(textures, models))
		asyncLoadSkybox(CONF.SKYBOX.URLS, CONF.SKYBOX.SIZE, defer sky, cubemap)

	entities = Entities.new(scene)
	# Create the player
	entities.add('player', createPlayer(
		createModel(
			geometry: models.shark
			material: create('MeshPhongMaterial',
				shininess: 20
				reflectivity: 0.4
				color: 0x222222
				specular: 0x111111
				map: textures.shark
				envMap: cubemap
			)
		).at(-20, 0, 0).scaled(3)
	))
	# Add the objects
	objects = SCENE.create(envMap: cubemap).objects
	addAll(scene, sky, entities.player(), objects...)
	camera = create('PerspectiveCamera', 60, windowRatio(), 1, 100000).at(0, 10, 25)
	create('OrbitControls', camera)
	cb(
		scene: scene
		camera: camera
		renderer: create('WebGLRenderer', antialias: on)
				.then('setSize', window.innerWidth, window.innerHeight)
				.then('setPixelRatio', window.devicePixelRatio)
		clock: create('Clock')
		entities: entities
	)


## Exports
window.asyncBuildScene = asyncBuildScene
