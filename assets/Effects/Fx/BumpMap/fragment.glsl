#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform vec2 u_TexelShift;
uniform float u_Scale;

varying vec2 v_texCoords;

void main()
{
	vec4 f4Diff = texture2D(u_texture0, v_texCoords + u_TexelShift) - texture2D(u_texture0, v_texCoords - u_TexelShift);
    float fVal = dot(f4Diff,  vec4(0.257, 0.504, 0.098, 0.0)) * u_Scale;

    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Res = v4Src + vec4(fVal, fVal, fVal, 0.0);

	gl_FragColor = vec4(v4Res.rgb, v4Src.a);
}