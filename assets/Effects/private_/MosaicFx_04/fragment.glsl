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
uniform float u_BlockSize;
uniform float u_EdgeBound;
uniform float u_Scale;
uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

	float fCenterX = (floor(v_texCoords.x / u_BlockSize) + 0.5) * u_BlockSize;
	float fScaleCoordX = (v_texCoords.x - fCenterX) * u_Scale + fCenterX;

	float fOffsetY = (texture2D(u_textureOffset, v_texCoords * u_OffsetScale).a - 0.5) * 0.01;
	vec4 v4GlassTile = texture2D(u_texture0, vec2(fScaleCoordX, v_texCoords.y + fOffsetY));

	if(abs(v_texCoords.x - fCenterX) > u_EdgeBound)
		v4GlassTile *= 1.2;

	if(u_InverseArea > 0)
		fMask = 1.0 - fMask;

	gl_FragColor = vec4(mix(v4Src, v4GlassTile, fMask).rgb, v4Src.a);
}
