#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision highp float;

uniform vec2 u_AspectRatio;
uniform vec2 u_Center;
uniform float u_RippleLength;
uniform float u_Amplitude;
uniform float u_RippleOffset[3];

varying vec2 v_texCoords;

void main()
{
    vec2 v2Pos = (v_texCoords - u_Center) * u_AspectRatio;
    float fDistance = length(v2Pos);
    vec2 v2WaveDirection = normalize(v2Pos);

    float fWeight = 0.0;
    for(int index = 0 ; index < 3 ; ++index)
    {
        float fProgress = clamp(u_RippleOffset[index] - fDistance, 0.0, u_RippleLength) / u_RippleLength;
        fWeight += sin(fProgress * 6.2831853) * (1.0 - fProgress * 0.8);
    }

    vec2 v2SamplingOffset = v2WaveDirection * fWeight * u_Amplitude;

    vec4 v4Dst = texture2D(u_texture0, v_texCoords + v2SamplingOffset);
    gl_FragColor = vec4((v4Dst * (1.0 + fWeight * u_Amplitude * 7.0)).rgb, v4Dst.a);
}