'use strict'

window.l = console.log

window.createSunlightControls = (sunlight) ->
	{
		update: (delta) ->
			shift = 1
			if Input.sunPitchLower
				l "pitch lower"
				sunlight.rotate(0, 0, -shift * delta)
				#sunlight.target.position.add(new THREE.Vector3(0, 0, -shift * delta))
				#sunlight.rotateZ(delta)
				#sunlight.gizmo?.rotateZ(delta)
				#sunlight.updateMatrixWorld()
			if Input.sunPitchRaise
				l "pitch raise"
				sunlight.rotate(0, 0, shift * delta)
				#sunlight.target.position.add(new THREE.Vector3(0, 0, shift * delta))
				#sunlight.rotateZ(-delta)
				#sunlight.gizmo?.rotateZ(-delta)
				#sunlight.updateMatrixWorld()
	}

window.createPhysicsControls = (physics) ->
	window.addEventListener('keyup', (e) ->
		if `e.keyCode == CONF.CONTROLS.togglePhysics`
			physics.enabled = !physics.enabled
		true
	)
