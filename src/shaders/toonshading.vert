#define MAXLIGHTS 10
#define MAXDISTANCE 30

//uniform PointLight[] pointLights
//uniform AmbientLight ambientLight;
varying vec3 vPosition;
varying vec3 vNormal;
varying vec3 vViewNormal;
varying vec2 vUv;

void main()
{

	vec4 mvPosition =  viewMatrix * modelMatrix * vec4 (position, 1.0);
	vPosition = vec3(mvPosition/ mvPosition.w)- cameraPosition;
	vNormal =  mat3(modelMatrix)*normal;
	vViewNormal = normalMatrix * normal;
	vUv = uv;
	gl_Position = projectionMatrix * mvPosition;
}
