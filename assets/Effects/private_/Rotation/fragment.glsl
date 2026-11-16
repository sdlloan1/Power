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

const float PI = 3.1415926535897932384626433832795028841971693993751;

void main(){
	gl_FragColor = texture2D(u_texture0, v_texCoords);
}
