'use strict'

window.l = console.log

window.createSunlightControls = (sunlight) ->
	{
		# FIXME
		update: (_delta) ->
			if Input.sunPitchLower
				l "pitch lower"
				sunlight.rotateZ(delta)
				sunlight.gizmo?.rotateZ(delta)
				sunlight.updateMatrixWorld()
			if Input.sunPitchRaise
				l "pitch raise"
				sunlight.rotateZ(-delta)
				sunlight.gizmo?.rotateZ(-delta)
				sunlight.updateMatrixWorld()
	}

window.createTogglePhysicsControls = (physics) ->
	window.addEventListener('keyup', (e) ->
		if `e.keyCode == CONF.CONTROLS.togglePhysics`
			physics.enabled = !physics.enabled
		true
	)
