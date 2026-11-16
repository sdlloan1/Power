#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif


uniform sampler2D u_textureSrc;

precision mediump float;

uniform int u_FirstPhase;

varying vec2 v_texCoords;

void main(void)
{
	if(u_FirstPhase > 0)
		gl_FragColor = texture2D(u_texture0, v_texCoords);
	else
		gl_FragColor = texture2D(u_textureSrc, v_texCoords);
}
