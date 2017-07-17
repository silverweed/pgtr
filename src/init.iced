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
	# NOTE: for reasons of deepest lore, these functions cannot be moved elsewhere.
	getMovedVolume = (obj, depth) ->
		radius = obj.scale.x
		return Math.PI * depth * depth * (radius - Math.min(radius, depth) / 3.0)

	world.updateBuoyancy = (delta) ->
		for name, obj of world.entities.entities
			continue unless obj.rigidbody? and obj.physicsOpts?.buoyant
			depth = CONF.PHYSICS.BUOYANCY_WATER_LEVEL - obj.position.y
			if depth > 0
				movedVolume = getMovedVolume(obj, depth + (obj.physicsOpts.buoyancyOffset ? 0))
				obj.rigidbody.activate()
				force = new Ammo.btVector3(
					0,
					movedVolume * delta * CONF.PHYSICS.BUOYANCY * (nextRand() + 0.5) * (obj.physicsOpts.mass ? 1)
					0
				)
				obj.rigidbody.applyCentralForce(force)
				Ammo.destroy(force)
		null

	# Start simulation
	renderLoop(world)

### "Main" ###

return unless requireWebgl()

# Wait for async scripts
document.getElementById('ammojs').addEventListener('load', initWorld)
