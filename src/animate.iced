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
		#opts.controls?.update(delta)
		opts.entities?.player()?.update(delta)
		#opts.camera.lookAt(opts.entities.player().position)
		# Update debug input
		opts.debug?.forEach (e) -> e?.update? && e.update(delta)
		# Render scene
		opts.water.material.uniforms.time.value += delta
		opts.physics.step(delta, CONF.PHYSICS.SUBSTEPS) if opts.physics.enabled
		opts.water.render()
		if opts.postprocess?.enabled
			opts.postprocess.composer.render(delta)
			#postProcessRender(opts.scene, opts.renderer, opts.camera,
				#opts.postprocess, opts.objects.sunlight.position)
		else
			opts.renderer.render(opts.scene, opts.camera)
		opts.stats?.end()
	animate()
	null


## Exports
window.renderLoop = renderLoop
