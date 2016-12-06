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
	fwd = (Input.forward ? 0) - (Input.backward ? 0)
	if fwd > 0 or fwd < 0
		@rigidbody.activate()
		q = @rigidbody.getWorldTransform().getRotation()
		p = new Ammo.btQuaternion(0, 1, 0, 0)
		# I have NO CLUE why I have to multiply angle by 2, but it apparently works.
		p.setRotation(q.getAxis(), q.getAngle() * 2)
		f = p.op_mul(@speed * fwd)
		@rigidbody.applyCentralForce(new Ammo.btVector3(f.y(), f.z(), f.w()))
	right = (Input.right ? 0) - (Input.left ? 0)
	if right > 0 or right < 0
		@rigidbody.activate()
		@rigidbody.applyTorque(new Ammo.btVector3(0, @speed * -right, 0))
		q = @rigidbody.getWorldTransform().getRotation()
	@tSinceJump += deltaTime
	if Input.jump and @tSinceJump > 1
		@rigidbody.activate()
		@rigidbody.applyCentralImpulse(new Ammo.btVector3(0, 0, -CONF.PLAYER.JUMP_FORCE))
		@tSinceJump = 0

## Exports
window.createPlayer = createPlayer
