#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureBlurSrc;
uniform sampler2D u_textureMask;

precision mediump float;

uniform vec2 u_BlockSize;
uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

	vec2 v2MosaicCoord = (floor(v_texCoords / u_BlockSize) + vec2(0.5)) * u_BlockSize;
	vec4 v4Mosaic = texture2D(u_textureBlurSrc, v2MosaicCoord);

	if(u_InverseArea > 0)
		fMask = 1.0 - fMask;

	gl_FragColor = vec4(mix(v4Src, v4Mosaic, fMask).rgb, v4Src.a);
}
