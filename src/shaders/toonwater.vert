uniform vec2 speed1;
uniform vec2 speed2;
uniform sampler2D noiseTexture1;
uniform sampler2D noiseTexture2;
uniform float waveAmplitude;
uniform float time;
uniform float size1;
uniform float size2;

varying float vDisplacement;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

void main(){

	vec3 pos = vec3(modelMatrix * vec4(position, 1.0));
	vec2 uv1 = vec2(mod(pos.x + speed1.x * time, size1)/size1,mod(pos.z + speed1.y * time, size1)/size1);
	vec2 uv2 = vec2(mod(pos.x + speed2.x * time, size2)/size2,mod(pos.z + speed2.y * time, size2)/size2);
	/*vec2 uv1 = vec2(fract((pos.x + speed1.x * time)*size1),fract(pos.z + speed1.y/size1 * time));*/
	/*vec2 uv2 = vec2 (fract(pos.x + speed2.x/size2 * time),fract(pos.z + speed2.y/size2 * time));*/
	float h = 0.7*texture2D(noiseTexture1,uv1).x + 0.3*texture2D(noiseTexture2,uv2).x;
	h-=0.2;
	vDisplacement = h;
	h*= waveAmplitude;
	gl_Position = projectionMatrix * viewMatrix * (vec4(pos.x,pos.y+h,pos.z,1.0));
}
