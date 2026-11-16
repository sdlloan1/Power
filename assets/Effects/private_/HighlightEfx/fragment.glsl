#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureMask;

precision mediump float;

uniform float u_Highlight;
uniform float u_Shadow;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Highlight = v4Src * u_Highlight;
    vec4 v4Shadow = v4Src * u_Shadow;

    float fRatio = texture2D(u_textureMask, v_texCoords).a;

    gl_FragColor = vec4(mix(v4Shadow, v4Highlight, fRatio).rgb, v4Src.a);
}