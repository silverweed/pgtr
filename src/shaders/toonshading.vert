#define MAXLIGHTS 10
#define MAXDISTANCE 30

struct PointLight{
	vec4 position;
	vec3 color;
	float intensity;
};

struct DirectionalLight{
	vec3 direction;
	vec3 color;
	float intensity;
};

struct AmbientLight{
	vec3 color;
	float intensity;
};

//uniform PointLight[] pointLights;
uniform vec3 directionalLightDirection;
uniform vec3 directionalLigthColor;
uniform float direactionalLightIntensity;
//uniform AmbientLight ambientLight;
varying vec3 vLightResult;

void main()
{
	vec4 myPosition = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
	vec3 lightResult = vec3(0,0,0);
	vec3 myNormal = normalize( normalMatrix * normal );
	/*for(int i =0;i<MAXLIGHTS;i++){*/
		/*lightResult += (distance(pointLights[i].position,myPosition) / MAXDISTANCE)*/
			/** color * intensity * dot(normalize(pointLights[i].position - myPosition), myNormal);*/
	/*}*/

	lightResult += dot ( directionalLightDirection , myNormal )*directionalLigthColor*direactionalLightIntensity;
	//lightResult += ambientLight*intensity;

	vLightResult = lightResult;

    gl_Position = myPosition;
}
