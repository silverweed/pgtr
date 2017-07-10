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

	await asyncBuildScene(defer world)

	document.getElementById('loading-text').style.display = 'none'

	# Add stats and debug
	world.stats = createStats()
	world.debug = [createSunlightControls(world.objects.sunlight), createPhysicsControls(world.physics)]

	# Insert the canvas inside the <div>
	createDOM(world.renderer.domElement, world.stats.domElement)

	# Add postprocessing
	await asyncPostProcessInit(world, world.scene, world.camera, defer world.postprocess)
	world.postprocess.enabled = true
	createPostProcessControls(world)
	
	# Add buoyancy
	# NOTE: for reasons of deepest lore, this function cannot be moved elsewhere.
	# If you wonder why, don't. Just leave this here. Seriously. Or the world will stop rotating
	# and you'll never know why. Just know it's all part of the KEIKAKU, and the DLC will
	# eventually explain this. Or not.
	world.updateBuoyancy = (delta) ->
		for name, obj of world.entities.entities
			continue unless obj.rigidbody? and obj.buoyant
			depth = CONF.PHYSICS.BUOYANCY_WATER_LEVEL - obj.position.y
			if depth > 0
				obj.rigidbody.activate()
				obj.rigidbody.applyCentralForce(new Ammo.btVector3(
					0,
					Math.pow(depth, 1.8) * (obj.physicsOpts?.mass ? 1 ) *
						delta * CONF.PHYSICS.BUOYANCY,
					0
				))
		null

	# Start simulation
	renderLoop(world)

### "Main" ###

return unless requireWebgl()

# Wait for async scripts
document.getElementById('ammojs').addEventListener('load', initWorld)
