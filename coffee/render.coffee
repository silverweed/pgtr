###
	Functions used for rendering the scene
###

'use strict'

renderLoop = (opts) ->
	render = ->
		requestAnimationFrame(render)
		#delta = opts.clock.getDelta()
		opts.renderer.render(opts.scene, opts.camera)
	render()
	null


## Exports
window.renderLoop = renderLoop
