#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision highp float;

uniform mat4 u_RGB2YUV;
uniform mat4 u_YUV2RGB;

uniform vec2 u_v2ViewDimension;
uniform vec2 u_v2LightDimensionSqr;
uniform vec2 u_v2LightCenter;
uniform int u_BKUVCheck;
uniform float u_ScaleUV;
uniform vec2 u_ShiftUV;
uniform float u_Depth;
uniform float u_MeanI;
uniform float u_MaxI;
uniform float u_Gamma;

varying vec2 v_texCoords;

float ConStret(float fY)
{
    float fPow = pow(u_MeanI / fY, u_Gamma);
    return 1.0 / (1.0 + fPow) / u_MaxI;
}

float DiffI(float fY)
{
    float fPow = pow(u_MeanI / fY, u_Gamma);
    return 1.0 / (1.0 + fPow) / u_MaxI - fY;
}

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fAlpha = v4Src.a;
    v4Src.a = 1.0;

    vec4 v4SrcYUV = u_RGB2YUV * v4Src;

    vec2 v2Dis = (v_texCoords - u_v2LightCenter) * u_v2ViewDimension;
    v2Dis = v2Dis * v2Dis / u_v2LightDimensionSqr;
    float fRatio = v2Dis.x + v2Dis.y;

    vec4 v4DstYUV = v4SrcYUV;
    if(fRatio < 1.0)
    {
        v4DstYUV.r = ConStret(v4SrcYUV.r);
        if(u_BKUVCheck > 0)
        {
            v4DstYUV.g = (v4SrcYUV.g * u_ScaleUV + u_ShiftUV.x + v4SrcYUV.g) * 0.5;
            v4DstYUV.b = (v4SrcYUV.b * u_ScaleUV + u_ShiftUV.y + v4SrcYUV.b) * 0.5;
        }
    }
    else if(fRatio < u_Depth)
    {
        float fSat = 1.0 - ((fRatio - 1.0) / u_Depth);
        v4DstYUV.r = v4DstYUV.r + (DiffI(v4SrcYUV.r) * fSat);

        if(u_BKUVCheck > 0)
        {
            fSat *= 0.5;

            v4DstYUV.g = (v4SrcYUV.g * u_ScaleUV + u_ShiftUV.x) * fSat;
            v4DstYUV.g += v4SrcYUV.g * (1.0 - fSat);

            v4DstYUV.b = (v4SrcYUV.b * u_ScaleUV + u_ShiftUV.y) * fSat;
            v4DstYUV.b += v4SrcYUV.b * (1.0 - fSat);
        }
    }

    v4DstYUV -= vec4(0.062745, 0.5, 0.5, 0.0);

    gl_FragColor = vec4((u_YUV2RGB * v4DstYUV).rgb, fAlpha);
}