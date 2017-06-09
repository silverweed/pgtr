uniform vec4 fogColor;
uniform float fogExp;
float maxVisionDepth;
float minVisionDepth;
float frustumLength;

uniform sampler2D renderedScene;
uniform sampler2D depthTexture;

varying vec2 vUv;

void main(){	
	float alpha = texture2D(depthTexture, vUv).r;
	vec4 depthColor = texture2D(depthTexture, vUv);
	
	//alpha = minVisionDepth + alpha*(maxVisionDepth-minVisionDepth);
		/*
	 alpha = clamp(
			(alpha - minVisionDepth)/(maxVisionDepth - minVisionDepth),
			0.0,1.0);
			*/
	vec4 color = texture2D(renderedScene, vUv);
	
	gl_FragColor = vec4(vec3(depthColor.r),1.0);
		//(1.0 - alpha)*color + alpha * fogColor;

}
