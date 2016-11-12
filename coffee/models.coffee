###
	Functions dealing with loading and initializing meshes, geometry, etc
###

cache = {}
loader = create('TextureLoader')

texture = (name) ->
	return cache[name] if name in cache
	l "Loading texture #{name}"
	cache[name] = loader.load("lib/three.js/examples/textures/#{name}")
	return cache[name]


createModel = (objname, { material: material, geometry: geometry }) ->
	obj = create(objname)
	obj.add(create('Mesh', geometry, material))
	obj



## Exports
window.texture = texture
window.createModel = createModel
