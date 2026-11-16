#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision highp float;

uniform vec2 u_CoordRatio;
uniform vec2 u_Center;
uniform float u_RippleLength;
uniform float u_RippleOffset;
uniform float u_Amplitude;

varying vec2 v_texCoords;

void main()
{
    vec2 v2CoordAspect = v_texCoords * u_CoordRatio;
    float fDistance = distance(v2CoordAspect, u_Center) - u_RippleOffset;
    float fRatio = mod(fDistance, u_RippleLength) / u_RippleLength;
    float fDistortion = sin(fRatio * 6.2831853) * u_Amplitude;
    vec2 v2CoordOffset = normalize(v2CoordAspect - u_Center) * fDistortion;

    vec4 v4Dst = texture2D(u_texture0, v_texCoords + v2CoordOffset);
    gl_FragColor = vec4((v4Dst * (1.0 + fDistortion * 0.5)).rgb, v4Dst.a);
}