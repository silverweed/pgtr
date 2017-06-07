###
init = ->
	camera = create('OrthographicCamera',
			-window.innerWidth / 2, window.innerWidth / 2,
			window.innerHeight / 2, -window.innerHeight / 2,
			-10000, 10000
		).at(0, 0, 100)
	scene = create('Scene').then('add', camera)

	pars =
		minFilter: THREE.LinearFilter
		magFilter: THREE.LinearFilter
		format: THREE.RGBFormat

	rtTextureColors = create('WebGLRenderTarget', window.innerWidth, window.innerHeight, pars)
	rtTextureDepth = create('WebGLRenderTarget', window.innerWidth, window.innerHeight, pars)

	w = window.innerWidth / 4.0
	h = window.innerHeight / 4.0
	rtTextureGodRays1 = create('WebGLRenderTarget', w, h, pars)
	rtTextureGodRays2 = create('WebGLRenderTarget', w, h, pars)

	# god-ray shaders

	godraysGenShader = THREE.ShaderGodRays.godrays_generate
	godrayGenUniforms = THREE.UniformsUtils.clone(godraysGenShader.uniforms)
	materialGodraysGenerate = create('ShaderMaterial',
		uniforms: godrayGenUniforms
		vertexShader: godraysGenShader.vertexShader
		fragmentShader: godraysGenShader.fragmentShader
	)

	godraysCombineShader = THREE.ShaderGodRays.godrays_combine
	godraysCombineUniforms = THREE.UniformsUtils.clone(godraysCombineShader.uniforms)
	materialGodraysCombine = create('ShaderMaterial',
		uniforms: godraysCombineUniforms
		vertexShader: godraysCombineShader.vertexShader
		fragmentShader: godraysCombineShader.fragmentShader
	)

	godraysFakeSunShader = THREE.ShaderGodRays.godrays_fake_sun
	godraysFakeSunUniforms = THREE.UniformsUtils.clone(godraysFakeSunShader.uniforms)
	materialGodraysFakeSun = create('ShaderMaterial',
		uniforms: godraysFakeSunUniforms
		vertexShader: godraysFakeSunShader.vertexShader
		fragmentShader: godraysFakeSunShader.fragmentShader
	)

	godraysFakeSunUniforms.bgColor.value.setHex(0x000511)
	godraysFakeSunUniforms.sunColor.value.setHex(CONF.SUN.COLOR)
	godraysCombineUniforms.fGodRayIntensity.value = 0.75

	quad = create('Mesh',
		create('PlaneBufferGeometry', window.innerWidth, window.innerHeight)
		materialGodraysGenerate
	).at(0, 0, -9900)
	scene.add(quad)
	{
		scene: scene
		camera: camera
		enabled: yes
		godrayGenUniforms: godrayGenUniforms
		godraysFakeSunUniforms: godraysFakeSunUniforms
		godraysCombineUniforms: godraysCombineUniforms
		rtTextureColors: rtTextureColors
		rtTextureGodRays1: rtTextureGodRays1
		rtTextureGodRays2: rtTextureGodRays2
		materialGodraysFakeSun: materialGodraysFakeSun
		materialGodraysGenerate: materialGodraysGenerate
		materialDepth: create('MeshDepthMaterial')
	}

