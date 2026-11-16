#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureMask;

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fGray = dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0));

    float fRatio = texture2D(u_textureMask, v_texCoords).a;

    gl_FragColor = vec4(mix(vec4(fGray), v4Src, fRatio).rgb, v4Src.a);
}