#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureBlur;
uniform sampler2D u_textureDodge;


precision mediump float;

uniform float u_AdjustLevel;

vec4 v4One = vec4(1.0, 1.0, 1.0, 1.0);
vec4 v4Zero = vec4(0.00392, 0.00392, 0.00392, 0.00392);

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Blur = texture2D(u_textureBlur, v_texCoords);

    vec4 v4Unsharp = (v4Src + ((v4Src - v4Blur) * 4.0));
    v4Unsharp = min(max(v4Unsharp, v4Zero), v4One) * 0.882353;

    vec4 v4ColorDodge = max(v4Zero, (v4One - texture2D(u_textureDodge, v_texCoords)));
    v4ColorDodge = min(max(v4Unsharp / v4ColorDodge, v4Zero), v4One);
    float fLum = dot(v4ColorDodge, vec4(0.257, 0.504, 0.098, 0.0)) + 0.062745;
    fLum = (max(0.0, fLum - u_AdjustLevel) / (1.0 - u_AdjustLevel));
    fLum = min(max(fLum, 0.0), 1.0) * 0.882353;

// Find HS of Unsharp image
    float Cmax = max(max(v4Unsharp.r, v4Unsharp.g), v4Unsharp.b);
    float Cmin = min(min(v4Unsharp.r, v4Unsharp.g), v4Unsharp.b);
    float fDelta = Cmax - Cmin;
    float fDeltaR = 1.0 / fDelta;

    float fHOrg;
    float fLOrg = (Cmax + Cmin) * 0.5;
    float fSOrg = fDelta / (1.0 - abs(fLOrg * 2.0 - 1.0));

    if(fDelta == 0.0)
        fHOrg = 0.0;
    else if(Cmax == v4Unsharp.r)
        fHOrg = mod((v4Unsharp.g - v4Unsharp.b) * fDeltaR + 6.0, 6.0);
    else if(Cmax == v4Unsharp.g)
        fHOrg = (v4Unsharp.b - v4Unsharp.r) * fDeltaR + 2.0;
    else if(Cmax == v4Unsharp.b)
        fHOrg = (v4Unsharp.r - v4Unsharp.g) * fDeltaR + 4.0;

// Use new Lum to get final RGB
    float fC = (1.0 - abs(fLum * 2.0 - 1.0)) * fSOrg;
    float fX = fC * (1.0 - abs(mod(fHOrg, 2.0) - 1.0));
    float m = fLum - (fC * 0.5);

    if(fHOrg < 1.0)
    	gl_FragColor = vec4(vec3(fC, fX, 0.0) + m, v4Src.a);
    else if(fHOrg < 2.0)
    	gl_FragColor = vec4(vec3(fX, fC, 0.0) + m, v4Src.a);
    else if(fHOrg < 3.0)
    	gl_FragColor = vec4(vec3(0.0, fC, fX) + m, v4Src.a);
    else if(fHOrg < 4.0)
    	gl_FragColor = vec4(vec3(0.0, fX, fC) + m, v4Src.a);
    else if(fHOrg < 5.0)
    	gl_FragColor = vec4(vec3(fX, 0.0, fC) + m, v4Src.a);
    else
    	gl_FragColor = vec4(vec3(fC, 0.0, fX) + m, v4Src.a);
}