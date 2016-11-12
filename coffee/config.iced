###
	Constants and configuration
###

'use strict'

CONF =
	PLAYER:
		SPEED: 100

	CONTROLS:
		FORWARD:  [ 87 ] # W
		BACKWARD: [ 83 ] # S
		RIGHT:    [ 68 ] # D
		LEFT:     [ 65 ] # A
		JUMP:     [ 32 ] # Space(?)
		
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

Object.freeze(CONF)


## Exports
window.CONF = CONF
