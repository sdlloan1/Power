#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;

void main(){
	vec4 result;
	if(0.1*abs(sin((v_texCoords.x+fProgress*5.0)*10.0))+(1.0-fProgress*1.1) < v_texCoords.y){
		result = texture2D(u_texture1, v_texCoords);
	}
	else {
		result = texture2D(u_texture0, v_texCoords);
	}
	
	gl_FragColor = result;
}
