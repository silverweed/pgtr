uniform vec4 fogColor;
uniform float fogExp;
float maxVisionDepth;
float minVisionDepth;
float near;
float far;

uniform sampler2D renderedScene;
uniform sampler2D depthTexture;

varying vec2 vUv;

float nlDepth(float lDepth){
	float nl_Depth = (far + near - 2.0 * near * far / lDepth)/(far - near);
	nl_Depth = (nl_Depth +1.0)/2.0;
	return nl_Depth;
}

void main(){	
	float z_b = texture2D(depthTexture, vUv).r;
	float z_n = 2.0 * z_b - 1.0;
	float z_e = 2.0 * near * far  / (near + far - z_n * (far - near));
	
	vec4 color = texture2D(renderedScene, vUv);

	gl_FragColor = vec4(vec3(z_e),1.0);
		//(1.0 - alpha)*color + alpha * fogColor;

}
