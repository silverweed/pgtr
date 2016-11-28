###
	Constants and configuration
###

'use strict'

CONF =
	PLAYER:
		SPEED: 100

	CONTROLS:
		forward:  [ 87 ] # W
		backward: [ 83 ] # S
		righT:    [ 68 ] # D
		left:     [ 65 ] # A
		jump:     [ 32 ] # Space(?)
		sunPitchRaise: [ 107 ] # Numpad+
		sunPitchLower: [ 109 ] # Numpad-
		
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
		Z: -50

Object.freeze(CONF)


## Exports
window.CONF = CONF
