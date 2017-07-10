###
	Functions that deal with the shaders
###

'use strict'

asyncBuildShaderCache -> 
	asyncLoadShader("toonshading.vert", defer _)
	asyncLoadShader("toonshading.frag", defer _)
	asyncLoadShader("depthfog.vert", defer _)
	asyncLoadShader("depthfog.frag", defer _)
	null

window.asyncBuildShaderCache = asyncBuildShaderCache
