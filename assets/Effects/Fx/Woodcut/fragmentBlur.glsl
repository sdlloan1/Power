#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif

uniform sampler2D u_texture1;

precision mediump float;

uniform int u_IntensityConvert;
uniform int u_TxIndex;
uniform int u_Radius;
uniform vec2 u_TexelSize;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Sum = vec4(0.0, 0.0, 0.0, 0.0);

    if(u_TxIndex == 0)
    {
        for(int index = -u_Radius ; index <= u_Radius ; ++index)
            v4Sum += texture2D(u_texture0, v_texCoords + (u_TexelSize * float(index)));
    }
    else
    {
        for(int index = -u_Radius ; index <= u_Radius ; ++index)
            v4Sum += texture2D(u_texture1, v_texCoords + (u_TexelSize * float(index)));
    }

    v4Sum /= float((u_Radius * 2) + 1);

    if(u_IntensityConvert > 0)
    {
        float fIntensity = dot(v4Sum, vec4(0.257, 0.504, 0.098, 0.0)) + 0.062745;
        gl_FragColor = vec4(fIntensity, fIntensity, fIntensity, 1.0);
    }
    else
        gl_FragColor = vec4(v4Sum.rgb, 1.0);
}