#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureMask;

precision highp float;

uniform vec2 u_BlockSize;
uniform float u_Scale;
uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

	vec2 v2Center = (floor(v_texCoords / u_BlockSize) + vec2(0.5)) * u_BlockSize;
	vec2 v2ScaleCoord = (v_texCoords - v2Center) * u_Scale + v2Center;
	vec4 v4GlassTile = texture2D(u_texture0, v2ScaleCoord);

	if(u_InverseArea > 0)
		fMask = 1.0 - fMask;

	gl_FragColor = vec4(mix(v4Src, v4GlassTile, fMask).rgb, v4Src.a);
}
