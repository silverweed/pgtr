varying vLightResult;
uniform int nBands;

void main(){
	float floatbands = (float) nBands;
	float intensity = (length(vLightResult)*nBands)/nBands;
	
	gl_FragColor = vLightResult * intensity;

}
