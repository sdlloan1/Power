#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;

uniform float fDegree;
uniform int uMaskType;
uniform vec2 uMaskSize;
uniform vec2 uMaskCenter;
uniform vec2 uMaskSqr;
uniform vec2 uGradientDepth;
uniform int uInverseMask;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);

    float fYMinus16 = (65.738 * v4Src.r) + (129.057 * v4Src.g) + (25.064 * v4Src.b);
    float fCbMinus128 = -(37.945 * v4Src.r) - (74.494 * v4Src.g) + (112.439 * v4Src.b);
    float fCrMinus128 = (112.439 * v4Src.r) - (94.154 * v4Src.g) - (18.285 * v4Src.b);

    fCbMinus128 = fCbMinus128 * fDegree;
    fCrMinus128 = fCrMinus128 * fDegree;
    fYMinus16 = fYMinus16 * 0.0045662100456621;

    float fR = fYMinus16 + fCrMinus128 * 0.0062589285714286;
    float fG = fYMinus16 - fCbMinus128 * 0.0015363227062546 - fCrMinus128 * 0.0031881084205403;
    float fB = fYMinus16 + fCbMinus128 * 0.0079107142857143;

    vec4 v4Res;
    if(uMaskType == 0) // Box
    {
        vec2 v2Dis = abs(v_texCoords - uMaskCenter);
        vec2 v2Ratio = clamp((uMaskSize - v2Dis) / uGradientDepth, 0.0, 1.0);
        float fRatio = min(v2Ratio.x, v2Ratio.y) * v4Src.a;
        if(uInverseMask > 0)
            v4Res = mix(vec4(fR, fG, fB, 1.0), texture2D(u_texture0, v_texCoords), fRatio);
        else
            v4Res = mix(texture2D(u_texture0, v_texCoords), vec4(fR, fG, fB, 1.0), fRatio);
    }
    else //if(uMaskType == 1) // Circle
    {
        vec2 v2Dis = v_texCoords - uMaskCenter;
        v2Dis = v2Dis * v2Dis / uMaskSqr;
        float fRatio = (1.0 - (v2Dis.x + v2Dis.y)) / uGradientDepth.x;
        fRatio = clamp(fRatio, 0.0, 1.0) * v4Src.a;
        if(uInverseMask > 0)
            v4Res = mix(vec4(fR, fG, fB, 1.0), texture2D(u_texture0, v_texCoords), fRatio);
        else
            v4Res = mix(texture2D(u_texture0, v_texCoords), vec4(fR, fG, fB, 1.0), fRatio);
    }

    gl_FragColor = v4Res;
}
