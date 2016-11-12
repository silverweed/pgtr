###
	Functions dealing with UI
###

createStats = ->
	stats = new Stats()
	stats.domElement.style.position = 'fixed'
	stats.domElement.style.top = '0px'
	stats.domElement.style.right = '0px'
	stats.domElement.style.zIndex = 100
	stats


## Exports
window.createStats = createStats
