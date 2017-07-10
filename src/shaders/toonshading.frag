uniform int nBands;
uniform sampler2D map;
uniform float shininess;
uniform float reflectivity;
uniform vec4 color;
uniform vec4 specular;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUv;

uniform vec3 directionalLightDirection;
uniform vec4 directionalLightColor;
uniform float directionalLightIntensity;

void main(){
	float floatbands = float(nBands);

	vec3 V = normalize(-vPosition);
	float specMultiplier = max(dot(
				normalize(-directionalLightDirection + V),vNormal)
			,0.0);
	specMultiplier *= pow(specMultiplier, shininess);
	specMultiplier = ceil(specMultiplier*floatbands)/floatbands;

	vec4 lightres = dot(vNormal, directionalLightDirection)*directionalLightColor * directionalLightIntensity;
	float lightMultiplier = ceil((length(lightres)*floatbands))/floatbands;

	vec4 shadedColor = texture2D(map, vUv)*color*lightMultiplier;
	vec4 shadedSpec = specular * specular;
	gl_FragColor = shadedColor + shadedSpec;

}
