###
	Event Listeners
###

'use strict'

# This object will contain all the keys appearing in CONF.CONTROLS
# with value `true` or `false` depending on whether that key is currently
# pressed or not.
Input = {}

hdKey = (down) ->
	(e) ->
		for key, val of CONF.CONTROLS
			if `e.keyCode == val`
				l "setting Input[#{key}]"
				Input[key] = down
				return

window.addEventListener('keydown', hdKey(true), false)
window.addEventListener('keyup', hdKey(false), false)

window.Input = Input
