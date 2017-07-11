###
	Utility functions
###

'use strict'

randomPool = null
i = 0
window.nextRand = ->
	randomPool = (Math.random() for _ in [0...CONF.RANDOM_POOL_SIZE]) unless randomPool
	i = (i + 1) % CONF.RANDOM_POOL_SIZE
	randomPool[i]

windowRatio = ->
	window.innerWidth / window.innerHeight

window.windowRatio = windowRatio
