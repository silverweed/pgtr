'use strict'

init = (world, scene, camera, cb) ->
	await
		asyncLoadShader("toonshading.vert", defer toonvert)
		asyncLoadShader("toonshading.frag", defer toonfrag)
		asyncLoadShader("depthfog.vert", defer fogvert)
		asyncLoadShader("depthfog.frag", defer fogfrag)
	
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
	
	depthShader = create("ShaderMaterial",
		uniforms:{
			renderedScene: {value : target.texture},
			depthTexture: {value : target.depthTexture},
			fogColor: { value : create("Vector4", 0.7,0.7,0.7,1.0)}
			frustumLength: {value: world.camera.far - world.camera.near},
			minVisionDepth: {value: 0.2},
			maxVisionDepth: {value: 1.0}
			},
		vertexShader: fogvert,
		fragmentShader: fogfrag
	)

		
	
	ppScene = {}
	ppScene.camera = new THREE.OrthographicCamera( - 1, 1, 1, - 1, 0, 1 )
	ppScene.scene = new THREE.Scene()
	ppScene.quad = new THREE.Mesh( new THREE.PlaneBufferGeometry( 2, 2 ), null )
	ppScene.quad.frustumCulled = false
	ppScene.quad.material = depthShader
	ppScene.scene.add( ppScene.quad )

	tcomposer = {
		ppScene : ppScene
		renderer: world.renderer
		render: (sc, cam) ->
			tcomposer.renderer.render(sc, cam, target)
			tcomposer.renderer.render(ppScene.scene, ppScene.camera)
			null
	}
	cb({ composer: tcomposer, overrideMaterial: toonLighting })


## Exports ##
window.asyncPostProcessInit = init
