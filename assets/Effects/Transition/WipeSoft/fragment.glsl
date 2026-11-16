#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform int imode;

void main(){
	float fSliceProgress;
	float fBound = 0.25;
	
	if(imode == 0){
		fSliceProgress = 1.0 - v_texCoords.y;
	}
	else if(imode == 1){
		fSliceProgress = v_texCoords.y;
	}
	else if(imode == 2){
		fSliceProgress = 1.0 - v_texCoords.x;
	}
	else {
		fSliceProgress = v_texCoords.x;
	}
	
	if((fSliceProgress + fBound) < fProgress) {
		gl_FragColor = texture2D(u_texture1, v_texCoords);
	}
	else if((fSliceProgress - fBound) > fProgress) {
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	}
	else {
		float fWeight = abs((fSliceProgress - (fProgress - fBound)) /(2.0*fBound));
		gl_FragColor = texture2D(u_texture0, v_texCoords) * fWeight + texture2D(u_texture1, v_texCoords) * (1.0 - fWeight);
	}
}
