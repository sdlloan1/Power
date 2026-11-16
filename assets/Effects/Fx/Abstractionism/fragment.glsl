#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureRes;

precision mediump float;

uniform vec2 u_TexelShift;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Src1 = texture2D(u_textureRes, v_texCoords + u_TexelShift);
    vec4 v4Src2 = texture2D(u_textureRes, v_texCoords - u_TexelShift);
    float fVal = dot(v4Src1.rgb, vec3(0.257, 0.504, 0.098)) - dot(v4Src2.rgb, vec3(0.257, 0.504, 0.098));
//	vec4 f4Diff = texture2D(u_texture0, v_texCoords + u_TexelShift) - texture2D(u_texture0, v_texCoords - u_TexelShift);
//    float fVal = dot(f4Diff.rgb,  vec3(0.257, 0.504, 0.098)) + 0.062745;
    fVal = (clamp(fVal + 0.5, 0.0, 1.0) - 0.5) * 3.0;

    vec4 v4Result = texture2D(u_textureRes, v_texCoords) + vec4(fVal, fVal, fVal, 0.0);
	gl_FragColor = vec4(v4Result.rgb, texture2D(u_texture0, v_texCoords).a);
}