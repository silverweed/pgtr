###
	Functions dealing with loading stuff
###

'use strict'

cache =
	textures: {}
	models: {}

texpath = (basename) -> "textures/#{basename}.png"
modpath = (basename) -> "models/#{basename}.json"

# Asynchronously load a texture, cache it and return the object that will contain it
asyncLoadTexture = (name, cb) ->
	unless name in cache.textures
		l "Loading texture #{texpath name}"
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

asyncLoadMultiMaterial = (urls, cb) ->
	loader = create('TextureLoader')
	materials = []
	await
		for url in urls
			l "Loading #{texpath url}"
			loader.load(texpath(url), defer texture)
			l texture
			materials.push(create('MeshLambertMaterial',
				emissiveMap: texture
				emissiveIntensity: 100
				color: 0x000000
			))
			l "Done loading #{url}"
	cb(create('MultiMaterial', materials))

## Exports
window.cache = cache
window.asyncLoadTexturesAndModels = asyncLoadTexturesAndModels
window.asyncLoadSkybox = asyncLoadSkybox
window.asyncLoadMultiMaterial = asyncLoadMultiMaterial
