

varying vec3 vLightResult;
uniform int nBands;

void main(){
	float floatbands = float(nBands);
	float intensity = ceil((length(vLightResult)*floatbands)/floatbands);
	
	gl_FragColor =vec4(vLightResult * intensity, 1.0);

}
