###
	Event Listeners
###

'use strict'

Input =
	forward: off
	backward: off
	right: off
	left: off

Object.seal(Input)

hdKey = (down) ->
	(e) ->
		for key, val of CONF.CONTROLS
			if `e.keyCode == val`
				l "setting Input[#{key.toLowerCase()}]"
				Input[key.toLowerCase()] = down
				return

window.addEventListener('keydown', hdKey(true), false)
window.addEventListener('keyup', hdKey(false), false)

window.Input = Input
