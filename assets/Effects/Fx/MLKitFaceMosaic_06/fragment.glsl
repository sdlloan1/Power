#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureMask;
uniform sampler2D u_textureOffset;

precision highp float;

uniform vec2 u_OffsetScale;
uniform float u_Degree;
uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

	vec2 v2Offset = (texture2D(u_textureOffset, v_texCoords * u_OffsetScale).rg - vec2(0.5)) * u_Degree;
	vec4 v4Glass = texture2D(u_texture0, v_texCoords + v2Offset);

	if(u_InverseArea > 0)
		fMask = 1.0 - fMask;

	gl_FragColor = vec4(mix(v4Src, v4Glass, fMask).rgb, v4Src.a);
}
