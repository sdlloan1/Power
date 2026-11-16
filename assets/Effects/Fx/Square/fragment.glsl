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

uniform sampler2D u_distortionMask; 

precision mediump float;
varying vec2 v_texCoords;


void main(){

	vec4 distortionValues = texture2D(u_distortionMask, v_texCoords);
	
	float disX = distortionValues.r + distortionValues.g / 256.0 - 0.5;
	float disY = distortionValues.b + distortionValues.a / 256.0 - 0.5;

	vec2 texCoords = v_texCoords + vec2(disX, disY);

	gl_FragColor = texture2D(u_texture0, texCoords);
}
