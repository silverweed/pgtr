###
	Functions used to create objects
###

'use strict'

create = (objname, opts...) ->
	constr = THREE[objname]
	# Inject some utility methods
	constr.prototype ||= {}
	# Sets the position of this object and returns it
	constr.prototype.at = (args...) ->
		@position.set(args...)
		this
	# Calls a method of this object and returns self
	constr.prototype.then = (name, args...) ->
		l "Calling #{name} on #{obj} with args #{args}"
		this[name](args...)
		this
	obj = new constr(opts...)
	l "Created #{objname} with params #{opts}"
	obj


## Exports
window.create = create
