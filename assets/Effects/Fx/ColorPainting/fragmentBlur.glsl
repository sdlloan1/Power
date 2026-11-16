
#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_texture1;
uniform sampler2D u_textureSub;

precision mediump float;

uniform int u_TxIndex;
uniform int u_Radius;
uniform vec2 u_TexelSize;
uniform int u_IntensityConvert;
uniform int u_Substract;
uniform float u_AdjustLevel;

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
        v4Sum = vec4(fIntensity, fIntensity, fIntensity, 1.0);
    }

    if(u_Substract > 0)
    {
        vec4 v4Sub = texture2D(u_textureSub, v_texCoords);
        v4Sum = vec4(1.0, 1.0, 1.0, 1.0) - v4Sum + v4Sub; // Substract and Inv
    }

    if(u_AdjustLevel > 0.001)
        v4Sum = v4Sum * (1.0 - u_AdjustLevel) + vec4(u_AdjustLevel, u_AdjustLevel, u_AdjustLevel, u_AdjustLevel);

    gl_FragColor = vec4(v4Sum.rgb, 1.0);
}