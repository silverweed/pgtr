###
	Functions used for rendering the scene
###

'use strict'

wholeTime =0

renderLoop = (world) ->
	player = world.entities.player()
	animate = ->
		
		world.stats.begin()
		requestAnimationFrame(animate)
		delta = world.clock.getDelta()
		delta = 1/30.0 if delta > 1/10.0
		if delta > 1/10.0
			delta = 1/30.0
		wholeTime += delta
		# Update player
		#world.controls?.update(delta)
		player.update(delta)
		world.objects.toonShadedMats.forEach (t) ->
			t.uniforms.directionalLightColor.value = create("Vector4",
				world.objects.sunlight.color.toArray()...,1.0)
			t.uniforms.directionalLightIntensity.value = world.objects.sunlight.intensity
			t.uniforms.directionalLightDirection.value =
				(world.objects.sunlight.target.position.clone().sub(
				 world.objects.sunlight.position)).normalize().clone()
			t.uniforms.ambientIntensity.value = world.objects.ambientLight.ambientIntensity
			t.uniforms.ambientColor.value = world.objects.ambientLight.ambientColor
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
		#world.postprocess.enabled = true
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
