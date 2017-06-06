#define MAXLIGHTS 10
#define MAXDISTANCE 30

struct PointLight{
	vec4 position;
	vec3 color;
	float intensity;
}

struct DirectionalLight{
	vec3 direction;
	vec3 color;
	float intensity;
}

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

uniform PointLight[] pointLights;
uniform DirectionalLight directionalLight;

attribute vec3 position;
attribute vec3 normal;

varying vec3 vLightResult;

void main()
{
	vec4 myPosition = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0f);
	lightResult = vec3(0,0,0);
	vec3 myNormal = normalize( normalMatrix * normal );
	for(int i =0;i<MAXLIGHTS;i++){
		lightResult += (distance(pointLights[i].position,myPosition) / MAXDISTANCE)
			* color * intensity * dot(normalize(pointLights[i].position - myPosition), myNormal);
	}

	lightResult += dot ( normalize (directionalLight.position - myPosition) , myNormal );

	vLightResult = lightResult;

    gl_Position = myPosition;
}
