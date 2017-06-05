###
	The object holding the entities, useful for having them available globally
###

'use strict'

Entities =
	new: (@scene) ->
		@entities = {}
		@_i = 0
		this
	add: (name, e) ->
		if typeof(name) != 'string' or name.length < 1
			name = "object#{@_i}"
			@_i += 1
		return if @entities.hasOwnProperty(name)
		l "adding #{name}"
		@entities[name] = e
		this
	destroy: (name) ->
		@scene.remove(@entities[name])
		this
	get: (name) -> @entities[name]
	player: -> @entities['player']


## Exports
window.Entities = Entities
