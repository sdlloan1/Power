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
uniform float u_Period;
uniform float u_Amplitude;
varying vec2 v_texCoords;


void main(){

    float fShift = u_Amplitude * sin(v_texCoords.y * 6.2831853 / u_Period);

	gl_FragColor = texture2D(u_texture0, vec2(v_texCoords.x + fShift, v_texCoords.y));
}
