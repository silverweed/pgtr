###
	Functions used for rendering the scene
###

'use strict'

renderLoop = (world) ->
	player = world.entities.player()
	animate = ->
		world.stats.begin()
		requestAnimationFrame(animate)
		delta = world.clock.getDelta()
		# Update player
		#world.controls?.update(delta)
		player.update(delta)
		#world.camera.lookAt(world.entities.player().position)
		# Update debug input
		world.debug.forEach (e) -> e?.update? && e.update(delta)
		# Render scene
		world.water.material.uniforms.time.value += delta
		player.plane.material.uniforms.time.value += delta
		player.plane.material.uniforms.playerPos.value = player.position
		#world.water.material.uniforms.ripple
		world.physics.step(delta, CONF.PHYSICS.SUBSTEPS) if world.physics.enabled
		world.water.render()
		if world.postprocess?.enabled
			world.postprocess.composer.render(delta)
			#postProcessRender(world.scene, world.renderer, world.camera,
				#world.postprocess, world.objects.sunlight.position)
		else
			world.renderer.render(world.scene, world.camera)
		world.stats.end()
	animate()
	null


## Exports
window.renderLoop = renderLoop
