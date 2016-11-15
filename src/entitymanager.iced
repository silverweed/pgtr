###
	The object holding the entities, useful for having them available globally
###

'use strict'

Entities =
	new: (@scene) ->
		@entities = {}
		this
	add: (name, e) ->
		destroy(name) if name in @entities
		@entities[name] = e
		this
	destroy: (name) ->
		@scene.remove(@entities[name])
		this
	get: (name) -> @entities[name]
	player: -> @entities['player']


## Exports
window.Entities = Entities
