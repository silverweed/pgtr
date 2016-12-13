'use strict'

requireWebgl = ->
	if !Detector.webgl
		Detector.addGetWebGLMessage()
		false
	true

createDOM = (children...) ->
	# Create the scene container
	container = document.createElement('div')
	container.appendChild(child) for child in children
	document.body.appendChild(container)
	container


### "Main" ###

return unless requireWebgl()

l 'Starting program'

await asyncBuildScene(defer world)

# Add stats and debug
world.stats = createStats()
world.debug = [createSunlightControls(world.objects.sunlight), createPhysicsControls(world.physics)]

# Insert the canvas inside the <div>
createDOM(world.renderer.domElement, world.stats.domElement)

# Add postprocessing
world.postprocess = postProcessInit(world.scene, world.camera, world.renderer)

# Add listeners
window.addEventListener('resize', resizeHandler(world.camera, world.controls, world.renderer))
#createPostProcessControls(world)

# Start simulation
renderLoop(world)
