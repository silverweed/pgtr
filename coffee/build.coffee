###
	Functions that build the scene
###

'use strict'

addAll = (scene, objects...) ->
	scene.add(obj) for obj in objects
	null

# Takes an empty Scene, fills it with the content and returns an object
# wrapping it along with its camera, renderer and clock
buildScene = (scene) ->
	l "In buildScene(#{scene})"
	addAll(scene,
		create('DirectionalLight', 0xffffff, 10)
			.at(10000, 10000, 10000)
			.then('rotateY', 20)
			.then('rotateZ', 30),
		create('DirectionalLight', 0xffffff, 10)
			.at(-10000, -10000, 10000)
		create('HemisphereLight', 0xffffbb, 0x080820, 1),
		createModel('Object3D', {
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshPhongMaterial', {
				shininess: 20
				color: 0xffffff
				specular: 0x999999
				map: texture('textures/patterns/bright_squares256.png')
			})
		}),
		createModel('Object3D', {
			geometry: create('BoxGeometry', 10, 10, 10)
			material: create('MeshPhongMaterial', {
				shininess: 3
				color: 0x44ff44
				specular: 0x222299
				map: texture('textures/patterns/bright_squares256.png')
			})
		}).at(20, 0, 0)
	)
	camera = create('PerspectiveCamera', 60, windowRatio(), 1, 100000).at(0, 10, 25)
	create('OrbitControls', camera)
	{
		scene: scene
		camera: camera
		renderer: create('WebGLRenderer').then('setSize', window.innerWidth, window.innerHeight)
		clock: create('Clock')
	}



## Exports
window.buildScene = buildScene
