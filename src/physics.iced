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
					@collConf)
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

	addRigidBody: (threeObj, opts) ->
		shape = new Ammo.btSphereShape(threeObj.scale.x)
		pos = threeObj.position
		motionState = new Ammo.btDefaultMotionState(new Ammo.btTransform(
						new Ammo.btQuaternion(0, 0, 0, 1),
						new Ammo.btVector3(pos.x, pos.y, pos.z)))
		mass = opts?.mass ? 1
		inertia = new Ammo.btVector3(0, 0, 0)
		shape.calculateLocalInertia(mass, inertia)
		rbCI = new Ammo.btRigidBodyConstructionInfo(
						mass
						motionState
						shape
						inertia)
		rb = new Ammo.btRigidBody(rbCI)
		rb.setDamping(CONF.PHYSICS.DFLT_LIN_DAMPING, CONF.PHYSICS.DFLT_ANG_DAMPING)
		# Add the rigidbody to the threejs object for easy access
		threeObj.rigidbody = rb
		@dynamicsWorld.addRigidBody(rb)
		@bodies.push [rb, threeObj]
		this

		# TODO
		#fallShape = new Ammo.btSphereShape(1)
		#fallMotionState = new Ammo.btDefaultMotionState(new btTransform(
		#				new Ammo.btQuaternion(0, 0, 0, 1),
		#				new Ammo.btVector3(0, 50, 0)))
		#fallMass = 1
		#fallInertia = new Ammo.btVector3(0, 0, 0)
		#fallShape.calculateLocalInertia(fallMass, fallInertia)
		#fallRigidBodyCI = new Ammo.btRigidBodyConstructionInfo(
		#				fallMass,
		#				fallMotionState,
		#				fallShape,
		#				fallInertia)
		#fallRigidBody = new Ammo.btRigidBody(fallRigidBodyCI)
		#dynamicsWorld.addRigidBody(fallRigidBody)

	#http://www.bulletphysics.org/mediawiki-1.5.8/index.php/Stepping_The_World#fixedTimeStep_resolution
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
