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
		@dynamicsWorld.setGravity(new Ammo.btVector3(0, -10, 0))
		@bodies = []

	createGround: ->
		groundShape = new Ammo.btStaticPlaneShape(new btVector3(0, 0, 0), 1)
		groundMotionState = new Ammo.btDefaultMotionState(new btTransform(
						new Ammo.btQuaternion(0, 0, 0, 1),
						new Ammo.btVector3(0, 0, 0)))
		groundRigidBodyCI = new Ammo.btRigidBodyConstructionInfo(
						0, # infinite mass
						groundMotionState,
						groundShape,
						new Ammo.btVector3(0, 0, 0))
		groundRigidBody = new Ammo.btRigidBody(groundRigidBodyCI)
		@dynamicsWorld.addRigidBody(groundRigidBody)

	addRigidBody: ->
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
	step: (timeStep, subdivisions, fixedTimeStep) ->
		@dynamicsWorld.stepSimulation(timeStep, subdivisions, fixedTimeStep)
		# Sync threejs objects with bullet data
		@bodies.forEach ([body, obj]) ->
			# Read the object
			transform = new Ammo.btTransform()
			body.getMotionState().getWorldTransform(transform)
			origin = transform.getOrigin()
			rot = transform.getRotation()
			obj.position.set(origin.x(), origin.y(), origin.z())
			obj.quaternion = new THREE.Quaternion(
						rot.x(),
						rot.y(),
						rot.z(),
						rot.w())
			obj.useQuaternion = yes
