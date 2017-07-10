uniform int nBands;
uniform sampler2D map;
uniform float shininess;
uniform float reflectivity;
uniform vec4 color;
uniform vec4 specular;

varying vec3 vLightResult;
varying vec3 vPosition;

uniform vec3 directionalLightDirection;
uniform vec3 directionalLightColor;
uniform float directionalLightIntensity;

void main(){
	float floatbands = float(nBands);

	vec3 V = normalize(-vPosition);
	float specMultiplier = max(dot(
				normalize(-directionalLightDirection + V),normal)
			,0.0);
	specMultiplier *= pow(specMultiplier, shininess);
	specMultiplier = ceil(specMultiplier*floatbands)/floatbands;

	vLightResult = dot(vNormal, directionalLightDirection)*directionalLightColor * directionalLightIntensity;
	float lightMultiplier = ceil((length(vLightResult)*floatbands))/floatbands;

	vec4 shadedColor = texture(map, vUv)*color*lightMultiplier;
	vec4 shadedSpec = specular * specular;
	gl_FragColor = shadedColor + shadedSpec;

}
