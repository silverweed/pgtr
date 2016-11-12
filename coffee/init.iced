'use strict'

requireWebgl = ->
	if !Detector.webgl
		Detector.addGetWebGLMessage()
		false
	true

createDOM = ->
	# Create the scene container
	container = document.createElement('div')
	document.body.appendChild(container)
	container


### "Main" ###

return unless requireWebgl()

l 'Starting program'
await buildScene(create('Scene'), defer world)
# Insert the canvas inside the <div>
createDOM().appendChild(world.renderer.domElement)
renderLoop(world)
