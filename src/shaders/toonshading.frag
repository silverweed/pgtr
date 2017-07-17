uniform int nBands;
uniform sampler2D map;
uniform float shininess;
uniform float reflectivity;
uniform vec4 color;
uniform vec4 specular;
uniform float ks;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;
varying vec3 vViewNormal;

uniform vec3 directionalLightDirection;
uniform vec4 directionalLightColor;
uniform float directionalLightIntensity;

uniform vec4 ambientColor;
uniform float ambientIntensity;

void main(){
	float floatbands = float(nBands);
	vec3 dirlightNorm = normalize(-directionalLightDirection);
	vec3 V = normalize(-vPosition);
	float lightres = max(dot(vNormal, dirlightNorm),0.0)* directionalLightIntensity;
	float specMultiplier = max(dot(
				normalize(dirlightNorm + V),normalize(vNormal))
			,0.0);
	specMultiplier = pow(specMultiplier, shininess*10.0);
	float fres = 1.0-max(dot(normalize(vViewNormal),vec3(0.0,0.0,1.0)),0.0);
	fres = pow(fres, 5.0);
	fres = floor(fres*floatbands)/floatbands;
	specMultiplier = floor(specMultiplier*floatbands)/(floatbands);
	specMultiplier *= ks;
	float lightMultiplier = fres + ambientIntensity + lightres;
	lightMultiplier = clamp( lightMultiplier , 0.0, 1.0);
	lightMultiplier = ceil(lightMultiplier*floatbands)/floatbands;
	vec4 shadedColor = texture2D(map, vUv) * lightMultiplier;
	vec4 shadedSpec = specular * specMultiplier;
	gl_FragColor = ((1.0 - specMultiplier)*shadedColor + shadedSpec) + ambientIntensity*ambientColor ;
	return;
}
