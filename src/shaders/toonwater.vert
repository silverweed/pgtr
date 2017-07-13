uniform vec2 speed1;
uniform vec2 speed2;
uniform sampler2D noiseTexture1;
uniform sampler2D noiseTexture2;
uniform float waveAmplitude;
uniform float time;

varying float vDisplacement;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

void main(){

	vec3 pos = vec3(modelMatrix * vec4(position, 1.0));
	vec2 uv1 = vec2 (fract(pos.x + speed1.x * time),fract(pos.y + speed1.y * time));
	vec2 uv2 = vec2 (fract(pos.x + speed2.x * time),fract(pos.y + speed2.y * time));
	float h = texture2D(noiseTexture1,uv1).x + texture2D(noiseTexture2,uv2).x;
	vDisplacement = h;
	h*= waveAmplitude;
	gl_Position = projectionMatrix * viewMatrix * (vec4 (pos.x,pos.y,pos.z+h,1.0));
}
