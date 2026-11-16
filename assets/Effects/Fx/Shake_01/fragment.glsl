#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform vec2 u_Offset;

varying vec2 v_texCoords;

void main(void)
{
	gl_FragColor = texture2D(u_texture0, v_texCoords - u_Offset);
}