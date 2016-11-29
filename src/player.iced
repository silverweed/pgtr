###
	Functions for moving the player etc
###

'use strict'

# Augments an Object3D with methods that make it controllable.
createPlayer = (object) ->
	player = Object.create(object,
		speed:  { value: CONF.PLAYER.SPEED, writable: yes, enumerable: yes }
		update: { value: updatePlayer, writable: no, enumerable: no }
		tSinceJump: { value: 2, writable: yes, enumerable: no }
	)
	player

updatePlayer = (deltaTime) ->
	fwd = Input.forward - Input.backward
	if fwd > 0 or fwd < 0
		@rigidbody.activate()
		# TODO/FIXME: calculate forward vector
		v = new Ammo.btVector3(0, 0, @speed * fwd)
		q = @rigidbody.getWorldTransform().getRotation()
		v.rotate(new Ammo.btVector3(0, 1, 0), q.angle)
		@rigidbody.applyCentralForce(new Ammo.btVector3(v.x, v.y, v.z))
	right = Input.right - Input.left
	if right > 0 or right < 0
		@rigidbody.activate()
		@rigidbody.applyTorque(new Ammo.btVector3(0, @speed * right, 0))
		q = @rigidbody.getWorldTransform().getRotation()
		l "rot = #{q.x()}, #{q.y()}, #{q.z()}, #{q.w()}"
	@tSinceJump += deltaTime
	if Input.jump and @tSinceJump > 1
		@rigidbody.activate()
		@rigidbody.applyCentralImpulse(new Ammo.btVector3(0, 0, -CONF.PLAYER.JUMP_FORCE))
		@tSinceJump = 0

## Exports
window.createPlayer = createPlayer
