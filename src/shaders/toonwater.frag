uniform vec4 foamColor;
uniform vec4 waterColor;

varying float vDisplacement;

void main(){
	//gl_FragColor = vec4(vDisplacement);
	//return;
	float blend = pow(1.0-vDisplacement,2.0);
	blend = 1.0-blend;
	blend = ceil(vDisplacement*6.0)/6.0;
	gl_FragColor = (1.0- blend)*waterColor + blend*foamColor;
}
