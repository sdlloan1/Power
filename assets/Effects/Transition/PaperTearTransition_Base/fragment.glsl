#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_txTearing;
uniform sampler2D u_txTearingBlur;
uniform sampler2D u_txPageBack;

uniform vec2 u_Center;
uniform vec2 u_Direction;
uniform vec2 u_AspectRatio;

uniform float fProgress;
uniform float u_MaskRotate;
uniform vec2 u_MaskScale;
uniform float u_LightEfx;
uniform float u_ShadowWeight;
uniform float u_ShadowRange;
uniform float u_EdgeIntensity;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio + vec2(0.5);
    vec2 v2PaperCoord;
    vec4 v4TearingMask;
    vec4 v4TearingMaskBlur;

    float fDot = dot(v2TxCoord - u_Center, u_Direction);

// paper.r -> part to keep in first run.
// paper.g -> part to remove in first run.
// paper.r + g - 1 -> overlap of r & g, the white edge after the first run.

    if(fDot < 0.0)
    {
        vec2 v2TxCoordOffset = (v_texCoords - vec2(0.5)) * u_MaskScale;
        vec2 v2MaskCoords = vec2(v2TxCoordOffset.x * cos(u_MaskRotate) - v2TxCoordOffset.y * sin(u_MaskRotate) + 0.5, v2TxCoordOffset.x * sin(u_MaskRotate) + v2TxCoordOffset.y * cos(u_MaskRotate) + 0.5);
        v4TearingMask = texture2D(u_txTearing, v2MaskCoords);
        v4TearingMaskBlur = texture2D(u_txTearingBlur, v2MaskCoords);

        vec4 v4EdgeEfx = (v4TearingMask.r + v4TearingMask.g - 1.0) * 0.85 * texture2D(u_txPageBack, v2TxCoord);
        vec4 v4Res = mix(texture2D(u_texture1, v_texCoords), texture2D(u_texture0, v_texCoords), v4TearingMask.r) + vec4(v4EdgeEfx.rgb, 0.0);
//        vec4 v4Res = mix(texture2D(u_texture0, vec2(1.0) - v_texCoords), texture2D(u_texture0, v_texCoords), v4TearingMask.r) + vec4(fEdgeEfx, fEdgeEfx, fEdgeEfx, 0.0);
        float fShadow = smoothstep(-0.08, 0.0, fDot);
        fShadow = fShadow * fShadow * u_ShadowWeight * min(v4TearingMaskBlur.g, 1.0 - v4TearingMaskBlur.r);
        fShadow += max(v4TearingMaskBlur.r - v4TearingMask.r, 0.0) * u_ShadowWeight * 2.0;
        gl_FragColor = vec4((v4Res * (1.0 - fShadow)).rgb, v4Res.a);
    }
   	else
   	{
    	vec2 v2MirrorPos = v2TxCoord - u_Direction * fDot * 2.0;
        v2MirrorPos = (v2MirrorPos - vec2(0.5)) / u_AspectRatio + vec2(0.5);

        vec2 v2TxCoordOffset = (v2MirrorPos - vec2(0.5)) * u_MaskScale;
        vec2 v2MaskCoords = vec2(v2TxCoordOffset.x * cos(u_MaskRotate) - v2TxCoordOffset.y * sin(u_MaskRotate) + 0.5, v2TxCoordOffset.x * sin(u_MaskRotate) + v2TxCoordOffset.y * cos(u_MaskRotate) + 0.5);
        v4TearingMask = texture2D(u_txTearing, v2MaskCoords);
        v4TearingMaskBlur = texture2D(u_txTearingBlur, v2MaskCoords);

    	if((v2MirrorPos.x > 0.0) && (v2MirrorPos.x < 1.0) && (v2MirrorPos.y > 0.0) && (v2MirrorPos.y < 1.0))
    	{
            float fLight;
            if(fDot < 0.05)
                fLight = sin(fDot * 10.0 * 3.14159265359) * 0.5;
            else if(fDot < 0.25)
                fLight = (sin(((fDot - 0.05) * 5.0 + 0.5) * 3.14159265359) + 1.0) * 0.25;
            else
                fLight = 0.0;

            float fEdgeEfx = (v4TearingMask.r + v4TearingMask.g - 1.0) * u_EdgeIntensity;
            vec4 v4Res = vec4((texture2D(u_txPageBack, v2MirrorPos * u_AspectRatio) + vec4(fLight) * u_LightEfx + vec4(fEdgeEfx, fEdgeEfx, fEdgeEfx, 1.0)).rgb, 1.0);

            float fBound = min(min(abs(v2MirrorPos.x), abs(v2MirrorPos.x - 1.0)) * u_AspectRatio.x, min(abs(v2MirrorPos.y), abs(v2MirrorPos.y - 1.0)) * u_AspectRatio.y);
            fBound = smoothstep(0.0, 0.05, fBound);
            float fShadow = max(v4TearingMaskBlur.g - v4TearingMask.g, 0.0) * u_ShadowWeight * fBound * min(smoothstep(0.0, 0.03, fDot) + 0.1, 1.0);

        	gl_FragColor = mix(texture2D(u_texture0, v_texCoords) * (1.0 - fShadow), v4Res, v4TearingMask.g);
    	}
       	else
       	{
            float fShadowX = max(max(0.0 - v2MirrorPos.x, 0.0), max(v2MirrorPos.x - 1.0, 0.0)) * u_AspectRatio.x;
            float fShadowY = max(max(0.0 - v2MirrorPos.y, 0.0), max(v2MirrorPos.y - 1.0, 0.0)) * u_AspectRatio.y;
            float fShadow = smoothstep(1.0 - u_ShadowRange, 1.0, (1.0 - fShadowX) * (1.0 - fShadowY));
            fShadow = fShadow * fShadow * u_ShadowWeight * min(v4TearingMaskBlur.g, 1.0 - v4TearingMaskBlur.r);

            vec4 v4Res = texture2D(u_texture0, v_texCoords);
        	gl_FragColor = vec4((v4Res * (1.0 - fShadow)).rgb, v4Res.a);
       	}
   	}
}