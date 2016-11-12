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
world = buildScene(create 'Scene')
# Insert the canvas inside the <div>
createDOM().appendChild(world.renderer.domElement)
renderLoop(world)
