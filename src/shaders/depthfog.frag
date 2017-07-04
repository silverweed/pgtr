
uniform vec4 fogColor;
uniform float near;
uniform float far;

uniform sampler2D renderedScene;
uniform sampler2D depthTexture;


varying vec2 vUv;

void main(){	
	float z_b = texture2D(depthTexture, vUv).r;
	float dep = (2.0 * near)/ ( far + near - z_b * (far - near));
	vec4 color = texture2D(renderedScene, vUv);
	float alpha = dep;

	if(alpha  <0.03){
		alpha = 0.0;
	}else if( alpha < 0.3){
		//alpha =0.2;
		alpha = (alpha -0.03)/0.27;
	}else if(alpha < 0.99){
		alpha = 1.0;
	}else{
		alpha = 0.0;
	}
		
	vec4 tmpcolor = (1.0 - alpha)*color + alpha* fogColor;
	gl_FragColor = tmpcolor;
	return;
}
