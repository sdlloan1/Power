#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform vec4 u_MaskColor;
uniform float u_Start;
uniform float u_End;

varying vec2 v_texCoords;

void main()
{
    float fFade = (v_texCoords.y - u_Start) / (u_End - u_Start);
    fFade = 1.0 - clamp(fFade, 0.0, 1.0);

    vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Res = mix(v4Src, u_MaskColor, u_MaskColor.a * fFade);
	gl_FragColor = vec4(v4Res.rgb, v4Src.a);
}