postProcessRender = (scene, renderer, camera, postprocessing, sunPosition) ->
	# Find the screenspace position of the sun
	screenSpacePosition = create('Vector3')
				.then('copy', sunPosition)
				.then('project', camera)

	screenSpacePosition.x = (screenSpacePosition.x + 1) / 2
	screenSpacePosition.y = (screenSpacePosition.y + 1) / 2

	# Give it to the god-ray and sun shaders

	postprocessing.godrayGenUniforms.vSunPositionScreenSpace.value.x = screenSpacePosition.x
	postprocessing.godrayGenUniforms.vSunPositionScreenSpace.value.y = screenSpacePosition.y

	postprocessing.godraysFakeSunUniforms.vSunPositionScreenSpace.value.x = screenSpacePosition.x
	postprocessing.godraysFakeSunUniforms.vSunPositionScreenSpace.value.y = screenSpacePosition.y

	# -- Draw sky and sun --

	# Clear colors and depths, will clear to sky color

	renderer.clearTarget(postprocessing.rtTextureColors, true, true, false)

	# Sun render. Runs a shader that gives a brightness based on the screen
	# space distance to the sun. Not very efficient, so i make a scissor
	# rectangle around the suns position to avoid rendering surrounding pixels.

	sunsqH = 0.74 * window.innerHeight # 0.74 depends on extent of sun from shader
	sunsqW = 0.74 * window.innerHeight # both depend on height because sun is aspect-corrected

	screenSpacePosition.x *= window.innerWidth
	screenSpacePosition.y *= window.innerHeight

	renderer.setScissor(screenSpacePosition.x - sunsqW / 2, screenSpacePosition.y - sunsqH / 2, sunsqW, sunsqH)
	renderer.setScissorTest(on)

	postprocessing.godraysFakeSunUniforms.fAspect.value = window.innerWidth / window.innerHeight

	postprocessing.scene.overrideMaterial = postprocessing.materialGodraysFakeSun
	renderer.render(postprocessing.scene, postprocessing.camera, postprocessing.rtTextureColors)

	renderer.setScissorTest(off)

	# -- Draw scene objects --

	# Colors

	scene.overrideMaterial = null
	renderer.render(scene, camera, postprocessing.rtTextureColors)

	# Depth

	scene.overrideMaterial = postprocessing.materialDepth
	renderer.render(scene, camera, postprocessing.rtTextureDepth, true)

	# -- Render god-rays --

	# Maximum length of god-rays (in texture space [0,1]X[0,1])

	filterLen = 1.0

	# Samples taken by filter

	TAPS_PER_PASS = 6.0

	# Pass order could equivalently be 3,2,1 (instead of 1,2,3), which
	# would start with a small filter support and grow to large. however
	# the large-to-small order produces less objectionable aliasing artifacts that
	# appear as a glimmer along the length of the beams

	# pass 1 - render into first ping-pong target

	pass = 1.0
	stepLen = filterLen * Math.pow(TAPS_PER_PASS, -pass)

	postprocessing.godrayGenUniforms.fStepSize.value = stepLen
	postprocessing.godrayGenUniforms.tInput.value = postprocessing.rtTextureDepth

	postprocessing.scene.overrideMaterial = postprocessing.materialGodraysGenerate

	renderer.render(postprocessing.scene, postprocessing.camera, postprocessing.rtTextureGodRays2)

	# pass 2 - render into second ping-pong target

	pass = 2.0
	stepLen = filterLen * Math.pow(TAPS_PER_PASS, -pass)

	postprocessing.godrayGenUniforms.fStepSize.value = stepLen
	postprocessing.godrayGenUniforms.tInput.value = postprocessing.rtTextureGodRays2

	renderer.render(postprocessing.scene, postprocessing.camera, postprocessing.rtTextureGodRays1)

	# pass 3 - 1st RT

	pass = 3.0
	stepLen = filterLen * Math.pow(TAPS_PER_PASS, -pass)

	postprocessing.godrayGenUniforms.fStepSize.value = stepLen
	postprocessing.godrayGenUniforms.tInput.value = postprocessing.rtTextureGodRays1

	renderer.render(postprocessing.scene, postprocessing.camera , postprocessing.rtTextureGodRays2)

	# final pass - composite god-rays onto colors

	postprocessing.godraysCombineUniforms.tColors.value = postprocessing.rtTextureColors
	postprocessing.godraysCombineUniforms.tGodRays.value = postprocessing.rtTextureGodRays2

	postprocessing.scene.overrideMaterial = postprocessing.materialGodraysCombine

	renderer.render(postprocessing.scene, postprocessing.camera)
	postprocessing.scene.overrideMaterial = null
###



init = (world, scene, camera,  cb) ->

	await
		asyncLoadShader("toonshading.vert", defer toonvert)
		asyncLoadShader("toonshading.frag", defer toonfrag)
	
	toonLighting = create("ShaderMaterial", {
		uniforms: {
			nBands : 3,
			directionalLightDirection: { value: (world.objects.sunlight.target.position.sub(
				world.objects.sunlight.position)).normalize() },
			directionalLightColor: { value: world.objects.sunlight.color },
			directionalLightIntensity: { value: 0.5 }
		},
		vertexShader: toonvert,
		fragmentShader: toonfrag
	})

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
	tcomposer = {}
	tcomposer.renderer = create('WebGLRenderer', antialias: on)
				.then('setSize', window.innerWidth, window.innerHeight)
				.then('setPixelRatio', window.devicePixelRatio)
				.with('autoClear', true)
	tcomposer.render = (sc, cam) ->
		#scene.overrideMaterial = toonLighting
		tcomposer.renderer.render(sc, cam)
		tcomposer.renderer
		null
	cb({ composer: tcomposer })

## Exports ##
window.postProcessInit = init
