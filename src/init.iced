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
await asyncBuildScene(create('Scene'), defer world)
# Add stats
world.stats = createStats()
world.debug = [createSunlightControls(world.objects.sunlight), createTogglePhysicsControls(world.physics)]
# Insert the canvas inside the <div>
createDOM(world.renderer.domElement, world.stats.domElement)
renderLoop(world)
