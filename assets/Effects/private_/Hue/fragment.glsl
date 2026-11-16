#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureMask;

precision mediump float;
uniform float u_Offset;
varying vec2 v_texCoords;

vec4 HSL_To_RGB(vec4 v4HSL)
{
    float fP;
    float fQ;

    if(v4HSL.b < 0.5)
        fQ = v4HSL.b * (1.0 + v4HSL.g);
    else
        fQ = v4HSL.b + v4HSL.g - (v4HSL.b * v4HSL.g);

    fP = (v4HSL.b * 2.0) - fQ;

    float fHue = v4HSL.r / 360.0;

    float tR = mod(fHue + 0.3333333333, 1.0);
    float tG = fHue;
    float tB = mod(fHue - 0.3333333333 + 1.0, 1.0);

    vec4 v4RGB = vec4(1.0, 1.0, 1.0, 1.0);

    if(tR < 0.1666666666)
        v4RGB.r = fP + ((fQ - fP) * 6.0 * tR);
    else if(tR < 0.5)
        v4RGB.r = fQ;
    else if(tR < 0.6666666667)
        v4RGB.r = fP + ((fQ - fP) * 6.0 * (0.6666666667 - tR));
    else
        v4RGB.r = fP;

    if(tG < 0.1666666666)
        v4RGB.g = fP + ((fQ - fP) * 6.0 * tG);
    else if(tG < 0.5)
        v4RGB.g = fQ;
    else if(tG < 0.6666666667)
        v4RGB.g = fP + ((fQ - fP) * 6.0 * (0.6666666667 - tG));
    else
        v4RGB.g = fP;

    if(tB < 0.1666666666)
        v4RGB.b = fP + ((fQ - fP) * 6.0 * tB);
    else if(tB < 0.5)
        v4RGB.b = fQ;
    else if(tB < 0.6666666667)
        v4RGB.b = fP + ((fQ - fP) * 6.0 * (0.6666666667 - tB));
    else
        v4RGB.b = fP;

    return v4RGB;
}

vec4 RGB_To_HSL(vec4 v4RGB)
{
    float fMax = max(max(v4RGB.r, v4RGB.g), v4RGB.b);
    float fMin = min(min(v4RGB.r, v4RGB.g), v4RGB.b);
    float fDiffMm = fMax - fMin;

    vec4 v4HSL;
    if(fMax == fMin)
        v4HSL.r = 0.0;
    else if(fMax == v4RGB.r)
        v4HSL.r = mod((((v4RGB.g - v4RGB.b) / fDiffMm) * 60.0) + 360.0, 360.0);
    else if(fMax == v4RGB.g)
        v4HSL.r = (((v4RGB.b - v4RGB.r) / fDiffMm) * 60.0) + 120.0;
    else if(fMax == v4RGB.b)
        v4HSL.r = (((v4RGB.r - v4RGB.g) / fDiffMm) * 60.0) + 240.0;

    v4HSL.b = fMax + fMin;

    if(fMax == fMin)
        v4HSL.g = 0.0;
    else if(v4HSL.b <= 1.0)
        v4HSL.g = fDiffMm / v4HSL.b;
    else
        v4HSL.g = fDiffMm / (2.0 - v4HSL.b);

    v4HSL.b = v4HSL.b * 0.5;

    return  v4HSL;
}

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);

    vec4 v4SrcHSL = RGB_To_HSL(v4Src);

    v4SrcHSL.r = mod(v4SrcHSL.r + u_Offset, 360.0);

    gl_FragColor = vec4(mix(v4Src, HSL_To_RGB(v4SrcHSL), texture2D(u_textureMask, v_texCoords).a).rgb, v4Src.a);
}