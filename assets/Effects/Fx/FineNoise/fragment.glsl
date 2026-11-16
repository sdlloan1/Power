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

uniform sampler2D u_distortionMask; 

uniform float u_Grain;
uniform float u_OffsetX;
uniform float u_OffsetY;
varying vec2 v_texCoords;


void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Noise = texture2D(u_distortionMask, (v_texCoords * 0.8) + vec2(u_OffsetX, u_OffsetY));
	float fNoise = (v4Noise.r - 0.5) * u_Grain;

	gl_FragColor = v4Src + vec4(fNoise, fNoise, fNoise, 0.0);
}
