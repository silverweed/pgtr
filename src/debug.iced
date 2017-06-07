'use strict'

window.l = console.log

window.createSunlightControls = (sunlight) ->
	{
		update: (delta) ->
			shift = 1
			if Input.sunPitchLower
				sunlight.rotate(-shift * delta, 0, 0)
			if Input.sunPitchRaise
				sunlight.rotate(shift * delta, 0, 0)
			if Input.sunRotateCW
				sunlight.rotate(0, 0, shift * delta)
			if Input.sunRotateCCW
				sunlight.rotate(0, 0, -shift * delta)
	}

window.createPhysicsControls = (physics) ->
	window.addEventListener('keyup', (e) ->
		if `e.keyCode == CONF.CONTROLS.togglePhysics`
			physics.enabled = !physics.enabled
		true
	)
