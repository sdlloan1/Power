#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_texDistortion;

precision highp float;

uniform float u_Degree;
uniform vec2 u_TexelSize;

varying vec2 v_texCoords;

void main()
{
    vec2 v2Distortion = texture2D(u_texDistortion, v_texCoords).ba;
    v2Distortion = v2Distortion * 25.5 * u_Degree * u_TexelSize;

	gl_FragColor = texture2D(u_texture0, v_texCoords + v2Distortion);
}