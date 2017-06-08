

varying vec3 vLightResult;
uniform int nBands;

void main(){
	float floatbands = float(nBands);
	/*float intensity = 0.0;*/
	float intensity = ceil((length(vLightResult)*floatbands))/floatbands;
	/*if (length(vLightResult) < 0.3)*/
		/*intensity = 0.0;*/
	/*else if (length(vLightResult) < 0.6)*/
		/*intensity = 0.5;*/
	/*else*/
		/*intensity = 1.0;*/
	
	gl_FragColor = vec4(vLightResult * intensity, 1.0);

}
