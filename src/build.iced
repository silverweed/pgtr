###
	Functions that build the scene
###

'use strict'

addAll = (scene, physics, objects...) ->
	for obj in objects
		scene.add(obj)
		console.log "physics #{obj.physics}"
		physics.addRigidBody(obj, obj.physicsOpts) if obj.physics
	null

# Creates an empty Scene, fills it with the content and returns an object
# wrapping it along with its camera, renderer and clock
asyncBuildScene = (cb) ->
	scene = create('Scene')
	scene.fog = create('FogExp2', CONF.FOG.COLOR, CONF.FOG.DENSITY)
	l "In buildScene(#{scene})"

	camera = create('PerspectiveCamera', 60, windowRatio(), 1, 100000).at(0, 10, -30)
		.then('rotateY', Math.PI)
		.then('rotateX', -0.3)
	# XXX: Currently unused
	#controls = create('FirstPersonControls', camera)
				#.with('movementSpeed', CONF.PLAYER.SPEED)
				#.with('lookSpeed', 0)
	controls = create('OrbitControls', camera)
	renderer = create('WebGLRenderer', antialias: on)
				.then('setSize', window.innerWidth, window.innerHeight)
				.then('setPixelRatio', window.devicePixelRatio)

	await
		asyncLoadTexturesAndModels(['shark', 'white', 'black'], ['shark'], defer(textures, models))
		asyncLoadSkybox(CONF.SKYBOX.URLS, CONF.SKYBOX.SIZE, defer(sky, cubemap))
		#asyncLoadMultiMaterial(['white', 'black', 'black', 'black', 'black', 'black'], defer(cubemat))

	objects = SCENE.create(envMap: cubemap)
	for o in objects.objects
		l "#{o}: physics #{o.physics}"
	await
		asyncLoadOcean(CONF.OCEAN.URL, renderer, camera, scene, objects.sunlight, defer(water, ocean))
		asyncLoadPlayerPlane(CONF.OCEAN.URL, renderer, camera, scene, objects.sunlight, defer(pPlaneWater, pPlane))

	entities = Entities.new(scene)

	player = objects.player
	player.add(camera)
	player.plane = pPlane
	player.planeWater = pPlaneWater
	entities.add('player', player)

	physics = new Physics()
	physics.createGround()

	# Add the objects
	addAll(scene, physics, sky, ocean, entities.player(), pPlane, objects.objects...)
	cb(
		scene: scene
		water: water
		camera: camera
		renderer: renderer
		clock: create('Clock')
		entities: entities
		objects: objects
		physics: physics
		controls: controls
	)


## Exports
window.asyncBuildScene = asyncBuildScene
