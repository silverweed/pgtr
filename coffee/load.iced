###
	Functions dealing with loading and initializing meshes, geometry, etc
###

cache =
	textures: {}
	models: {}

# Asynchronously load a texture, cache it and return the object that will contain it
loadAsyncTexture = (name, cb) ->
	unless name in cache.textures
		l "Loading texture #{name}"
		await create('TextureLoader').load("textures/#{name}.png", defer tex)
		cache.textures[name] = tex
	cb(cache.textures[name])

# Asynchronously load a model, cache it and return the object that will contain it
loadAsyncGeometry = (name, cb) ->
	unless name in cache.models
		l "Loading model #{name}"
		await create('JSONLoader').load("models/#{name}.json", defer mod)
		cache.models[name] = mod
	cb(cache.models[name])

# Asynchronously load all textures in `textures` and models in `models`, then
# call `cb(loaded textures, loaded models)`
loadAsyncTexturesAndModels = (textures, models, cb) ->
	tex = {}
	mod = {}
	l "Start loading textures and models"
	await
		for texname in textures
			loadAsyncTexture texname, defer tex[texname]
		for modname in models
			loadAsyncGeometry modname, defer mod[modname]
	l "Loaded textures and models."
	cb(tex, mod)

# Create a model with class 'objname', adding a mesh with the given material and geometry
createModel = (objname, material: material, geometry: geometry) ->
	obj = create(objname)
	obj.add(create('Mesh', geometry, material))
	obj

## Exports
window.createModel = createModel
window.loadAsyncTexturesAndModels = loadAsyncTexturesAndModels
