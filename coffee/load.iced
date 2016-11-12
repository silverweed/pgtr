###
	Functions dealing with loading stuff
###

'use strict'

cache =
	textures: {}
	models: {}

# Asynchronously load a texture, cache it and return the object that will contain it
asyncLoadTexture = (name, cb) ->
	unless name in cache.textures
		l "Loading texture #{name}"
		await create('TextureLoader').load("textures/#{name}.png", defer tex)
		cache.textures[name] = tex
	cb(cache.textures[name])

# Asynchronously load a model, cache it and return the object that will contain it
asyncLoadGeometry = (name, cb) ->
	unless name in cache.models
		l "Loading model #{name}"
		await create('JSONLoader').load("models/#{name}.json", defer mod)
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


## Exports
window.asyncLoadTexturesAndModels = asyncLoadTexturesAndModels
