#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_texDistortion;

precision highp float;

uniform vec2 u_TexelSize;

varying vec2 v_texCoords;


void main()
{
    vec2 v2Distortion = texture2D(u_texDistortion, v_texCoords).ba;
    v2Distortion = vec2(0.0, (v2Distortion.x + v2Distortion.y / 256.0) - 0.5);

	gl_FragColor = texture2D(u_texture0, v_texCoords + v2Distortion);
}