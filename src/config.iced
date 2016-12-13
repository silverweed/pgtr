###
	Constants and configuration
###

'use strict'

CONF =
	PLAYER:
		SPEED: 100
		JUMP_FORCE: 100

	CONTROLS:
		forward:  [ 87 ] # W
		backward: [ 83 ] # S
		right:    [ 68 ] # D
		left:     [ 65 ] # A
		jump:     [ 32 ] # Space(?)
		sunPitchRaise: [ 107 ] # Numpad+
		sunPitchLower: [ 109 ] # Numpad-
		togglePhysics: [ 70 ] # F
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
	
	PHYSICS:
		GRAVITY: -100
		SUBSTEPS: 7
		DFLT_LIN_DAMPING: 0.7
		DFLT_ANG_DAMPING: 0.99999
	
	SUN:
		COLOR: 0xffdf80

Object.freeze(CONF)


## Exports
window.CONF = CONF
