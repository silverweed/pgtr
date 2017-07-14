###
	Functions dealing with loading stuff
###

'use strict'

cache =
	textures: {}
	models: {}
	shaders: {}

texpath = (basename) -> "textures/#{basename}.png"
shadpath = (basename) -> "src/shaders/#{basename}"
modpath = (basename) -> "models/#{basename}.json"

asyncLoadShader = (name, cb) ->
	unless name in cache.shaders
		l "Loading shader #{shadpath(name)}"
		await create('FileLoader').load(shadpath(name), defer shad)
		cache.shaders[name] = shad
	cb(cache.shaders[name])

# Asynchronously load a texture, cache it and return the object that will contain it
asyncLoadTexture = (name, cb) ->
	unless name in cache.textures
		l "Loading texture #{texpath(name)}"
		await create('TextureLoader').load(texpath(name), defer tex)
		console.assert(tex, "tex is null!")
		l "Loaded texture #{texpath(name)}"
		cache.textures[name] = tex
	cb(cache.textures[name])

# Asynchronously load a model, cache it and return the object that will contain it
asyncLoadGeometry = (name, cb) ->
	unless name in cache.models
		l "Loading model #{modpath name}"
		await create('JSONLoader').load(modpath(name), defer mod)
		console.assert(mod, "model is null!")
		cache.models[name] = mod
	cb(cache.models[name])

# Asynchronously load all textures in `textures` and models in `models`, then
# call `cb(loaded textures, loaded models)`
asyncLoadTexturesAndModels = (textures, models, cb) ->
	tex = {}
	mod = {}
	l "Start loading textures and models"
	await
		for texname in textures
			asyncLoadTexture texname, defer tex[texname]
		for modname in models
			asyncLoadGeometry modname, defer mod[modname]
	l "Loaded textures and models."
	cb(tex, mod)


asyncLoadSkybox = (urls, size, cb) ->
	l "Start loading sky"
	await create('CubeTextureLoader').load(urls, defer cubemap)
	cubemap.format = THREE.RGBFormat
	shader = THREE.ShaderLib.cube
	shader.uniforms.tCube.value = cubemap
	l "Loaded sky"
	cb(
		# Sky mesh
		create('Mesh',
			create('BoxGeometry', size, size, size)
			create('ShaderMaterial',
				fragmentShader: shader.fragmentShader
				vertexShader: shader.vertexShader
				uniforms: shader.uniforms
				depthWrite: false
				side: THREE.BackSide
			)
		)
		# Reflection cubemap
		cubemap
	)

asyncLoadOcean = (waternormal_url, renderer, camera, scene, sunlight, cb) ->
	#await create('TextureLoader').load(waternormal_url, defer waternormal)
	#waternormal.wrapS = waternormal.wrapT = THREE.RepeatWrapping
	#water = create('Water', renderer, camera, scene,
		#textureWidth: 512
		#textureHeight: 512
		#waterNormals: waternormal
		#alpha: 1.0
		#sunDirection: sunlight.position.clone().normalize()
		#sunColor: sunlight.color.getHex()
		#waterColor: 0x535b23 #0x001e0f 
		#distortionScale: 50.0
	#)
	await
		asyncLoadTexture('waterNoise1', defer noise1)
		asyncLoadTexture('waterNoise2', defer noise2)
		asyncLoadShader('toonwater.vert', defer watervert)
		asyncLoadShader('toonwater.frag', defer waterfrag)
	noise1.wrapS = noise2.wrapS = noise1.wrapT = noise2.wrapT = THREE.RepeatWrapping
	water = create("ShaderMaterial",
		uniforms: {
			speed1:        { value: create('Vector2', 10, 20) }
			speed2:        { value: create('Vector2', 20, 13) }
			noiseTexture1: { value: noise1 }
			noiseTexture2: { value: noise2 }
			waveAmplitude: { value: 2 }
			time:          { value: 0 }
			foamColor:     { value: create('Vector4', 0.2, 0.2, 0.6, 1) }
			waterColor:    { value: create('Vector4', 0, 0, 0, 1) }
		},
		vertexShader: cache.shaders["toonwater.vert"],
		fragmentShader: cache.shaders["toonwater.frag"]
	)
	mirrorMesh = create('Mesh'
		create('PlaneBufferGeometry'
			10000
			10000
		)
		water
	)	.at(0, CONF.OCEAN.Y, 0)
		.then('rotateX', -Math.PI / 2.0)
	#water.position.z = -1000
	cb(water, mirrorMesh)

asyncLoadPlayerPlane = (waternormal_url, renderer, camera, scene, sunlight, cb) ->
	#await create('TextureLoader').load(waternormal_url, defer waternormal)
	#waternormal.wrapS = waternormal.wrapT = THREE.RepeatWrapping
	#water = create('WaterRippled', renderer, camera, scene,
		#textureWidth: 512
		#textureHeight: 512
		#waterNormals: waternormal
		#alpha: 1.0
		#sunDirection: sunlight.position.clone().normalize()
		#sunColor: sunlight.color.getHex()
		#waterColor: 0x535b23 #0x001e0f
		#distortionScale: 50.0
	#)
	await
		asyncLoadTexture('waterNoise1', defer noise1)
		asyncLoadTexture('waterNoise2', defer noise2)
		asyncLoadShader('toonwater.vert', defer watervert)
		asyncLoadShader('toonwater.frag', defer waterfrag)
	noise1.wrapS = noise2.wrapS = noise1.wrapT = noise2.wrapT = THREE.RepeatWrapping
	console.assert(cache.textures.waterNoise1 and
		cache.textures.waterNoise2 and
		cache.shaders["toonwater.vert"] and
		cache.shaders["toonwater.frag"],
		"Not all assets loaded!")
	water = create("ShaderMaterial",
		uniforms: {
			speed1:        { value: create('Vector2', 100, 151) }
			speed2:        { value: create('Vector2', -70, -50) }
			noiseTexture1: { value: cache.textures.waterNoise1 }
			noiseTexture2: { value: cache.textures.waterNoise2 }
			waveAmplitude: { value: 15 }
			time:          { value: 0 }
			foamColor:     { value: create('Vector4', 1, 1, 1, 1) }
			waterColor:    { value: create('Vector4', 0, 0.7, 1, 1) }
			size1:         { value: 1000 }
			size2:         { value: 700 }
		},
		vertexShader: cache.shaders["toonwater.vert"],
		fragmentShader: cache.shaders["toonwater.frag"]
	)
	mirrorMesh = create('Mesh'
		create('PlaneBufferGeometry'
			10000  # width
			10000  # height
			1000 # subdX
			1000 # subdY
		)
		water
	)	.at(0, CONF.OCEAN.Y - 1, 0)
		.then('rotateX', -Math.PI / 2.0)
		.add(water)
	cb(water, mirrorMesh)

## Exports
window.cache = cache
window.asyncLoadTexturesAndModels = asyncLoadTexturesAndModels
window.asyncLoadSkybox = asyncLoadSkybox
window.asyncLoadOcean = asyncLoadOcean
window.asyncLoadPlayerPlane = asyncLoadPlayerPlane
window.asyncLoadShader = asyncLoadShader
