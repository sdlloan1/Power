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
varying vec2 v_mskCoords;


void main(){
	vec4 distortionValues = texture2D(u_distortionMask, v_mskCoords);
	
	float disX = distortionValues.r + distortionValues.g / 256.0;
	float disY = distortionValues.b + distortionValues.a / 256.0;
	
	vec2 texCoords = v_texCoords;
	texCoords.x += ( disX - 0.5 );
	texCoords.y += ( disY - 0.5 );
	
	gl_FragColor = texture2D(u_texture0, texCoords);
}
