#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

uniform sampler2D u_textureContrast;
uniform sampler2D u_textureEllipsePos;
uniform sampler2D u_textureLomoContrast;

precision highp float;

uniform mat4 u_RGB2YUV;
uniform mat4 u_YUV2RGB;

uniform float u_CenterLight;
uniform float u_Brightness;
uniform float u_Saturation;

varying vec2 v_texCoords;

vec4 v4YUVOffset = vec4(0.062745, 0.5, 0.5, 0.0);
vec4 v4One = vec4(1.0, 1.0, 1.0, 1.0);
vec4 v4Zero = vec4(0.0, 0.0, 0.0, 0.0);

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    float fOrgAlpha = v4Src.a;
    v4Src.r = texture2D(u_textureContrast, vec2(v4Src.r + 0.0015, 0.5)).a;
    v4Src.g = texture2D(u_textureContrast, vec2(v4Src.g + 0.0015, 0.5)).a;
    v4Src.b = texture2D(u_textureContrast, vec2(v4Src.b + 0.0015, 0.5)).a;
    v4Src.a = 1.0;

    vec4 v4YUV = u_RGB2YUV * v4Src;

    vec4 v4Mask = texture2D(u_textureEllipsePos, v_texCoords);
    float fMaskVal = v4Mask.b + v4Mask.a / 256.0;

    v4YUV.r = min(max(0.0, (v4YUV.r * u_CenterLight) * (1.0 - fMaskVal)) + u_Brightness, 1.0);

    vec4 v4DstRGB = u_YUV2RGB * (v4YUV - vec4(0.062745, 0.5, 0.5, 0.0));
    v4DstRGB = max(min(v4DstRGB, v4One), v4Zero);

    float Cmax = max(max(v4DstRGB.r, v4DstRGB.g), v4DstRGB.b);
    float Cmin = min(min(v4DstRGB.r, v4DstRGB.g), v4DstRGB.b);
    float fDelta = Cmax - Cmin;
    float fDeltaR = 1.0 / fDelta;

    float fHOrg;
    float fLOrg = (Cmax + Cmin) * 0.5;
    float fSOrg = fDelta / (1.0 - abs(fLOrg * 2.0 - 1.0));

    if(fDelta == 0.0)
        fHOrg = 0.0;
    else if(Cmax == v4DstRGB.r)
        fHOrg = mod((v4DstRGB.g - v4DstRGB.b) * fDeltaR + 6.0, 6.0);
    else if(Cmax == v4DstRGB.g)
        fHOrg = (v4DstRGB.b - v4DstRGB.r) * fDeltaR + 2.0;
    else if(Cmax == v4DstRGB.b)
        fHOrg = (v4DstRGB.r - v4DstRGB.g) * fDeltaR + 4.0;

    fSOrg = min(fSOrg * u_Saturation, 1.0);

    float fC = (1.0 - abs(fLOrg * 2.0 - 1.0)) * fSOrg;
    float fX = fC * (1.0 - abs(mod(fHOrg, 2.0) - 1.0));
    float m = fLOrg - (fC * 0.5);

    vec4 v4Res;
    if(fHOrg < 1.0)
    	v4Res = vec4(vec3(fC, fX, 0.0) + m, 1.0);
    else if(fHOrg < 2.0)
    	v4Res = vec4(vec3(fX, fC, 0.0) + m, 1.0);
    else if(fHOrg < 3.0)
    	v4Res = vec4(vec3(0.0, fC, fX) + m, 1.0);
    else if(fHOrg < 4.0)
    	v4Res = vec4(vec3(0.0, fX, fC) + m, 1.0);
    else if(fHOrg < 5.0)
    	v4Res = vec4(vec3(fX, 0.0, fC) + m, 1.0);
    else
    	v4Res = vec4(vec3(fC, 0.0, fX) + m, 1.0);

    v4Res.g += 0.078431372549;

    v4Res.r = texture2D(u_textureLomoContrast, vec2(v4Res.r + 0.0015, 0.5)).a;
    v4Res.g = texture2D(u_textureLomoContrast, vec2(v4Res.g + 0.0015, 0.5)).a;
    v4Res.b = texture2D(u_textureLomoContrast, vec2(v4Res.b + 0.0015, 0.5)).a;

    gl_FragColor = vec4(v4Res.rgb, fOrgAlpha);
}