
uniform sampler2D u_textureSrc;
uniform sampler2D u_textureMask;
uniform sampler2D u_textureShadow;
uniform sampler2D u_textureBorder;

precision mediump float;

uniform float u_txCoordCropScale;

uniform int u_ApplyShadow;
uniform vec2 u_ShadowSamplingOffset;
uniform vec4 u_ShadowColor;
uniform int u_ShadowBlur;

uniform int u_ApplyBorder;
uniform vec4 u_BorderColorBegin;
uniform vec4 u_BorderColorEnd;
uniform vec2 u_GradientCenter;
uniform vec2 u_GradientDirection;
uniform float u_GradientLength;
uniform int u_BorderBlur;

uniform float u_Opacity;

varying vec2 v_texCoords;

void main(void)
{
    vec2 v2TxCoordCrop = (v_texCoords - vec2(0.5)) / u_txCoordCropScale + vec2(0.5);

    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);
    vec4 v4Result = vec4(0.0);

    if(u_ApplyShadow > 0)
    {
        vec4 v4ShadowMask;
        if(u_ShadowBlur > 0)
            v4ShadowMask = texture2D(u_textureShadow, v2TxCoordCrop - u_ShadowSamplingOffset);
        else
            v4ShadowMask = texture2D(u_textureMask, v2TxCoordCrop - u_ShadowSamplingOffset);

        v4Result = vec4(u_ShadowColor.rgb, u_ShadowColor.a * v4ShadowMask.r);
    }

    float fAlphaDst = 1.0;
    if(u_ApplyBorder > 0)
    {
        float fRatio = clamp(dot((v_texCoords - u_GradientCenter), u_GradientDirection) / u_GradientLength + 0.5, 0.0, 1.0);
        vec4 v4ColorBorder = mix(u_BorderColorBegin, u_BorderColorEnd, fRatio);
        vec4 v4BorderMask = texture2D(u_textureMask, v2TxCoordCrop);
        // v4ColorBorder.a already applied in mask when drawing border.
        float fBorderAlpha;
        if(u_BorderBlur > 0)
            fBorderAlpha = texture2D(u_textureBorder, v2TxCoordCrop).r * (1.0 - v4BorderMask.a);
        else
            fBorderAlpha = v4BorderMask.r * (1.0 - v4BorderMask.a);

        fAlphaDst = max(fBorderAlpha + v4Result.a - (fBorderAlpha * v4Result.a), 0.0001);

        v4Result = (v4Result * (1.0 - fBorderAlpha) * v4Result.a + v4ColorBorder * fBorderAlpha) / fAlphaDst;
        v4Result.a = fAlphaDst;
    }

    fAlphaDst = v4Src.a + v4Result.a - (v4Src.a * v4Result.a);
    v4Result = (v4Result * (1.0 - v4Src.a) * v4Result.a + v4Src * v4Src.a) / fAlphaDst;
    v4Result.a = fAlphaDst * u_Opacity;

    gl_FragColor = v4Result;
}