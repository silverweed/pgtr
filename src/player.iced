###
	Functions for moving the player etc
###

'use strict'

# Augments an Object3D with methods that make it controllable.
createPlayer = (object) ->
	player = Object.create(object,
		speed:  { value: CONF.PLAYER.SPEED, writable: yes, enumerable: yes }
		update: { value: updatePlayer, writable: no, enumerable: no }
	)
	player

updatePlayer = (deltaTime) ->
	# Probably FIXME
	@canJump = @position.y < CONF.PLAYER.JUMP_MAX_Y

	# Forward / Backward
	fwd = (Input.forward ? 0) - (Input.backward ? 0)
	if fwd > 0 or fwd < 0
		@rigidbody.activate()
		q = @rigidbody.getWorldTransform().getRotation()
		p = new Ammo.btQuaternion(0, 1, 0, 0)
		# I have NO CLUE why I have to multiply angle by 2, but it apparently works.
		p.setRotation(q.getAxis(), q.getAngle() * 2)
		f = p.op_mul(@speed * fwd)
		force = new Ammo.btVector3(f.y(), f.z(), f.w())
		@rigidbody.applyCentralForce(force)
		Ammo.destroy(p)
		Ammo.destroy(force)

	# Turn left / right
	right = (Input.right ? 0) - (Input.left ? 0)
	if right > 0 or right < 0
		@rigidbody.activate()
		torque = new Ammo.btVector3(0, @speed * -right, 0)
		@rigidbody.applyTorque(torque)
		q = @rigidbody.getWorldTransform().getRotation()
		Ammo.destroy(torque)

	# Jump
	if Input.jump and @canJump
		@rigidbody.activate()
		impulse = new Ammo.btVector3(0, CONF.PLAYER.JUMP_FORCE, 0)
		@rigidbody.applyCentralImpulse(impulse)
		@canJump = false
		Ammo.destroy(impulse)

	@plane?.position.set(@position.x, @plane.position.y, @position.z)

## Exports
window.createPlayer = createPlayer
