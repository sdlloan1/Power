#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);

    float Cmax = max(max(v4Src.r, v4Src.g), v4Src.b);
    float Cmin = min(min(v4Src.r, v4Src.g), v4Src.b);
    float fDelta = Cmax - Cmin;
    float fDeltaR = 1.0 / fDelta;

    float fHOrg;
    float fLOrg = (Cmax + Cmin) * 0.5;
    float fSOrg = fDelta / (1.0 - abs(fLOrg * 2.0 - 1.0));

    if(fDelta == 0.0)
        fHOrg = 0.0;
    else if(Cmax == v4Src.r)
        fHOrg = mod((v4Src.g - v4Src.b) * fDeltaR + 6.0, 6.0);
    else if(Cmax == v4Src.g)
        fHOrg = (v4Src.b - v4Src.r) * fDeltaR + 2.0;
    else if(Cmax == v4Src.b)
        fHOrg = (v4Src.r - v4Src.g) * fDeltaR + 4.0;

  	gl_FragColor = vec4(fHOrg * 0.1666667, fSOrg, fLOrg, v4Src.a);
}