###
	Functions for moving the player etc
###

'use strict'

# Augments an Object3D with methods that make it controllable.
createPlayer = (object) ->
	player = Object.create(object,
		speed:  { value: CONF.PLAYER.SPEED, enumerable: yes }
		update: { value: updatePlayer, writable: no }
	)
	player

updatePlayer = (deltaTime) ->
	fwd = Input.forward - Input.backward
	@translateZ(deltaTime * @speed * fwd)


## Exports
window.createPlayer = createPlayer
