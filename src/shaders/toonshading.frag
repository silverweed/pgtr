

varying vec3 vLightResult;
uniform int nBands;

void main(){
	float floatbands = (float) nBands;
	float intensity = ceil((length(vLightResult)*nBands)/nBands);
	
	gl_FragColor = vLightResult * intensity;

}
