###
	Functions used to create objects
###

'use strict'

create = (objname, opts...) ->
	constr = THREE[objname]
	console.error("#{objname} is undefined!") unless constr?
	# Inject some utility methods
	constr.prototype ||= {}
	# Sets the position of this object and returns self
	constr.prototype.at = (args...) ->
		@position.set(args...)
		this
	# Sets the scale of this object and returns self
	constr.prototype.scaled = (scale...) ->
		if scale.length is 1
			scale = scale[0]
			@scale.set(scale, scale, scale)
		else
			@scale.set(scale...)
		this
	# Calls a method of this object and returns self
	constr.prototype.then = (name, args...) ->
		this[name](args...)
		this
	constr.prototype.with = (attr, val) ->
		this[attr] = val
		this
	obj = new constr(opts...)
	l "Created #{objname} with params #{opts}"
	obj


# Create a model with class 'Object3D', adding a mesh with the given material and geometry
createModel = (material: material, geometry: geometry) ->
	model = create('Object3D')
	model.add(create('SkinnedMesh', geometry, material))
	model


## Exports
window.create = create
window.createModel = createModel
