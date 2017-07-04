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
	mesh = object.children[0].geometry
	if mesh
		console.assert(mesh.animations, 'Player mesh has no animations!')
		player.anim = {
			mixer: create('AnimationMixer', mesh)
			clips: mesh.animations
			updateAnimation: updateAnimation
		}
	player

updatePlayer = (deltaTime) ->
	# Probably FIXME
	@canJump = @position.y < 2.2

	# Forward / Backward
	fwd = (Input.forward ? 0) - (Input.backward ? 0)
	if fwd > 0 or fwd < 0
		@rigidbody.activate()
		q = @rigidbody.getWorldTransform().getRotation()
		p = new Ammo.btQuaternion(0, 1, 0, 0)
		# I have NO CLUE why I have to multiply angle by 2, but it apparently works.
		p.setRotation(q.getAxis(), q.getAngle() * 2)
		f = p.op_mul(@speed * fwd)
		@rigidbody.applyCentralForce(new Ammo.btVector3(f.y(), f.z(), f.w()))

	# Turn left / right
	right = (Input.right ? 0) - (Input.left ? 0)
	if right > 0 or right < 0
		@rigidbody.activate()
		@rigidbody.applyTorque(new Ammo.btVector3(0, @speed * -right, 0))
		q = @rigidbody.getWorldTransform().getRotation()

	# Jump
	if Input.jump and @canJump
		@rigidbody.activate()
		@rigidbody.applyCentralImpulse(new Ammo.btVector3(0, CONF.PLAYER.JUMP_FORCE, 0))
		@canJump = false

	@plane?.position.set(@position.x, @plane.position.y, @position.z)
	# Animation
	if @anim
		updateAnimation(@anim, fwd)

updateAnimation = (anim, fwd) ->
	clip = THREE.AnimationClip.findByName(anim.clips, switch
		when fwd < 0 then 'SwimBackwd'
		when fwd > 0 then 'Swim'
		else'Idle'
	)
	anim.mixer.clipAction(clip).play()

## Exports
window.createPlayer = createPlayer
