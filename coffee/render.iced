###
	Functions used for rendering the scene
###

'use strict'

renderLoop = (opts) ->
	render = ->
		opts.stats?.begin()
		requestAnimationFrame(render)
		opts.renderer.render(opts.scene, opts.camera)
		opts.stats?.end()
	render()
	null


## Exports
window.renderLoop = renderLoop
