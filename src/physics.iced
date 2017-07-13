###
	Interface to Ammo.js for physics simulation
###

'use strict'

class Physics
	constructor: ->
		# Setup Bullet
		@broadphase = new Ammo.btDbvtBroadphase()
		@collConf = new Ammo.btDefaultCollisionConfiguration()
		@dispatcher = new Ammo.btCollisionDispatcher(@collConf)
		@solver = new Ammo.btSequentialImpulseConstraintSolver()
		@dynamicsWorld = new Ammo.btDiscreteDynamicsWorld(
			@dispatcher,
			@broadphase,
			@solver,
			@collConf
		)
		@dynamicsWorld.setGravity(new Ammo.btVector3(0, CONF.PHYSICS.GRAVITY, 0))
		@bodies = []
		@enabled = true

	createGround: ->
		groundShape = new Ammo.btStaticPlaneShape(new Ammo.btVector3(0, 1, 0), 1)
		groundMotionState = new Ammo.btDefaultMotionState(new Ammo.btTransform(
						new Ammo.btQuaternion(0, 0, 0, 1),
						new Ammo.btVector3(0, -1.8, 0)))
		groundRigidBodyCI = new Ammo.btRigidBodyConstructionInfo(
						0, # infinite mass
						groundMotionState,
						groundShape,
						new Ammo.btVector3(0, 0, 0))
		groundRigidBody = new Ammo.btRigidBody(groundRigidBodyCI)
		@dynamicsWorld.addRigidBody(groundRigidBody)
		this

	# Adds a rigidbody bound to the given THREE object.
	# Can optionally pass the following options:
	# 	- mass (default: 1)
	# 	- collisionShape (default: btSphereShape)
	# 	- collisionShapeArgs (array)
	# 	- static (default: false)
	addRigidBody: (threeObj, opts) ->
		# Determine the shape of the collider
		shape = null
		switch opts?.collisionShape
			when 'btBoxShape'
				shape = new Ammo.btBoxShape(new Ammo.btVector3(
					threeObj.scale.x / 2,
					threeObj.scale.y / 2,
					threeObj.scale.z / 2
				))
			when 'btSphereShape', undefined
				shape = new Ammo.btSphereShape(threeObj.scale.x)
			when 'btCylinderShape'
				shape = new Ammo.btCylinderShape(new Ammo.btVector3(opts.collisionShapeArgs[0],
					opts.collisionShapeArgs[1], opts.collisionShapeArgs[2]))
			else
				shape = new Ammo[opts.collisionShape](opts.collisionShapeArgs...)

		# Set the motion state
		# http://bulletphysics.org/mediawiki-1.5.8/index.php/MotionStates
		pos = threeObj.position
		q = threeObj.quaternion
		motionState = new Ammo.btDefaultMotionState(new Ammo.btTransform(
			#new Ammo.btQuaternion(0, 0, 0, 1),
			new Ammo.btQuaternion(q.x, q.y, q.z, q.w),
			new Ammo.btVector3(pos.x, pos.y, pos.z))
		)

		# Set physics parameters
		mass = if opts?.static then 0 else (opts?.mass ? 1)
		inertia = new Ammo.btVector3(0, 0, 0)
		shape.calculateLocalInertia(mass, inertia)
		rbCI = new Ammo.btRigidBodyConstructionInfo(
			mass
			motionState
			shape
			inertia
		)

		# Instance the RigidBody
		rb = new Ammo.btRigidBody(rbCI)
		if opts?.static
			rb.setCollisionFlags(Ammo.CF_STATIC_OBJECT)
		else
			rb.setDamping(CONF.PHYSICS.DFLT_LIN_DAMP, CONF.PHYSICS.DFLT_ANG_DAMP)
			# Restrict rotation along axes
			if opts?.lockedAxes?
				rb.setAngularFactor(new Ammo.btVector3(
					if 'x' in opts.lockedAxes then 0 else 1,
					if 'y' in opts.lockedAxes then 0 else 1,
					if 'z' in opts.lockedAxes then 0 else 1
				))

		# Add the rigidbody to the threejs object for easy access
		threeObj.rigidbody = rb
		@dynamicsWorld.addRigidBody(rb)
		@bodies.push [rb, threeObj]
		l "Adding #{threeObj} to physics world. Phys world size = #{@bodies.length}"
		this

	# http://bulletphysics.org/mediawiki-1.5.8/index.php/Hello_World
	# http://www.bulletphysics.org/mediawiki-1.5.8/index.php/Stepping_The_World#fixedTimeStep_resolution
	step: (timeStep, subdivisions = 1, fixedTimeStep = 1/60.0) ->
		# Check we're not losing time
		if timeStep >= subdivisions * fixedTimeStep
			console.warn("timeStep >= subdivisions * fixedTimeStep " +
				"(#{timeStep} >= #{subdivisions} * #{fixedTimeStep} " +
				"(= #{subdivisions*fixedTimeStep})): " +
				"simulation is losing time!")
		@dynamicsWorld.stepSimulation(timeStep, subdivisions, fixedTimeStep)
		# Sync threejs objects with bullet data
		@bodies.forEach ([body, obj]) ->
			# Read the object
			transform = new Ammo.btTransform()
			body.getMotionState().getWorldTransform(transform)
			origin = transform.getOrigin()
			rot = transform.getRotation()
			obj.position.set(origin.x(), origin.y(), origin.z())
			obj.quaternion.set(rot.x(), rot.y(), rot.z(), rot.w())
		this

window.Physics = Physics
