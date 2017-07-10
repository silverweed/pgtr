'use strict'

init = (world, scene, camera, cb) ->

	dld = toonLighting.uniforms.directionalLightDirection.value
	console.assert(typeof(dld.x) == 'number' and not isNaN(dld.x),
		"directionalLightDirection = #{dld.x}, #{dld.y}, #{dld.z}")
	target = create("WebGLRenderTarget", window.innerWidth, window.innerHeight)
	target.depthBuffer = true
	target.depthTexture = create("DepthTexture")
	
	depthShader = create("ShaderMaterial",
		uniforms: {
			renderedScene:  { value: target.texture },
			depthTexture:   { value: target.depthTexture },
			fogColor:       { value: create("Vector4", 0.7,0.7,0.7,1.0) }
			near:           { value: world.camera.near },
			far:            { value: world.camera.far },
			minVisionDepth: { value: 60.0 },
			maxVisionDepth: { value: 200.0 }
		}
		vertexShader:window.cache.shaders["depthfog.vert"],
		fragmentShader: window.cache.shaders["depthfog.frag"]
	)

	l "camera far is: #{world.camera.far}"
	
	ppScene = {
		camera: create('OrthographicCamera', -1, 1, 1, -1, 0, 1)
		scene:  create('Scene')
		quad:   create('Mesh', create('PlaneBufferGeometry', 2, 2), null)
	}
	ppScene.quad.frustumCulled = false
	ppScene.quad.material = depthShader

	ppScene.scene.add(ppScene.quad)

	tcomposer = {
		ppScene : ppScene
		renderer: world.renderer
		render: (sc, cam) ->
			tcomposer.renderer.render.autoClear = false 
			tcomposer.renderer.render(sc, cam, target)
			tcomposer.renderer.render(ppScene.scene, ppScene.camera)
			null
	}
	cb({ composer: tcomposer, overrideMaterial: toonLighting })


## Exports ##
window.asyncPostProcessInit = init
