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
		if delta > 1/10.0
			delta = 1/30.0
		# Update player
		#world.controls?.update(delta)
		player.update(delta)
		#world.camera.lookAt(world.entities.player().position)
		# Update debug input
		world.debug.forEach (e) -> e?.update? && e.update(delta)
		# Render scene
		#world.water.material.uniforms.time.value += delta
		player.plane.material.uniforms.time.value += delta
		updateRipples(player, delta)
		world.updateBuoyancy(delta)
		world.physics.step(delta, CONF.PHYSICS.SUBSTEPS, CONF.PHYSICS.FIXED_TIME_STEP) if world.physics.enabled
		#world.water.render()
		world.postprocess.enabled = true
		if world.postprocess?.enabled
			world.postprocess.composer.render(world.scene, world.camera)
			#postProcessRender(world.scene, world.renderer, world.camera,
				#world.postprocess, world.objects.sunlight.position)
		else
			world.renderer.render(world.scene, world.camera)
		world.stats.end()
	animate()
	null

updateRipplesTimer = 0
updateRipples = (player, delta) ->
	updateRipplesTimer += delta
	player.planeWater.tickRippleTimes(delta)
	if updateRipplesTimer > CONF.OCEAN.RIPPLES.UPDATE_DELAY
		updateRipplesTimer = 0
		player.planeWater.pushRippleSrc(player.position)

## Exports
window.renderLoop = renderLoop
