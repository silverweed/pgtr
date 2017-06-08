###
	Event Listeners
###

'use strict'

# This object will contain all the keys appearing in CONF.CONTROLS
# with value `true` or `false` depending on whether that key is currently
# pressed or not.
Input = {}

hdKey = (down) ->
	(e) ->
		for key, val of CONF.CONTROLS
			if `e.keyCode == val`
				Input[key] = down
				return

resizeHandler = (camera, controls, renderer) ->
	->
		camera.aspect = window.innerWidth / window.innerHeight
		camera.updateProjectionMatrix()
		renderer.setSize(window.innerWidth, window.innerHeight)

window.createPostProcessControls = (world) ->
	window.addEventListener('keyup', (e) ->
		if `e.keyCode == CONF.CONTROLS.togglePostProcess`
			world.postprocess.enabled = !world.postprocess.enabled
			if world.postprocess.enabled
				world.scene.overrideMaterial = world.postprocess.overrideMaterial
			else
				world.scene.overrideMaterial = undefined
			world.renderer.clear()
		true
	)
window.addEventListener('keydown', hdKey(true), false)
window.addEventListener('keyup', hdKey(false), false)


## Exports ##
window.Input = Input
window.resizeHandler = resizeHandler
