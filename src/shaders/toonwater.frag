uniform vec4 foamColor;
uniform vec4 waterColor;

varying vDisplacement;

void main(){
	float blend = pow(vDisplacement,6.0);
	gl_FragColor = (1.0- blend)*waterColor + blend*foamColor;
}
