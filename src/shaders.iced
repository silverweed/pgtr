###
	Functions that deal with the shaders
###

'use strict'

asyncBuildShaderCache = -> 
	await
		asyncLoadShader("toonshading.vert", defer bla)
		asyncLoadShader("toonshading.frag", defer bla)
		asyncLoadShader("depthfog.vert", defer bla)
		asyncLoadShader("depthfog.frag", defer bla)
	null

window.asyncBuildShaderCache = asyncBuildShaderCache
