###
	Functions used for rendering the scene
###

'use strict'

renderLoop = (opts) ->
	animate = ->
		opts.stats?.begin()
		requestAnimationFrame(animate)
		delta = opts.clock.getDelta()
		opts.renderer.render(opts.scene, opts.camera)
		opts.entities?.player()?.update(delta)
		opts.stats?.end()
	animate()
	null


## Exports
window.renderLoop = renderLoop
