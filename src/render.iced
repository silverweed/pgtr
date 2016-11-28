###
	Functions used for rendering the scene
###

'use strict'

renderLoop = (opts) ->
	animate = ->
		opts.stats?.begin()
		requestAnimationFrame(animate)
		delta = opts.clock.getDelta()
		# Update player
		opts.entities?.player()?.update(delta)
		# Update debug input
		opts.debug?.forEach (e) -> e.update && e.update(delta)
		# Render scene
		opts.water.material.uniforms.time.value += delta
		opts.water.render()
		opts.renderer.render(opts.scene, opts.camera)
		opts.stats?.end()
	animate()
	null


## Exports
window.renderLoop = renderLoop
