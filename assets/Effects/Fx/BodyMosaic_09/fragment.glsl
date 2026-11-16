#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

uniform sampler2D u_textureBlurSrc;
uniform sampler2D u_textureMask;

precision highp float;

uniform vec2 u_BlockNumber;
uniform vec2 u_BlockSize;
uniform int u_InverseArea;

varying vec2 v_texCoords;

void main(){

	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fMask = texture2D(u_textureMask, v_texCoords).r;

	vec2 v2TxCoord = floor(v_texCoords * u_BlockNumber) / u_BlockNumber;
	vec2 v2fract = fract(v_texCoords / u_BlockSize);
	vec2 v2Center = v2TxCoord + u_BlockSize * 0.5;
	vec2 v2XY = v_texCoords - v2Center;

	float ellipseVal = dot((v2XY * v2XY) / (u_BlockSize * u_BlockSize * 0.25), vec2(1.0));

	if(ellipseVal > 1.0)
		v2TxCoord += floor(v2fract + vec2(0.5)) * u_BlockSize;
	else
		v2TxCoord = v2Center;

	vec4 v4Mosaic = texture2D(u_textureBlurSrc, v2TxCoord);

	if(u_InverseArea > 0)
		fMask = 1.0 - fMask;

	gl_FragColor = vec4(mix(v4Src, v4Mosaic, fMask).rgb, v4Src.a);
}
