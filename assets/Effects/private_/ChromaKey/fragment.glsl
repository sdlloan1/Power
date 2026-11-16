#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
 uniform samplerExternalOES u_texture0;
#else
 uniform sampler2D u_texture0;
#endif

precision mediump float;

uniform vec2 u_CbCr2X;
uniform vec2 u_CbCr2Z;

uniform vec2 u_XZ2Cb;
uniform vec2 u_XZ2Cr;

uniform float u_KeyX;
uniform float u_YScale;
uniform float u_Angle;
uniform float u_Tangent;
uniform float u_CoTangent;
uniform float u_DeNoise;

varying vec2 v_texCoords;

void main()
{
    mat4 u_RGB2YCbCr = mat4(
        vec4(0.299,	-0.169,    0.5, 0.0),
        vec4(0.587, -0.331, -0.419, 0.0),
        vec4(0.114,    0.5, -0.081, 0.0),
        vec4(  0.0,    0.0,    0.0, 1.0));

    mat4 u_YCbCr2RGB = mat4(
        vec4(1.0,    1.0,   1.0, 0.0),
        vec4(0.0, -0.343, 1.765, 0.0),
        vec4(1.4, -0.711,   0.0, 0.0),
        vec4(0.0,    0.0,   0.0, 1.0));

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4YCbCr = u_RGB2YCbCr * v4Src;
    vec4 v4Res = v4Src;

    if(u_KeyX > 0.01)
    {
        float fX = dot(v4YCbCr.gb, u_CbCr2X);
        float fZ = dot(v4YCbCr.gb, u_CbCr2Z);

        float fZBoundary = fX * u_Tangent;
        if(abs(fZ) < fZBoundary)
        {
            float fXMap = abs(fZ * u_CoTangent);
            float fXMapDiff = fX - fXMap;

            v4YCbCr.r = max(v4YCbCr.r - (u_YScale * fXMapDiff), 0.0);
            v4YCbCr.g = dot(vec2(fXMap, fZ), u_XZ2Cb);
            v4YCbCr.b = dot(vec2(fXMap, fZ), u_XZ2Cr);

            v4Res = u_YCbCr2RGB * v4YCbCr;

            v4Res.a = clamp(1.0 - (fXMapDiff / u_KeyX), 0.0, 1.0);
            v4Res.a = v4Res.a * v4Res.a * v4Res.a;

            if(((fX - u_KeyX) * (fX - u_KeyX) + (fZ * fZ)) < (u_DeNoise * u_DeNoise))
                v4Res.a = 0.0;
        }
    }
    else
    {
        float fDiffY = abs(v4YCbCr.r - u_YScale);
        float fMax = max(max(v4Src.r, v4Src.g), v4Src.b);
        float fMin = min(min(v4Src.r, v4Src.g), v4Src.b);
        float fChroma = fMax - fMin;

        if((fDiffY < u_DeNoise) && (fChroma < u_Angle))
            v4Res.a = v4Src.a * fDiffY * fChroma / (u_DeNoise * u_Angle);
    }

    gl_FragColor = v4Res;
}
