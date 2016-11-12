###
	Constants and configuration
###

'use strict'

CONF =
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
