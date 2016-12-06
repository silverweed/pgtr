###
	Functions used to create objects
###

'use strict'

create = (objname, opts...) ->
	constr = THREE[objname]
	# Inject some utility methods
	constr.prototype ||= {}
	# Sets the position of this object and returns self
	constr.prototype.at = (args...) ->
		@position.set(args...)
		this
	# Sets the scale of this object and returns self
	constr.prototype.scaled = (scale) ->
		@scale.set(scale, scale, scale)
		this
	# Calls a method of this object and returns self
	constr.prototype.then = (name, args...) ->
		this[name](args...)
		this
	constr.prototype.with = (attr, val) ->
		this[name] = val
		this
	obj = new constr(opts...)
	l "Created #{objname} with params #{opts}"
	obj


# Create a model with class 'Object3D', adding a mesh with the given material and geometry
createModel = (material: material, geometry: geometry) ->
	create('Object3D').add(create('Mesh', geometry, material))


## Exports
window.create = create
window.createModel = createModel
