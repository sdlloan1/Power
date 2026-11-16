#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;
varying vec2 v_texCoords;

uniform float u_Opacity;

uniform int u_FlipHorizontal;
uniform int u_FlipVertical;

uniform int u_handleAlphaRecovery;

void main(){
	vec2 v1 = v_texCoords;

	if (u_FlipHorizontal > 0) {
		v1.x = 1.0 - v1.x;
	}
	if (u_FlipVertical > 0) {
		v1.y = 1.0 - v1.y;
	}

	vec4 v4Src =  texture2D(u_texture0, v1);
	if((u_handleAlphaRecovery>0)&&(v4Src.a>0.0)){
		v4Src.rgb /= v4Src.a;
	}

	gl_FragColor = v4Src * u_Opacity;
}
