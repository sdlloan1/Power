precision mediump float;

uniform sampler2D u_textureSrc1;
uniform sampler2D u_textureSrc2;
uniform sampler2D u_textureMedian1;
uniform sampler2D u_textureMedian2;
uniform sampler2D u_textureEdge1;
uniform sampler2D u_textureEdge2;
uniform float u_EdgeEnhance;

uniform float u_ProgressFadeInBegin;
uniform float u_ProgressFadeOutEnd;

uniform float u_Progress;

varying vec2 v_texCoords;

void main(){

    if(u_Progress < u_ProgressFadeInBegin)
    {
        float fRatio = min(u_Progress / u_ProgressFadeOutEnd * 2.0, 1.0);
        vec4 v4Mix = mix(texture2D(u_textureSrc1, v_texCoords), texture2D(u_textureMedian1, v_texCoords), fRatio);
        vec4 v4Edge = texture2D(u_textureEdge1, v_texCoords) * min(u_Progress * 2.0/ u_ProgressFadeOutEnd, 1.0);
        gl_FragColor = v4Mix + v4Edge * u_EdgeEnhance;
    }
    else if(u_Progress > u_ProgressFadeOutEnd)
    {
        float fRatio = min((1.0 - u_Progress) / (1.0 - u_ProgressFadeInBegin) * 2.0, 1.0);
        vec4 v4Mix = mix(texture2D(u_textureSrc2, v_texCoords), texture2D(u_textureMedian2, v_texCoords), fRatio);
        vec4 v4Edge = texture2D(u_textureEdge2, v_texCoords) * min((1.0 - u_Progress) * 2.0 / (1.0 - u_ProgressFadeInBegin), 1.0);
        gl_FragColor = v4Mix + v4Edge * u_EdgeEnhance;
    }
    else
    {
        float fRatio = min(u_Progress / u_ProgressFadeOutEnd * 2.0, 1.0);
        vec4 v4MixFadeOut = mix(texture2D(u_textureSrc1, v_texCoords), texture2D(u_textureMedian1, v_texCoords), fRatio);
        fRatio = min((1.0 - u_Progress) / (1.0 - u_ProgressFadeInBegin) * 2.0, 1.0);
        vec4 v4MixFadeIn = mix(texture2D(u_textureSrc2, v_texCoords), texture2D(u_textureMedian2, v_texCoords), fRatio);
        vec4 v4MixRes = mix(v4MixFadeOut, v4MixFadeIn, (u_Progress - u_ProgressFadeInBegin) / (u_ProgressFadeOutEnd - u_ProgressFadeInBegin));
        v4MixRes = clamp(v4MixRes - vec4(1.0 - abs(u_Progress - 0.5) / (u_ProgressFadeOutEnd - 0.5)), vec4(0.0), vec4(1.0));

        vec4 v4EdgeFadeOut = texture2D(u_textureEdge1, v_texCoords) * min(u_Progress * 2.0 / u_ProgressFadeOutEnd, 1.0);
        vec4 v4EdgeFadeIn = texture2D(u_textureEdge2, v_texCoords) * min((1.0 - u_Progress) * 2.0 / (1.0 - u_ProgressFadeInBegin), 1.0);
        vec4 v4MixEdge = mix(v4EdgeFadeOut, v4EdgeFadeIn, (u_Progress - u_ProgressFadeInBegin) / (u_ProgressFadeOutEnd - u_ProgressFadeInBegin));

        gl_FragColor = v4MixRes + v4MixEdge * u_EdgeEnhance;
    }

}
