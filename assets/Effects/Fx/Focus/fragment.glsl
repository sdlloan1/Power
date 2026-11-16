#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision highp float;

uniform vec4 u_v4BKColor;

uniform vec2 u_v2ViewDimension;
uniform vec2 u_v2FocusDimensionSqr;
uniform vec2 u_v2FocusCenter;
uniform float u_Depth;
uniform float u_Alpha;
uniform int uInverseMask;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec2 v2Dis = (v_texCoords - u_v2FocusCenter) * u_v2ViewDimension;
    v2Dis = v2Dis * v2Dis / u_v2FocusDimensionSqr;
    float fRatio = v2Dis.x + v2Dis.y;

    if(fRatio > u_Depth)
    {
        if(uInverseMask > 0) {
            gl_FragColor = v4Src;
        } else {
            gl_FragColor = vec4(mix(v4Src, u_v4BKColor, u_Alpha).rgb, v4Src.a);
        }
    }
    else if(fRatio >= 1.0)
    {
        float fSat;
        if(uInverseMask > 0) {
            fSat = (u_Depth - fRatio) / (u_Depth - 1.0);
        } else {
            fSat = (fRatio - 1.0) / (u_Depth - 1.0);
        }
        gl_FragColor = vec4(mix(v4Src, u_v4BKColor, u_Alpha * fSat).rgb, v4Src.a);
    }
    else {
        if(uInverseMask > 0) {
            gl_FragColor = vec4(mix(v4Src, u_v4BKColor, u_Alpha).rgb, v4Src.a);
        } else {
            gl_FragColor = v4Src;
        }
    }
}