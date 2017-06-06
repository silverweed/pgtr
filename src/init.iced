'use strict'

requireWebgl = ->
	if !Detector.webgl
		Detector.addGetWebGLMessage()
		return false
	return true

createDOM = (children...) ->
	# Create the scene container
	container = document.createElement('div')
	container.appendChild(child) for child in children
	document.body.appendChild(container)
	return container

initWorld = ->
	l 'Starting program'

	await asyncBuildScene(defer(world))

	document.getElementById('loading-text').style.display = 'none'

	# Add stats and debug
	world.stats = createStats()
	world.debug = [createSunlightControls(world.objects.sunlight), createPhysicsControls(world.physics)]

	# Insert the canvas inside the <div>
	createDOM(world.renderer.domElement, world.stats.domElement)

	# Add postprocessing
	world.postprocess = postProcessInit(world.scene, world.camera, world.renderer)
	world.postprocess.enabled = true
	
	# Add listeners
	window.addEventListener('resize', resizeHandler(world.camera, world.controls, world.renderer))
	createPostProcessControls(world)

	world.updateBuoyancy = (delta) ->
		x = 0
		for name, obj of world.entities.entities
			continue unless obj.rigidbody? and obj.buoyant
			depth = CONF.PHYSICS.BUOYANCY_WATER_LEVEL - obj.position.y
			x++
			if depth > 0
				obj.rigidbody.activate()
				obj.rigidbody.applyCentralForce(new Ammo.btVector3(
					0,
					Math.pow(depth, 1.8) * (obj.physicsOpts?.mass ? 1 ) * delta * CONF.PHYSICS.BUOYANCY,
					0
				))
	# Start simulation
	renderLoop(world)

### "Main" ###

return unless requireWebgl()

# Wait for async scripts
document.getElementById('ammojs').addEventListener('load', initWorld)
