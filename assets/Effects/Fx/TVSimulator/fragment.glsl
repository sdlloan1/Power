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
uniform float u_MaskScaleX;
uniform float u_MaskScaleY;
varying vec2 v_texCoords;


void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 distortionValues = texture2D(u_distortionMask, vec2(0.0, v_texCoords.x * u_MaskScaleX + v_texCoords.y * u_MaskScaleY));
	
	gl_FragColor = vec4((v4Src + v4Src * distortionValues).rgb, v4Src.a);
}
