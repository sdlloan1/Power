#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform int u_LargeLevel;
uniform int u_SmallLevel;

uniform vec3 u_ColorDark;
uniform vec3 u_ColorMiddle;
uniform vec3 u_ColorLight;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fAlpha = v4Src.a;
    v4Src *= 255.0;
    int nTotalLevel = int(v4Src.r) + int(v4Src.g) + int(v4Src.b);

    if(nTotalLevel >= u_LargeLevel)
        gl_FragColor = vec4(u_ColorLight, fAlpha);
    else if(nTotalLevel <= u_SmallLevel)
        gl_FragColor = vec4(u_ColorDark, fAlpha);
    else
        gl_FragColor = vec4(u_ColorMiddle, fAlpha);
}