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
		cache.textures[name] = tex
	cb(cache.textures[name])

# Asynchronously load a model, cache it and return the object that will contain it
asyncLoadGeometry = (name, cb) ->
	unless name in cache.models
		l "Loading model #{modpath name}"
		await create('JSONLoader').load(modpath(name), defer mod)
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
		create('Mesh'
			create('BoxGeometry', size, size, size)
			create('ShaderMaterial',
				fragmentShader: shader.fragmentShader
				vertexShader: shader.vertexShader
				uniforms: shader.uniforms
				depthWrite: off
				side: THREE.BackSide
			)
		)
		# Reflection cubemap
		cubemap
	)

asyncLoadOcean = (waternormal_url, renderer, camera, scene, sunlight, cb) -> 
	await create('TextureLoader').load(waternormal_url, defer waternormal)
	waternormal.wrapS = waternormal.wrapT = THREE.RepeatWrapping
	water = create('Water', renderer, camera, scene,
		textureWidth: 512
		textureHeight: 512
		waterNormals: waternormal
		alpha: 1.0
		sunDirection: sunlight.position.clone().normalize()
		sunColor: sunlight.color.getHex()
		waterColor: 0x535b23 #0x001e0f 
		distortionScale: 50.0
	)
	mirrorMesh = create('Mesh'
		create('PlaneBufferGeometry'
			10000
			10000
		)
		water.material
	)	.at(0, CONF.OCEAN.Y, 0)
		.then('rotateX', -Math.PI / 2.0)
		.add(water)
	#water.position.z = -1000
	cb(water, mirrorMesh)

asyncLoadPlayerPlane = (waternormal_url, renderer, camera, scene, sunlight, cb) ->
	await create('TextureLoader').load(waternormal_url, defer waternormal)
	waternormal.wrapS = waternormal.wrapT = THREE.RepeatWrapping
	water = create('WaterRippled', renderer, camera, scene,
		textureWidth: 512
		textureHeight: 512
		waterNormals: waternormal
		alpha: 1.0
		sunDirection: sunlight.position.clone().normalize()
		sunColor: sunlight.color.getHex()
		waterColor: 0x535b23 #0x001e0f
		distortionScale: 50.0
	)
	mirrorMesh = create('Mesh'
		create('PlaneBufferGeometry'
			300
			300
			1000
			1000
		)
		water.material
	)	.at(0, CONF.OCEAN.Y - 1, 0)
		.then('rotateX', -Math.PI / 2.0)
		.add(water)
	#water.position.z = -1000
	cb(water, mirrorMesh)

#asyncLoadMultiMaterial = (urls, cb) ->
	#loader = create('TextureLoader')
	#materials = []
	#await
		#for url in urls
			#l "Loading #{texpath url}"
			#loader.load(texpath(url), defer texture)
			#l texture
			#materials.push(create('MeshLambertMaterial',
				#emissiveMap: texture
				#emissiveIntensity: 100
				#color: 0x000000
			#))
			#l "Done loading #{url}"
	#cb(create('MultiMaterial', materials))

## Exports
window.cache = cache
window.asyncLoadTexturesAndModels = asyncLoadTexturesAndModels
window.asyncLoadSkybox = asyncLoadSkybox
window.asyncLoadOcean = asyncLoadOcean
window.asyncLoadPlayerPlane = asyncLoadPlayerPlane
window.asyncLoadShader = asyncLoadShader
#window.asyncLoadMultiMaterial = asyncLoadMultiMaterial
