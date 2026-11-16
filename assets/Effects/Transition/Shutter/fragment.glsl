precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform float fSliceRange;
uniform int imode;

void main(){
	float fSliceProgress;
	if(imode == 0){
		fSliceProgress = 1.0 - mod(v_texCoords.y, fSliceRange) / fSliceRange;
	}
	else if(imode == 1){
		fSliceProgress = mod(v_texCoords.y, fSliceRange) / fSliceRange;
	}
	else if(imode == 2){
		fSliceProgress = 1.0 - mod(v_texCoords.x, fSliceRange) / fSliceRange;
	}
	else {
		fSliceProgress = mod(v_texCoords.x, fSliceRange) / fSliceRange;
	}

	if(fSliceProgress < fProgress) {
		gl_FragColor = texture2D(u_texture1, v_texCoords);
	}
	else {
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	}
}