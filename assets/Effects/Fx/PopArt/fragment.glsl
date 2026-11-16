#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform int u_Level;
uniform int u_LargeLevel;
uniform int u_SmallLevel;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fAlpha = v4Src.a;
    v4Src *= 255.0;
    int nTotalLevel = int(v4Src.r + 0.5) + int(v4Src.g + 0.5) + int(v4Src.b + 0.5);

    if(nTotalLevel >= u_LargeLevel)
        gl_FragColor = vec4(0.9882353, 0.894117647, 0.65882353, fAlpha);
    else if(nTotalLevel >= u_Level)
        gl_FragColor = vec4(0.443137255, 0.5882353, 0.623529412, fAlpha);
    else if(nTotalLevel >= u_SmallLevel)
        gl_FragColor = vec4(0.843137255, 0.1019608, 0.129418, fAlpha);
    else
        gl_FragColor = vec4(0.0, 0.19607843, 0.30196, fAlpha);
}