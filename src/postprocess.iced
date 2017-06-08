'use strict'

init = (world, scene, camera, cb) ->
	await
		asyncLoadShader("toonshading.vert", defer toonvert)
		asyncLoadShader("toonshading.frag", defer toonfrag)
	
	toonLighting = create("ShaderMaterial",
		uniforms: {
			nBands: { value: 3 },
			directionalLightDirection: {
				value: (world.objects.sunlight.target.position.sub(
					world.objects.sunlight.position)).normalize()
			},
			directionalLightColor: { value: world.objects.sunlight.color },
			directionalLightIntensity: { value: 0.5 }
		},
		vertexShader: toonvert,
		fragmentShader: toonfrag
	)

	dld = toonLighting.uniforms.directionalLightDirection.value
	console.assert(typeof(dld.x) == 'number' and not isNaN(dld.x),
		"directionalLightDirection = #{dld.x}, #{dld.y}, #{dld.z}")
	target = create("WebGLRenderTarget", window.innerWidth, window.innerHeight)
	target.depthBuffer = true
	target.depthTexture = create("DepthTexture")
	#renderPass = create('RenderPass', scene, camera)
	#composer = create('EffectComposer', renderer)
	#		.then('addPass', renderPass)
	#FIXME
	tcomposer = {
		renderer: world.renderer
		render: (sc, cam) ->
			scene.overrideMaterial = toonLighting
			tcomposer.renderer.render(sc, cam)
			null
	}
	cb({ composer: tcomposer, overrideMaterial: toonLighting })


## Exports ##
window.asyncPostProcessInit = init
