###
	Constants and configuration
###

'use strict'

CONF =
	PLAYER:
		SPEED: 1000
		JUMP_FORCE: 200
		JUMP_MAX_Y: 5

	CONTROLS:
		forward:  [ 87 ] # W
		backward: [ 83 ] # S
		right:    [ 68 ] # D
		left:     [ 65 ] # A
		jump:     [ 32 ] # Space(?)
		sunPitchRaise: [ 107 ] # Numpad+
		sunPitchLower: [ 109 ] # Numpad-
		sunRotateCW:   [ 102 ] # Numpad6
		sunRotateCCW:  [ 100 ] # Numpad4
		togglePhysics: [ 70  ] # F
		togglePostProcess: [ 80 ] # P
		
	SKYBOX:
		URLS: [
			'textures/skybox/px.jpg'
			'textures/skybox/nx.jpg'
			'textures/skybox/py.jpg'
			'textures/skybox/ny.jpg'
			'textures/skybox/pz.jpg'
			'textures/skybox/nz.jpg'
		]
		SIZE: 10000
	
	OCEAN:
		URL: 'textures/waternormals.jpg'
		Y: 0
		RIPPLES:
			UPDATE_DELAY: 0.1
			LIFETIME: 3
	
	PHYSICS:
		FIXED_TIME_STEP: 1/60.0
		GRAVITY: -120
		SUBSTEPS: 7
		DFLT_LIN_DAMP: 0.7
		DFLT_ANG_DAMP: 0.99999
		BUOYANCY: 6
		BUOYANCY_WATER_LEVEL: 15

	RANDOM_POOL_SIZE: 1000
	
	SUN:
		COLOR: 0xffdf80

	FOG:
		COLOR: 0xffdf80
		DENSITY: 0.0055

Object.freeze(CONF)


## Exports
window.CONF = CONF
